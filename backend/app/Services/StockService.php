<?php

declare(strict_types=1);

namespace App\Services;

use App\Enums\MovementType;
use App\Exceptions\BusinessException;
use App\Models\Product;
use App\Models\StockMovement;
use App\Models\User;

/**
 * Toute variation de stock passe par ce service : le stock est verrouillé
 * (lockForUpdate) et chaque variation est tracée dans stock_movements.
 * Invariant garanti : products.quantity == SUM(stock_movements.quantity).
 */
class StockService
{
    /**
     * Applique un delta signé au stock d'un produit et enregistre le mouvement.
     * Le verrouillage des lignes rend l'opération sûre en cas d'accès concurrent.
     */
    public function apply(
        Product $product,
        MovementType $type,
        int $delta,
        ?string $reason = null,
        ?string $reference = null,
        ?User $user = null,
    ): StockMovement {
        /** @var Product $locked */
        $locked = Product::query()->whereKey($product->id)->lockForUpdate()->firstOrFail();

        $newQuantity = $locked->quantity + $delta;

        if ($newQuantity < 0) {
            throw new BusinessException(sprintf(
                'Le stock de « %s » ne peut pas passer sous zéro (stock actuel : %d, demande : %d).',
                $locked->name,
                $locked->quantity,
                abs($delta),
            ), 422, [
                'quantity' => ['Le stock résultant serait négatif.'],
            ]);
        }

        $locked->quantity = $newQuantity;
        $locked->save();

        return $locked->stockMovements()->create([
            'type' => $type->value,
            'quantity' => $delta,
            'reason' => $reason,
            'reference' => $reference,
            'user_id' => $user?->id,
        ]);
    }

    /**
     * Ajustement manuel de stock depuis l'interface (entrée ou correction).
     */
    public function adjust(Product $product, int $delta, ?string $reason, User $user): Product
    {
        if ($delta === 0) {
            throw new BusinessException('L\'ajustement doit modifier le stock (différent de zéro).');
        }

        $type = $delta > 0 ? MovementType::Entree : MovementType::Ajustement;
        $reason = $reason ?: ($delta > 0 ? 'Entrée de stock manuelle' : 'Ajustement de stock manuel');

        $this->apply($product, $type, $delta, $reason, null, $user);

        return $product->refresh();
    }

    /**
     * Justifie par un mouvement le stock initial d'un produit à sa création.
     */
    public function initialize(Product $product, ?User $user = null): void
    {
        if ($product->quantity > 0) {
            $product->recordMovement(MovementType::Entree, $product->quantity, 'Stock initial', null, $user?->id);
        }
    }

    /**
     * Réintègre le stock d'une vente annulée (un mouvement par ligne).
     *
     * @return list<StockMovement>
     */
    public function restoreSaleStock(\App\Models\Sale $sale, ?User $user = null): array
    {
        $movements = [];

        foreach ($sale->items as $item) {
            $movements[] = $this->apply(
                $item->product,
                MovementType::Annulation,
                $item->quantity,
                'Annulation de la vente '.$sale->reference,
                $sale->reference,
                $user,
            );
        }

        return $movements;
    }
}
