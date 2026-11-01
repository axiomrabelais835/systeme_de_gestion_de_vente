<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\ApiController;
use App\Http\Requests\CancelSaleRequest;
use App\Http\Requests\StoreSaleRequest;
use App\Http\Resources\SaleResource;
use App\Models\Sale;
use App\Services\SaleService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\StreamedResponse;

class SaleController extends ApiController
{
    public function __construct(private readonly SaleService $saleService) {}

    public function index(Request $request): JsonResponse
    {
        $query = Sale::query()
            ->with(['customer:id,name', 'user:id,name,role'])
            ->withCount('items')
            ->betweenDates($request->string('date_from')->toString() ?: null, $request->string('date_to')->toString() ?: null)
            ->searchReference($request->string('q')->toString())
            ->when($request->filled('customer_id'), fn ($q) => $q->where('customer_id', $request->integer('customer_id')))
            ->when($request->filled('status'), fn ($q) => $q->where('status', $request->string('status')->toString()))
            ->when($request->filled('payment_method'), fn ($q) => $q->where('payment_method', $request->string('payment_method')->toString()))
            ->when($request->filled('user_id'), fn ($q) => $q->where('user_id', $request->integer('user_id')));

        $sort = $request->string('sort', '-sold_at')->toString();
        $direction = str_starts_with($sort, '-') ? 'desc' : 'asc';
        $field = ltrim($sort, '-');
        $allowed = ['sold_at', 'total', 'reference', 'status'];
        $query->orderBy(in_array($field, $allowed, true) ? $field : 'sold_at', $direction);
        if (! in_array($field, $allowed, true)) {
            $query->latest('id');
        }

        $sales = $query->paginate($this->perPage($request));

        return $this->success(
            SaleResource::collection($sales)->resolve(),
            200,
            $this->pageMeta($sales)
        );
    }

    /**
     * Création d'une vente : transaction + verrouillage stock (SaleService).
     */
    public function store(StoreSaleRequest $request): JsonResponse
    {
        $sale = $this->saleService->create($request->validated(), $request->user());

        return $this->success(new SaleResource($sale), 201);
    }

    public function show(Request $request, Sale $sale): JsonResponse
    {
        $sale->load(['items.product:id,name,sku,selling_price', 'customer:id,name,phone,email', 'user:id,name,role']);

        return $this->success(new SaleResource($sale));
    }

    /**
     * Annulation : réintègre le stock, crée les mouvements, statut « annulée ».
     */
    public function cancel(CancelSaleRequest $request, Sale $sale): JsonResponse
    {
        $cancelled = $this->saleService->cancel($sale, $request->validated('reason'), $request->user());

        return $this->success(new SaleResource($cancelled));
    }

    /**
     * Export CSV des ventes (mêmes filtres que l'index).
     */
    public function export(Request $request): StreamedResponse
    {
        $query = Sale::query()
            ->with(['customer:id,name', 'user:id,name,role', 'items.product:id,name,sku'])
            ->betweenDates($request->string('date_from')->toString() ?: null, $request->string('date_to')->toString() ?: null)
            ->searchReference($request->string('q')->toString())
            ->when($request->filled('customer_id'), fn ($q) => $q->where('customer_id', $request->integer('customer_id')))
            ->when($request->filled('status'), fn ($q) => $q->where('status', $request->string('status')->toString()))
            ->when($request->filled('payment_method'), fn ($q) => $q->where('payment_method', $request->string('payment_method')->toString()))
            ->orderByDesc('sold_at')
            ->orderByDesc('id')
            ->cursor();

        $filename = 'ventes-'.now()->format('Ymd-His').'.csv';

        return response()->streamDownload(function () use ($query): void {
            $handle = fopen('php://output', 'w');
            fwrite($handle, "\xEF\xBB\xBF"); // BOM UTF-8 pour Excel.

            fputcsv($handle, [
                'Référence', 'Date', 'Client', 'Vendeur', 'Statut',
                'Sous-total', 'Remise', 'Taxe', 'Total',
                'Mode de paiement', 'Statut paiement', 'Articles',
            ], ';');

            foreach ($query as $sale) {
                $items = $sale->items->map(
                    fn ($item) => sprintf('%s x%d', $item->product?->name ?? 'Produit supprimé', $item->quantity)
                )->implode(' | ');

                fputcsv($handle, [
                    $sale->reference,
                    $sale->sold_at?->format('d/m/Y H:i'),
                    $sale->customer?->name ?? 'Client de passage',
                    $sale->user?->name ?? '—',
                    $sale->status->label(),
                    $sale->subtotal,
                    $sale->discount,
                    $sale->tax,
                    $sale->total,
                    $sale->payment_method->label(),
                    $sale->payment_status->label(),
                    $items,
                ], ';');
            }

            fclose($handle);
        }, $filename, [
            'Content-Type' => 'text/csv; charset=UTF-8',
        ]);
    }
}
