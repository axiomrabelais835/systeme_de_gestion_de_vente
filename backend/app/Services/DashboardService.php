<?php

declare(strict_types=1);

namespace App\Services;

use App\Enums\SaleStatus;
use App\Models\Customer;
use App\Models\Product;
use App\Models\Sale;
use App\Models\SaleItem;
use Illuminate\Support\Carbon;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;

/**
 * Statistiques du tableau de bord. Toutes les requêtes sont indexées et
 * limitent les agrégats aux ventes VALIDÉES (hors annulées).
 */
class DashboardService
{
    /**
     * @return array<string, mixed>
     */
    public function summary(): array
    {
        $today = Carbon::today();
        $weekStart = Carbon::now()->startOfWeek(Carbon::MONDAY);
        $monthStart = Carbon::now()->startOfMonth();

        $sales = Sale::query()->validated();

        $todayTotal = (clone $sales)->whereBetween('sold_at', [$today, $today->copy()->endOfDay()])->sum('total');
        $yesterdayTotal = (clone $sales)->whereBetween('sold_at', [$today->copy()->subDay(), $today->copy()->subDay()->endOfDay()])->sum('total');

        $weekTotal = (clone $sales)->where('sold_at', '>=', $weekStart)->sum('total');
        $prevWeekTotal = (clone $sales)->whereBetween('sold_at', [$weekStart->copy()->subWeek(), $weekStart->copy()->subSecond()])->sum('total');

        $monthTotal = (clone $sales)->where('sold_at', '>=', $monthStart)->sum('total');
        $prevMonthTotal = (clone $sales)->whereBetween('sold_at', [$monthStart->copy()->subMonth(), $monthStart->copy()->subSecond()])->sum('total');

        $monthCount = (clone $sales)->where('sold_at', '>=', $monthStart)->count();
        $averageBasket = $monthCount > 0 ? round($monthTotal / $monthCount, 2) : 0;

        $stockValue = Product::query()->sum(DB::raw('quantity * purchase_price'));

        $lowStockCount = Product::query()
            ->where('is_active', true)
            ->whereColumn('quantity', '<=', 'low_stock_threshold')
            ->where('quantity', '>', 0)
            ->count();

        $outOfStockCount = Product::query()->where('quantity', '<=', 0)->count();

        return [
            'revenue' => [
                'today' => round((float) $todayTotal, 2),
                'today_trend' => $this->trend($todayTotal, $yesterdayTotal),
                'week' => round((float) $weekTotal, 2),
                'week_trend' => $this->trend($weekTotal, $prevWeekTotal),
                'month' => round((float) $monthTotal, 2),
                'month_trend' => $this->trend($monthTotal, $prevMonthTotal),
            ],
            'sales_count' => [
                'today' => (clone $sales)->whereBetween('sold_at', [$today, $today->copy()->endOfDay()])->count(),
                'week' => (clone $sales)->where('sold_at', '>=', $weekStart)->count(),
                'month' => $monthCount,
            ],
            'average_basket' => round((float) $averageBasket, 2),
            'stock_value' => round((float) $stockValue, 2),
            'low_stock_count' => $lowStockCount,
            'out_of_stock_count' => $outOfStockCount,
            'products_count' => Product::query()->where('is_active', true)->count(),
            'customers_count' => Customer::query()->count(),
        ];
    }

    /**
     * Évolution du chiffre d'affaires : 7 jours, 30 jours ou 12 mois.
     *
     * @return list<array{period: string, label: string, total: float, count: int}>
     */
    public function salesChart(string $period = '30d'): array
    {
        $sales = Sale::query()->validated();

        return match ($period) {
            '7d' => $this->dailySeries($sales, 7),
            '12m' => $this->monthlySeries($sales, 12),
            default => $this->dailySeries($sales, 30),
        };
    }

    /**
     * @return list<array{product_id: int, name: string, sku: string, quantity: int, revenue: float}>
     */
    public function topProducts(int $limit = 5, string $period = '30d'): array
    {
        return SaleItem::query()
            ->selectRaw('product_id, SUM(quantity) as quantity, SUM(line_total) as revenue')
            ->whereHas('sale', function ($query) use ($period): void {
                $query->validated()->where('sold_at', '>=', $this->periodStart($period));
            })
            ->groupBy('product_id')
            ->orderByDesc('revenue')
            ->limit($limit)
            ->with('product:id,name,sku')
            ->get()
            ->map(fn (SaleItem $item): array => [
                'product_id' => $item->product_id,
                'name' => $item->product?->name ?? 'Produit supprimé',
                'sku' => $item->product?->sku ?? '—',
                'quantity' => (int) $item->quantity,
                'revenue' => round((float) $item->revenue, 2),
            ])
            ->all();
    }

    /**
     * @return list<array{category_id: int, name: string, revenue: float, percentage: float}>
     */
    public function salesByCategory(string $period = '30d'): array
    {
        $rows = SaleItem::query()
            ->join('products', 'products.id', '=', 'sale_items.product_id')
            ->join('categories', 'categories.id', '=', 'products.category_id')
            ->join('sales', 'sales.id', '=', 'sale_items.sale_id')
            ->where('sales.status', SaleStatus::Validee->value)
            ->where('sales.sold_at', '>=', $this->periodStart($period))
            ->groupBy('categories.id', 'categories.name')
            ->selectRaw('categories.id as category_id, categories.name, SUM(sale_items.line_total) as revenue')
            ->orderByDesc('revenue')
            ->get();

        $total = (float) $rows->sum('revenue');

        return $rows->map(fn ($row): array => [
            'category_id' => (int) $row->category_id,
            'name' => $row->name,
            'revenue' => round((float) $row->revenue, 2),
            'percentage' => $total > 0 ? round(((float) $row->revenue / $total) * 100, 1) : 0,
        ])->all();
    }

    /**
     * @return Collection<int, Sale>
     */
    public function recentSales(int $limit = 8): Collection
    {
        return Sale::query()
            ->with(['customer:id,name', 'user:id,name,role'])
            ->latest('sold_at')
            ->latest('id')
            ->limit($limit)
            ->get();
    }

    private function periodStart(string $period): Carbon
    {
        return match ($period) {
            '7d' => Carbon::today()->subDays(6),
            '12m' => Carbon::now()->startOfMonth()->subMonths(11),
            default => Carbon::today()->subDays(29),
        };
    }

    /**
     * @param  \Illuminate\Database\Eloquent\Builder<Sale>  $query
     * @return list<array{period: string, label: string, total: float, count: int}>
     */
    private function dailySeries($query, int $days): array
    {
        $rows = (clone $query)
            ->selectRaw('DATE(sold_at) as day, COUNT(*) as count, SUM(total) as total')
            ->where('sold_at', '>=', Carbon::today()->subDays($days - 1))
            ->groupBy('day')
            ->get()
            ->keyBy('day');

        $series = [];
        for ($i = $days - 1; $i >= 0; $i--) {
            $date = Carbon::today()->subDays($i);
            $key = $date->toDateString();
            $row = $rows->get($key);
            $series[] = [
                'period' => $key,
                'label' => $date->format('d/m'),
                'total' => round((float) ($row->total ?? 0), 2),
                'count' => (int) ($row->count ?? 0),
            ];
        }

        return $series;
    }

    /**
     * @return list<array{period: string, label: string, total: float, count: int}>
     */
    private function monthlySeries($query, int $months): array
    {
        $rows = (clone $query)
            ->selectRaw("DATE_FORMAT(sold_at, '%Y-%m') as month, COUNT(*) as count, SUM(total) as total")
            ->where('sold_at', '>=', Carbon::now()->startOfMonth()->subMonths($months - 1))
            ->groupBy('month')
            ->get();

        $byMonth = [];
        foreach ($rows as $row) {
            $byMonth[$row->month] = ['total' => (float) $row->total, 'count' => (int) $row->count];
        }

        $series = [];
        for ($i = $months - 1; $i >= 0; $i--) {
            $date = Carbon::now()->startOfMonth()->subMonths($i);
            $key = $date->format('Y-%m');
            $series[] = [
                'period' => $key,
                'label' => $date->format('m/Y'),
                'total' => round($byMonth[$key]['total'] ?? 0, 2),
                'count' => $byMonth[$key]['count'] ?? 0,
            ];
        }

        return $series;
    }

    private function trend(float|string $current, float|string $previous): ?float
    {
        $current = (float) $current;
        $previous = (float) $previous;

        if ($previous <= 0) {
            return $current > 0 ? 100.0 : null;
        }

        return round((($current - $previous) / $previous) * 100, 1);
    }
}
