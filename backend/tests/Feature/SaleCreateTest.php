<?php

declare(strict_types=1);

use App\Enums\MovementType;
use App\Enums\SaleStatus;
use App\Models\Category;
use App\Models\Product;
use App\Models\Sale;
use App\Models\Setting;
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class);

describe('Création de vente', function () {

    test('une vente valide diminue le stock et crée les mouvements de sortie', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext();

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/v1/sales', [
            'items' => [['product_id' => $product->id, 'quantity' => 3]],
            'payment_method' => 'especes',
        ]);

        expectApiSuccess($response, 201)
            ->assertJsonPath('data.status', 'validee')
            ->assertJsonStructure(['data' => ['id', 'reference', 'subtotal', 'discount', 'tax', 'total', 'items']]);

        $product->refresh();
        expect($product->quantity)->toBe(17);

        $movement = $product->stockMovements()->where('type', MovementType::Sortie)->latest('id')->first();
        expect($movement)->not->toBeNull()
            ->and($movement->quantity)->toBe(-3)
            ->and($movement->reason)->toContain('Vente');
    });

    test('les montants sont calculés côté serveur (remise + taxe 18 %)', function () {
        Setting::setValue('default_tax_rate', '18');
        ['product' => $product, 'user' => $user] = makeSaleContext(['selling_price' => 15000]);

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/v1/sales', [
            'items' => [['product_id' => $product->id, 'quantity' => 2]],
            'discount' => 1000,
            'payment_method' => 'mobile_money',
        ]);

        // Sous-total = 30 000 ; remise 1 000 ; taxe 18 % de 29 000 = 5 220 ; total = 34 220.
        expectApiSuccess($response, 201)
            ->assertJsonPath('data.subtotal', '30000.00')
            ->assertJsonPath('data.discount', '1000.00')
            ->assertJsonPath('data.tax', '5220.00')
            ->assertJsonPath('data.total', '34220.00');
    });

    test('un taux de taxe explicite remplace le réglage par défaut', function () {
        Setting::setValue('default_tax_rate', '18');
        ['product' => $product, 'user' => $user] = makeSaleContext(['selling_price' => 10000]);

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/v1/sales', [
            'items' => [['product_id' => $product->id, 'quantity' => 1]],
            'tax_rate' => 0,
            'payment_method' => 'carte',
        ]);

        expectApiSuccess($response, 201)
            ->assertJsonPath('data.tax', '0.00')
            ->assertJsonPath('data.total', '10000.00');
    });

    test('les prix envoyés par le client sont ignorés (calcul serveur uniquement)', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext(['selling_price' => 20000]);

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/v1/sales', [
            'items' => [[
                'product_id' => $product->id,
                'quantity' => 1,
                'unit_price' => 1, // tentative de falsification
                'line_total' => 1,
            ]],
            'discount' => 0,
            'tax_rate' => 0,
            'payment_method' => 'especes',
        ]);

        expectApiSuccess($response, 201)
            ->assertJsonPath('data.items.0.unit_price', '20000.00')
            ->assertJsonPath('data.total', '20000.00');
    });

    test('la référence suit le format VTE-AAAA-NNNNNN', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext();

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/v1/sales', [
            'items' => [['product_id' => $product->id, 'quantity' => 1]],
            'payment_method' => 'especes',
        ]);

        $reference = $response->json('data.reference');
        expect($reference)->toMatch('/^VTE-\d{4}-\d{6}$/');
    });

    test('un stock insuffisant rejette la vente entière avec 422 explicite', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext(['quantity' => 4]);

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/v1/sales', [
            'items' => [['product_id' => $product->id, 'quantity' => 7]],
            'payment_method' => 'especes',
        ]);

        $response->assertStatus(422)->assertJsonPath('success', false);
        expect($response->json('message'))
            ->toContain('Stock insuffisant')
            ->toContain($product->name)
            ->toContain('disponible 4');

        // Rien n'a été écrit.
        expect(Sale::count())->toBe(0)
            ->and($product->refresh()->quantity)->toBe(4)
            ->and($product->stockMovements()->where('type', MovementType::Sortie)->count())->toBe(0);
    });

    test('une vente multi-lignes est rejetée entièrement si une ligne dépasse le stock', function () {
        $category = Category::factory()->create();
        $ok = Product::factory()->create(['category_id' => $category->id, 'quantity' => 10, 'selling_price' => 5000]);
        $ko = Product::factory()->create(['category_id' => $category->id, 'quantity' => 1, 'selling_price' => 8000]);
        $user = createVendeur();

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/v1/sales', [
            'items' => [
                ['product_id' => $ok->id, 'quantity' => 2],
                ['product_id' => $ko->id, 'quantity' => 5],
            ],
            'payment_method' => 'especes',
        ]);

        $response->assertStatus(422);
        expect(Sale::count())->toBe(0)
            ->and($ok->refresh()->quantity)->toBe(10)
            ->and($ko->refresh()->quantity)->toBe(1);
    });

    test('une remise supérieure au sous-total est refusée', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext(['selling_price' => 5000]);

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/v1/sales', [
            'items' => [['product_id' => $product->id, 'quantity' => 1]],
            'discount' => 99999,
            'payment_method' => 'especes',
        ]);

        $response->assertStatus(422)
            ->assertJsonPath('errors.discount.0', 'La remise dépasse le sous-total (5000.00 FCFA).');
    });

    test('un produit inactif ne peut pas être vendu', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext(['is_active' => false]);

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/v1/sales', [
            'items' => [['product_id' => $product->id, 'quantity' => 1]],
            'payment_method' => 'especes',
        ]);

        $response->assertStatus(422)->assertJsonPath('success', false);
        expect(Sale::count())->toBe(0);
    });

    test('le panier vide est refusé', function () {
        ['user' => $user] = makeSaleContext();

        $this->actingAs($user, 'sanctum')->postJson('/api/v1/sales', [
            'items' => [],
            'payment_method' => 'especes',
        ])->assertStatus(422)
            ->assertJsonPath('errors.items.0', 'La vente doit contenir au moins un article.');
    });

    test('le stock ne peut pas devenir négatif (invariant somme des mouvements)', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext(['quantity' => 6]);

        $this->actingAs($user, 'sanctum')->postJson('/api/v1/sales', [
            'items' => [['product_id' => $product->id, 'quantity' => 6]],
            'payment_method' => 'especes',
        ])->assertStatus(201);

        $product->refresh();
        $sum = (int) $product->stockMovements()->sum('quantity');

        expect($product->quantity)->toBe(0)->and($sum)->toBe(0);
    });

    test('une vente validée apparaît dans l\'historique avec ses filtres', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext();

        $sale = $this->actingAs($user, 'sanctum')->postJson('/api/v1/sales', [
            'items' => [['product_id' => $product->id, 'quantity' => 1]],
            'payment_method' => 'virement',
        ])->json('data');

        $this->actingAs($user, 'sanctum')->getJson('/api/v1/sales?payment_method=virement')
            ->assertStatus(200)
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.reference', $sale['reference']);

        $this->actingAs($user, 'sanctum')->getJson('/api/v1/sales?payment_method=carte')
            ->assertStatus(200)
            ->assertJsonCount(0, 'data');
    });
});
