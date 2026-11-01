<?php

declare(strict_types=1);

namespace App\Services;

use App\Enums\PaymentStatus;
use App\Enums\SaleStatus;
use App\Exceptions\BusinessException;
use App\Models\Product;
use App\Models\Sale;
use App\Models\Setting;
use App\Models\User;
use Illuminate\Database\QueryException;
use Illuminate\Support\Facades\DB;

/**
 * Création et annulation des ventes.
 *
 * Règles critiques implémentées ici :
 *  - tout est exécuté dans UNE transaction avec verrouillage des lignes produits ;
 *  - le stock est vérifié AVANT tout écriture, sinon 422 explicite ;
 *  - les montants sont calculés exclusivement côté serveur (décimaux, jamais de float).
 */
class SaleService
{
    public function __construct(
        private readonly StockService $stock,
        private readonly ReferenceService $references,
    ) {}

    /**
     * @param  array{
     *     customer_id?: int|null,
     *     items: list<array{product_id: int, quantity: int}>,
     *     discount?: float|int|string|null,
     *     tax_rate?: float|int|string|null,
     *     payment_method: string,
     *     payment_status?: string|null,
     * }  $data
     */
    public function create(array $data, User $user): Sale
    {
        // Un seul appel de taxe possible : valeur fournie ou réglage par défaut.
        $taxRate = $data['tax_rate'] ?? Setting::getValue('default_tax_rate', '18');

        for ($attempt = 1; $attempt <= 5; $attempt++) {
            try {
                return $this->executeCreation($data, $user, (float) $taxRate);
            } catch (QueryException $e) {
                // Collision improbable de référence (ventes simultanées) : on réessaie.
                if ($attempt === 5 || ! $this->isReferenceCollision($e)) {
                    throw $e;
                }
            }
        }

        throw new BusinessException('Impossible de générer une référence de vente unique.');
    }

    /**
     * @param  array{
     *     customer_id?: int|null,
     *     items: list<array{product_id: int, quantity: int}>,
     *     discount?: float|int|string|null,
     *     payment_method: string,
     *     payment_status?: string|null,
     * }  $data
     */
    private function executeCreation(array $data, User $user, float $taxRate): Sale
    {
        return DB::transaction(function () use ($data, $user, $taxRate): Sale {
            $items = $data['items'];

            // Regroupement des quantités demandées par produit (lignes fusionnables).
            $requested = [];
            foreach ($items as $line) {
                $requested[$line['product_id']] = ($requested[$line['product_id']] ?? 0) + (int) $line['quantity'];
            }

            /** @var \Illuminate\Support\Collection<int, Product> $products */
            $products = Product::query()
                ->whereIn('id', array_keys($requested))
                ->lockForUpdate()
                ->get()
                ->keyBy('id');

            // 1) Vérification du stock de CHAQUE ligne AVANT toute écriture.
            foreach ($requested as $productId => $quantity) {
                $product = $products->get($productId);

                if ($product === null) {
                    throw new BusinessException("Le produit #{$productId} n'existe pas ou a été supprimé.", 422, [
                        'items' => ["Le produit #{$productId} n'existe pas."],
                    ]);
                }

                if (! $product->is_active) {
                    throw new BusinessException(sprintf(
                        'Le produit « %s » est inactif et ne peut pas être vendu.',
                        $product->name,
                    ), 422, ['items' => ["Le produit « {$product->name} » est inactif."]]);
                }

                if ($product->quantity < $quantity) {
                    throw new BusinessException(sprintf(
                        'Stock insuffisant pour « %s » : disponible %d, demandé %d.',
                        $product->name,
                        $product->quantity,
                        $quantity,
                    ), 422, [
                        'items' => [sprintf(
                            'Stock insuffisant pour « %s » : disponible %d, demandé %d.',
                            $product->name,
                            $product->quantity,
                            $quantity,
                        )],
                    ]);
                }
            }

            // 2) Calcul des montants EXCLUSIVEMENT côté serveur.
            $subtotal = '0.00';
            foreach ($requested as $productId => $quantity) {
                $product = $products->get($productId);
                $subtotal = bcadd($subtotal, bcmul((string) $product->selling_price, (string) $quantity, 2), 2);
            }

            $discount = $this->normalizeAmount($data['discount'] ?? 0);

            if (bccomp($discount, $subtotal, 2) === 1) {
                throw new BusinessException('La remise ne peut pas dépasser le sous-total de la vente.', 422, [
                    'discount' => ['La remise dépasse le sous-total ('.$subtotal.' FCFA).'],
                ]);
            }

            $taxRate = max(0, min(100, $taxRate));
            $tax = bcdiv(bcmul(bcsub($subtotal, $discount, 2), (string) $taxRate, 6), '100', 2);
            $total = bcadd(bcsub($subtotal, $discount, 2), $tax, 2);

            $sale = Sale::create([
                'reference' => $this->references->nextSaleReference(),
                'customer_id' => $data['customer_id'] ?? null,
                'user_id' => $user->id,
                'subtotal' => $subtotal,
                'discount' => $discount,
                'tax' => $tax,
                'total' => $total,
                'payment_method' => $data['payment_method'],
                'payment_status' => $data['payment_status'] ?? PaymentStatus::Payee->value,
                'status' => SaleStatus::Validee->value,
                'sold_at' => now(),
            ]);

            // 3) Écriture des lignes (prix figé au moment de la vente),
            //    décrément du stock et mouvements de sortie.
            foreach ($requested as $productId => $quantity) {
                $product = $products->get($productId);

                $sale->items()->create([
                    'product_id' => $product->id,
                    'quantity' => $quantity,
                    'unit_price' => $product->selling_price,
                    'line_total' => bcmul((string) $product->selling_price, (string) $quantity, 2),
                ]);

                $this->stock->apply(
                    $product,
                    \App\Enums\MovementType::Sortie,
                    -$quantity,
                    'Vente '.$sale->reference,
                    $sale->reference,
                    $user,
                );
            }

            return $sale->load(['items.product', 'customer', 'user']);
        }, attempts: 3);
    }

    /**
     * Annulation d'une vente : réintégration du stock, mouvements d'annulation,
     * statut « annulée ». La vente n'est jamais supprimée physiquement.
     */
    public function cancel(Sale $sale, ?string $reason, User $user): Sale
    {
        return DB::transaction(function () use ($sale, $reason, $user): Sale {
            /** @var Sale $locked */
            $locked = Sale::query()->whereKey($sale->id)->lockForUpdate()->firstOrFail();

            if ($locked->status === SaleStatus::Annulee) {
                throw new BusinessException("La vente {$locked->reference} est déjà annulée.");
            }

            $locked->load('items.product');

            // Réintégration du stock ligne par ligne (verrouillage inclus).
            $this->stock->restoreSaleStock($locked, $user);

            $locked->update([
                'status' => SaleStatus::Annulee,
                'cancelled_at' => now(),
                'cancel_reason' => $reason,
            ]);

            return $locked->load(['items.product', 'customer', 'user']);
        }, attempts: 3);
    }

    private function normalizeAmount(float|int|string|null $value): string
    {
        if ($value === null || $value === '') {
            return '0.00';
        }

        return number_format((float) $value, 2, '.', '');
    }

    private function isReferenceCollision(QueryException $e): bool
    {
        $message = $e->getMessage();

        return str_contains($message, 'reference') || str_contains($message, 'Duplicate');
    }
}
