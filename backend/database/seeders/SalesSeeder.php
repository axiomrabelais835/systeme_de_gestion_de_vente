<?php

declare(strict_types=1);

namespace Database\Seeders;

use App\Enums\MovementType;
use App\Enums\PaymentMethod;
use App\Enums\PaymentStatus;
use App\Enums\SaleStatus;
use App\Models\Customer;
use App\Models\Product;
use App\Models\Sale;
use App\Models\StockMovement;
use App\Models\User;
use Illuminate\Database\Eloquent\Collection as EloquentCollection;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class SalesSeeder extends Seeder
{
    /**
     * 150 ventes réparties sur 6 mois (dont ~8 % annulées), avec lignes de vente
     * et mouvements de stock cohérents : à la fin du seeder, la somme des mouvements
     * de chaque produit est exactement égale à son stock.
     */
    public function run(): void
    {
        if (Sale::query()->exists()) {
            return;
        }

        $products = Product::query()
            ->orderBy('id')
            ->get(['id', 'selling_price', 'quantity']);

        $remaining = $products->pluck('quantity', 'id')->all();
        $prices = $products->pluck('selling_price', 'id')->all();
        $users = User::query()->get(['id', 'role']);
        $customers = Customer::query()->get(['id']);

        $now = now();
        $start = $now->copy()->subMonths(6);

        // Mouvements hors ventes (réapprovisionnements, inventaires) sur la période.
        $extraMovements = $this->buildExtraMovements($products, $remaining, $users, $start, $now);

        // Génération des brouillons de vente (décrémente $remaining en mémoire).
        $drafts = [];
        while (count($drafts) < 150) {
            $draft = $this->buildSaleDraft($remaining, $prices, $users, $customers, $start, $now);

            if ($draft === null) {
                break; // Plus aucun stock disponible.
            }

            $drafts[] = $draft;
        }

        // Tri chronologique pour une numérotation de références cohérente.
        usort($drafts, fn (array $a, array $b): int => $a['sold_at'] <=> $b['sold_at']);

        // Environ 8 % des ventes sont annulées : leur stock est réintégré au moment
        // de la construction des lignes (voir ci-dessous), si bien qu'à la fin
        // $remaining est exactement égal au stock mouvementé.
        $cancelledCount = (int) round(count($drafts) * 0.08);
        $cancelledKeys = array_rand(
            array_fill_keys(array_keys($drafts), true),
            min($cancelledCount, count($drafts))
        );

        $saleRows = [];
        $counters = [];

        foreach ($drafts as $key => $draft) {
            $year = (int) $draft['sold_at']->format('Y');
            $counters[$year] = ($counters[$year] ?? 0) + 1;
            $reference = sprintf('VTE-%d-%06d', $year, $counters[$year]);

            $isCancelled = in_array($key, $cancelledKeys, true);
            $discount = $draft['discount'];
            $subtotal = $draft['subtotal'];
            $tax = round(($subtotal - $discount) * 0.18, 2);

            // Une vente annulée n'a aucun impact sur le stock : on réintègre
            // le décrément effectué lors de la génération du brouillon.
            if ($isCancelled) {
                foreach ($draft['lines'] as $line) {
                    $remaining[$line['product_id']] += $line['quantity'];
                }
            }

            $drafts[$key]['reference'] = $reference;
            $drafts[$key]['is_cancelled'] = $isCancelled;

            $saleRows[] = [
                'reference' => $reference,
                'customer_id' => $draft['customer_id'],
                'user_id' => $draft['user_id'],
                'subtotal' => $subtotal,
                'discount' => $discount,
                'tax' => $tax,
                'total' => round($subtotal - $discount + $tax, 2),
                'payment_method' => $draft['payment_method'],
                'payment_status' => $draft['payment_status'],
                'status' => $isCancelled ? SaleStatus::Annulee->value : SaleStatus::Validee->value,
                'sold_at' => $draft['sold_at']->format('Y-m-d H:i:s'),
                'cancelled_at' => $isCancelled
                    ? $draft['sold_at']->copy()->addHours(rand(1, 48))->format('Y-m-d H:i:s')
                    : null,
                'cancel_reason' => $isCancelled ? 'Annulation demandée par le client' : null,
                'created_at' => $draft['sold_at']->format('Y-m-d H:i:s'),
                'updated_at' => $draft['sold_at']->format('Y-m-d H:i:s'),
            ];
        }

        foreach (array_chunk($saleRows, 200) as $chunk) {
            Sale::query()->insert($chunk);
        }

        $this->insertItemsAndMovements($drafts);

        foreach ($extraMovements as $movement) {
            StockMovement::query()->insert([$movement]);
        }

        foreach ($remaining as $productId => $qty) {
            Product::query()->whereKey($productId)->update(['quantity' => max(0, $qty)]);
        }
    }

    /**
     * Mouvements de stock hors ventes (réapprovisionnements et ajustements d'inventaire).
     *
     * @param  EloquentCollection<int, Product>  $products
     * @param  array<int, int>  $remaining
     * @param  EloquentCollection<int, User>  $users
     * @return list<array<string, mixed>>
     */
    private function buildExtraMovements(EloquentCollection $products, array &$remaining, EloquentCollection $users, $start, $now): array
    {
        $rows = [];

        for ($i = 0; $i < 25; $i++) {
            $product = $products->random();
            $isEntry = rand(1, 100) <= 70;

            if ($isEntry) {
                $delta = rand(10, 60);
                $type = MovementType::Entree;
                $reason = 'Réapprovisionnement fournisseur';
            } else {
                $delta = rand(-5, 5);

                if ($delta === 0 || $remaining[$product->id] + $delta < 0) {
                    continue;
                }

                $type = MovementType::Ajustement;
                $reason = "Correction d'inventaire";
            }

            $remaining[$product->id] += $delta;

            $rows[] = [
                'product_id' => $product->id,
                'type' => $type->value,
                'quantity' => $delta,
                'reason' => $reason,
                'reference' => null,
                'user_id' => $users->random()->id,
                'created_at' => \Carbon\Carbon::instance(fake()->dateTimeBetween($start, $now))->format('Y-m-d H:i:s'),
            ];
        }

        return $rows;
    }

    /**
     * Construit un brouillon de vente en puisant dans le stock restant.
     *
     * @param  array<int, int>  $remaining
     * @param  array<int, string>  $prices
     * @param  EloquentCollection<int, User>  $users
     * @param  EloquentCollection<int, Customer>  $customers
     * @return array<string, mixed>|null
     */
    private function buildSaleDraft(array &$remaining, array $prices, EloquentCollection $users, EloquentCollection $customers, $start, $now): ?array
    {
        $available = array_keys(array_filter($remaining, fn (int $qty): bool => $qty > 0));

        if (count($available) === 0) {
            return null;
        }

        shuffle($available);
        $lineCount = min(rand(1, 5), count($available));

        $lines = [];
        $subtotal = 0.0;

        for ($i = 0; $i < $lineCount; $i++) {
            $productId = $available[$i];
            $quantity = rand(1, min(3, $remaining[$productId]));
            $unitPrice = (float) $prices[$productId];

            $lines[] = [
                'product_id' => $productId,
                'quantity' => $quantity,
                'unit_price' => $unitPrice,
            ];

            $remaining[$productId] -= $quantity;
            $subtotal += $quantity * $unitPrice;
        }

        $subtotal = round($subtotal, 2);
        $discount = rand(1, 100) <= 10 ? round($subtotal * 0.05, 2) : 0;

        // 40 % des ventes sur le dernier mois pour un tableau de bord vivant.
        $soldAt = rand(1, 100) <= 40
            ? \Carbon\Carbon::instance(fake()->dateTimeBetween($now->copy()->subDays(30), $now))
            : \Carbon\Carbon::instance(fake()->dateTimeBetween($start, $now->copy()->subDays(30)));

        $method = fake()->randomElement(PaymentMethod::cases());

        return [
            'lines' => $lines,
            'subtotal' => $subtotal,
            'discount' => $discount,
            'customer_id' => rand(1, 100) <= 70 ? $customers->random()->id : null,
            'user_id' => $users->random()->id,
            'payment_method' => $method->value,
            'payment_status' => $method === PaymentMethod::Virement && rand(1, 100) <= 40
                ? PaymentStatus::EnAttente->value
                : PaymentStatus::Payee->value,
            'sold_at' => $soldAt,
        ];
    }

    /**
     * Insère les lignes de vente et les mouvements de sortie des ventes validées.
     *
     * @param  list<array<string, mixed>>  $drafts
     */
    private function insertItemsAndMovements(array $drafts): void
    {
        $saleIdByReference = Sale::query()
            ->orderBy('id')
            ->pluck('id', 'reference');

        $itemRows = [];
        $movementRows = [];

        foreach ($drafts as $draft) {
            $saleId = $saleIdByReference[$draft['reference']] ?? null;

            if ($saleId === null) {
                continue;
            }

            foreach ($draft['lines'] as $line) {
                $itemRows[] = [
                    'sale_id' => $saleId,
                    'product_id' => $line['product_id'],
                    'quantity' => $line['quantity'],
                    'unit_price' => $line['unit_price'],
                    'line_total' => round($line['quantity'] * $line['unit_price'], 2),
                    'created_at' => $draft['sold_at']->format('Y-m-d H:i:s'),
                    'updated_at' => $draft['sold_at']->format('Y-m-d H:i:s'),
                ];

                if (! $draft['is_cancelled']) {
                    $movementRows[] = [
                        'product_id' => $line['product_id'],
                        'type' => MovementType::Sortie->value,
                        'quantity' => -$line['quantity'],
                        'reason' => 'Vente '.$draft['reference'],
                        'reference' => $draft['reference'],
                        'user_id' => $draft['user_id'],
                        'created_at' => $draft['sold_at']->format('Y-m-d H:i:s'),
                    ];
                }
            }
        }

        foreach (array_chunk($itemRows, 500) as $chunk) {
            DB::table('sale_items')->insert($chunk);
        }

        foreach (array_chunk($movementRows, 500) as $chunk) {
            DB::table('stock_movements')->insert($chunk);
        }
    }
}
