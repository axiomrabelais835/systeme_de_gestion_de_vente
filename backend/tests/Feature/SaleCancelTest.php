<?php

declare(strict_types=1);

use App\Enums\MovementType;
use App\Enums\SaleStatus;
use App\Models\Sale;
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class);

/**
 * @return array{sale: Sale, user: \App\Models\User, product: \App\Models\Product}
 */
function makeCancelledSaleContext(): array
{
    $context = makeSaleContext(['quantity' => 20]);
    $user = $context['user'];

    $sale = app(\App\Services\SaleService::class)->create([
        'items' => [['product_id' => $context['product']->id, 'quantity' => 5]],
        'payment_method' => 'especes',
    ], $user);

    return ['sale' => $sale, 'user' => $user, 'product' => $context['product']];
}

describe('Annulation de vente', function () {

    test('l\'annulation réintègre le stock et crée les mouvements d\'annulation', function () {
        ['sale' => $sale, 'user' => $user, 'product' => $product] = makeCancelledSaleContext();

        expect($product->refresh()->quantity)->toBe(15);

        $response = $this->actingAs($user, 'sanctum')->postJson("/api/v1/sales/{$sale->id}/cancel", [
            'reason' => 'Erreur de caisse',
        ]);

        expectApiSuccess($response)
            ->assertJsonPath('data.status', 'annulee')
            ->assertJsonPath('data.cancel_reason', 'Erreur de caisse');

        $product->refresh();
        expect($product->quantity)->toBe(20);

        $cancelMovement = $product->stockMovements()
            ->where('type', MovementType::Annulation)
            ->latest('id')
            ->first();

        expect($cancelMovement)->not->toBeNull()
            ->and($cancelMovement->quantity)->toBe(5)
            ->and($cancelMovement->reason)->toContain('Annulation');

        // Invariant : somme des mouvements == stock.
        expect((int) $product->stockMovements()->sum('quantity'))->toBe(20);
    });

    test('une vente annulée n\'est jamais supprimée physiquement', function () {
        ['sale' => $sale, 'user' => $user] = makeCancelledSaleContext();

        $this->actingAs($user, 'sanctum')->postJson("/api/v1/sales/{$sale->id}/cancel")
            ->assertStatus(200);

        expect(Sale::count())->toBe(1)
            ->and(Sale::find($sale->id))->not->toBeNull()
            ->and($sale->fresh()->status)->toBe(SaleStatus::Annulee)
            ->and($sale->fresh()->cancelled_at)->not->toBeNull();

        // Les lignes de vente sont conservées.
        expect($sale->items()->count())->toBe(1);
    });

    test('double annulation refusée', function () {
        ['sale' => $sale, 'user' => $user] = makeCancelledSaleContext();

        $this->actingAs($user, 'sanctum')->postJson("/api/v1/sales/{$sale->id}/cancel")
            ->assertStatus(200);

        $this->actingAs($user, 'sanctum')->postJson("/api/v1/sales/{$sale->id}/cancel")
            ->assertStatus(422)
            ->assertJsonPath('success', false);
    });

    test('les montants de la vente restent inchangés après annulation', function () {
        ['sale' => $sale, 'user' => $user] = makeCancelledSaleContext();

        $before = $sale->fresh()->only(['subtotal', 'discount', 'tax', 'total']);

        $this->actingAs($user, 'sanctum')->postJson("/api/v1/sales/{$sale->id}/cancel")
            ->assertStatus(200);

        expect($sale->fresh()->only(['subtotal', 'discount', 'tax', 'total']))->toBe($before);
    });

    test('une vente annulée n\'apparaît plus dans les statistiques du tableau de bord', function () {
        ['sale' => $sale, 'user' => $user] = makeCancelledSaleContext();

        $before = $this->actingAs($user, 'sanctum')->getJson('/api/v1/dashboard/summary')->json('data.revenue.month');

        $this->actingAs($user, 'sanctum')->postJson("/api/v1/sales/{$sale->id}/cancel");

        $after = $this->actingAs($user, 'sanctum')->getJson('/api/v1/dashboard/summary')->json('data.revenue.month');

        expect($after)->toBeLessThan($before);
    });
});
