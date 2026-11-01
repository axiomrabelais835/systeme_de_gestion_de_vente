<?php

declare(strict_types=1);

use App\Enums\MovementType;
use App\Models\Product;
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class);

describe('Mouvements de stock', function () {

    test('un vendeur peut consulter le journal filtré par type', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext();

        $product->recordMovement(MovementType::Sortie, -2, 'Casse constatée');
        $product->recordMovement(MovementType::Ajustement, 1, 'Inventaire tournant');

        $response = $this->actingAs($user, 'sanctum')->getJson('/api/v1/stock-movements?type=sortie');

        expectApiSuccess($response)
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.type', 'sortie')
            ->assertJsonPath('data.0.type_label', 'Sortie')
            ->assertJsonPath('data.0.quantity', -2)
            ->assertJsonPath('data.0.reason', 'Casse constatée')
            ->assertJsonPath('data.0.product.name', $product->name);
    });

    test('les filtres produit et période restreignent le journal', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext();
        $other = Product::factory()->create([
            'category_id' => $product->category_id,
            'quantity' => 0,
        ]);
        $other->recordMovement(MovementType::Sortie, -1, 'Autre produit');

        $today = now()->toDateString();

        $response = $this->actingAs($user, 'sanctum')->getJson(
            "/api/v1/stock-movements?product_id={$product->id}&date_from={$today}&date_to={$today}"
        );

        expectApiSuccess($response)
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.product_id', $product->id);
    });

    test('l\'export CSV respecte les filtres et l\'en-tête français', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext();
        $other = Product::factory()->create([
            'category_id' => $product->category_id,
            'quantity' => 0,
        ]);
        $other->recordMovement(MovementType::Sortie, -1, 'Ne doit pas apparaître');

        $response = $this->actingAs($user, 'sanctum')
            ->get("/api/v1/stock-movements/export?product_id={$product->id}");

        $response->assertOk();
        expect($response->headers->get('Content-Type'))->toContain('text/csv');

        $csv = $response->streamedContent();

        expect($csv)->toContain('Date;Produit;SKU;Type;Quantité;Motif;Référence;Opérateur')
            ->toContain($product->name)
            ->not->toContain('Ne doit pas apparaître');
    });

    test('l\'accès au journal exige une authentification', function () {
        $this->getJson('/api/v1/stock-movements')->assertStatus(401);
    });
});
