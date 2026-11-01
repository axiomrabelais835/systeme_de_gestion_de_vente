<?php

declare(strict_types=1);

use App\Enums\MovementType;
use App\Models\Category;
use App\Models\Product;
use App\Models\Sale;
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class);

describe('CRUD produits', function () {

    test('un vendeur peut créer un produit avec un stock initial mouvementé', function () {
        $category = Category::factory()->create();
        $user = createVendeur();

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/v1/products', [
            'name' => 'Casque test',
            'sku' => 'TEST-0001',
            'category_id' => $category->id,
            'purchase_price' => 8000,
            'selling_price' => 15000,
            'quantity' => 12,
            'low_stock_threshold' => 4,
            'is_active' => true,
        ]);

        expectApiSuccess($response, 201)
            ->assertJsonPath('data.sku', 'TEST-0001')
            ->assertJsonPath('data.stock_status', 'ok');

        $product = Product::firstWhere('sku', 'TEST-0001');
        expect($product->stockMovements()->count())->toBe(1)
            ->and($product->stockMovements()->first()->type)->toBe(MovementType::Entree)
            ->and($product->stockMovements()->first()->quantity)->toBe(12);
    });

    test('un SKU dupliqué est refusé', function () {
        Product::factory()->create(['sku' => 'DUPLI-1']);
        $category = Category::factory()->create();

        $this->actingAs(createVendeur(), 'sanctum')->postJson('/api/v1/products', [
            'name' => 'Autre produit',
            'sku' => 'DUPLI-1',
            'category_id' => $category->id,
            'purchase_price' => 1000,
            'selling_price' => 2000,
            'quantity' => 1,
            'low_stock_threshold' => 1,
        ])->assertStatus(422)
            ->assertJsonPath('errors.sku.0', 'Un produit avec ce code SKU existe déjà.');
    });

    test('la recherche fonctionne sur le nom et le SKU', function () {
        Product::factory()->create(['name' => 'Clavier mécanique', 'sku' => 'KEY-001']);
        Product::factory()->create(['name' => 'Souris gaming', 'sku' => 'MOU-999']);

        $byName = $this->actingAs(createVendeur(), 'sanctum')->getJson('/api/v1/products?q=mécanique');
        expectApiSuccess($byName)->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.name', 'Clavier mécanique');

        $bySku = $this->actingAs(createVendeur(), 'sanctum')->getJson('/api/v1/products?q=MOU-99');
        expectApiSuccess($bySku)->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.sku', 'MOU-999');
    });

    test('le filtre par statut de stock fonctionne', function () {
        $category = Category::factory()->create();
        Product::factory()->create(['category_id' => $category->id, 'quantity' => 50, 'low_stock_threshold' => 5]); // ok
        Product::factory()->create(['category_id' => $category->id, 'quantity' => 3, 'low_stock_threshold' => 5]);  // low
        Product::factory()->create(['category_id' => $category->id, 'quantity' => 0, 'low_stock_threshold' => 5]);  // out

        $out = $this->actingAs(createVendeur(), 'sanctum')->getJson('/api/v1/products?status=out');
        expectApiSuccess($out)->assertJsonCount(1, 'data')->assertJsonPath('data.0.stock_status', 'out');

        $low = $this->actingAs(createVendeur(), 'sanctum')->getJson('/api/v1/products?status=low');
        expectApiSuccess($low)->assertJsonCount(1, 'data')->assertJsonPath('data.0.stock_status', 'low');

        $byCategory = $this->actingAs(createVendeur(), 'sanctum')->getJson('/api/v1/products?category_id='.$category->id);
        expectApiSuccess($byCategory)->assertJsonCount(3, 'data');
    });

    test('l\'édition ne modifie jamais le stock (uniquement adjust-stock)', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext(['quantity' => 15]);

        $this->actingAs($user, 'sanctum')->putJson("/api/v1/products/{$product->id}", [
            'name' => $product->name.' (modifié)',
            'sku' => $product->sku,
            'category_id' => $product->category_id,
            'purchase_price' => $product->purchase_price,
            'selling_price' => 12000,
            'quantity' => 999, // tenté d'écraser le stock : ignoré
            'low_stock_threshold' => 3,
        ])->assertStatus(200);

        expect($product->refresh()->quantity)->toBe(15);
    });

    test('l\'ajustement de stock crée un mouvement tracé', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext(['quantity' => 10]);

        $this->actingAs($user, 'sanctum')->postJson("/api/v1/products/{$product->id}/adjust-stock", [
            'quantity_delta' => 25,
            'reason' => 'Réception fournisseur',
        ])->assertStatus(200)
            ->assertJsonPath('data.quantity', 35);

        $movement = $product->stockMovements()->latest('id')->first();
        expect($movement->type)->toBe(MovementType::Entree)
            ->and($movement->quantity)->toBe(25)
            ->and($movement->reason)->toBe('Réception fournisseur');
    });

    test('un ajustement qui rendrait le stock négatif est refusé', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext(['quantity' => 3]);

        $this->actingAs($user, 'sanctum')->postJson("/api/v1/products/{$product->id}/adjust-stock", [
            'quantity_delta' => -10,
        ])->assertStatus(422);

        expect($product->refresh()->quantity)->toBe(3);
    });

    test('un vendeur ne peut pas supprimer un produit (403)', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext();

        $this->actingAs($user, 'sanctum')->deleteJson("/api/v1/products/{$product->id}")
            ->assertStatus(403);

        expect(Product::find($product->id))->not->toBeNull();
    });

    test('un admin peut supprimer un produit sans ventes (soft delete)', function () {
        ['product' => $product] = makeSaleContext();
        $admin = createAdmin();

        $this->actingAs($admin, 'sanctum')->deleteJson("/api/v1/products/{$product->id}")
            ->assertStatus(200);

        expect(Product::find($product->id))->toBeNull()
            ->and(Product::withTrashed()->find($product->id))->not->toBeNull();
    });

    test('la suppression d\'un produit vendu est interdite (422)', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext(['quantity' => 10]);

        $sale = app(\App\Services\SaleService::class)->create([
            'items' => [['product_id' => $product->id, 'quantity' => 1]],
            'payment_method' => 'especes',
        ], $user);

        $admin = createAdmin();

        $response = $this->actingAs($admin, 'sanctum')->deleteJson("/api/v1/products/{$product->id}");
        $response->assertStatus(422)->assertJsonPath('success', false);
        expect($response->json('message'))->toContain('ventes enregistrées');

        expect(Sale::find($sale->id))->not->toBeNull()
            ->and(Product::find($product->id))->not->toBeNull();
    });

    test('GET low-stock liste uniquement les produits en alerte actifs', function () {
        $category = Category::factory()->create();
        Product::factory()->create(['category_id' => $category->id, 'quantity' => 50, 'low_stock_threshold' => 5]);
        $low = Product::factory()->create(['category_id' => $category->id, 'quantity' => 4, 'low_stock_threshold' => 5]);
        $out = Product::factory()->create(['category_id' => $category->id, 'quantity' => 0, 'low_stock_threshold' => 5]);
        Product::factory()->create(['category_id' => $category->id, 'quantity' => 2, 'low_stock_threshold' => 5, 'is_active' => false]);

        $response = $this->actingAs(createVendeur(), 'sanctum')->getJson('/api/v1/products/low-stock');

        expectApiSuccess($response)->assertJsonCount(2, 'data');

        $ids = array_column($response->json('data'), 'id');
        expect($ids)->toContain($low->id)->toContain($out->id);
    });
});
