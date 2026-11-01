<?php

declare(strict_types=1);

use App\Models\Sale;
use App\Services\SaleService;
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class);

describe('Tableau de bord', function () {

    test('le résumé reflète exactement les ventes validées du jour', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext(['selling_price' => 10000]);

        $saleService = app(SaleService::class);
        $saleService->create([
            'items' => [['product_id' => $product->id, 'quantity' => 2]],
            'tax_rate' => 0,
            'payment_method' => 'especes',
        ], $user);

        $response = $this->actingAs($user, 'sanctum')->getJson('/api/v1/dashboard/summary');

        expectApiSuccess($response)
            ->assertJsonStructure([
                'data' => [
                    'revenue' => ['today', 'week', 'month', 'today_trend', 'week_trend', 'month_trend'],
                    'sales_count' => ['today', 'week', 'month'],
                    'average_basket', 'stock_value', 'low_stock_count', 'out_of_stock_count',
                    'products_count', 'customers_count',
                ],
            ])
            ->assertJsonPath('data.revenue.today', 20000.0)
            ->assertJsonPath('data.sales_count.today', 1);
    });

    test('le CA exclut les ventes annulées', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext(['selling_price' => 5000]);

        $saleService = app(SaleService::class);
        $sale = $saleService->create([
            'items' => [['product_id' => $product->id, 'quantity' => 1]],
            'tax_rate' => 0,
            'payment_method' => 'especes',
        ], $user);

        $before = $this->actingAs($user, 'sanctum')->getJson('/api/v1/dashboard/summary')->json('data');

        $saleService->cancel($sale, 'test', $user);

        $after = $this->actingAs($user, 'sanctum')->getJson('/api/v1/dashboard/summary')->json('data');

        expect($after['revenue']['today'])->toBe(0.0)
            ->and($after['sales_count']['today'])->toBe(0)
            ->and($before['revenue']['today'])->toBe(5000.0);

        // La valeur du stock est restaurée après annulation.
        expect($after['stock_value'])->toBeGreaterThan(0);
    });

    test('le graphique des ventes renvoie 30 points quotidiens complets', function () {
        ['user' => $user] = makeSaleContext();

        $response = $this->actingAs($user, 'sanctum')->getJson('/api/v1/dashboard/sales-chart?period=30d');

        expectApiSuccess($response)
            ->assertJsonPath('data.period', '30d')
            ->assertJsonCount(30, 'data.points')
            ->assertJsonStructure(['data' => ['points' => [['period', 'label', 'total', 'count']]]]);
    });

    test('le graphique sur 12 mois renvoie 12 points mensuels', function () {
        ['user' => $user] = makeSaleContext();

        $this->actingAs($user, 'sanctum')->getJson('/api/v1/dashboard/sales-chart?period=12m')
            ->assertJsonCount(12, 'data.points');
    });

    test('les meilleures ventes sont classées par chiffre d\'affaires décroissant', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext(['selling_price' => 10000]);
        $category = \App\Models\Category::factory()->create();
        $best = \App\Models\Product::factory()->create([
            'category_id' => $category->id, 'selling_price' => 90000, 'quantity' => 50,
        ]);

        $saleService = app(SaleService::class);
        $saleService->create([
            'items' => [['product_id' => $product->id, 'quantity' => 1]],
            'tax_rate' => 0, 'payment_method' => 'especes',
        ], $user);
        $saleService->create([
            'items' => [['product_id' => $best->id, 'quantity' => 3]],
            'tax_rate' => 0, 'payment_method' => 'especes',
        ], $user);

        $response = $this->actingAs($user, 'sanctum')->getJson('/api/v1/dashboard/top-products');

        expectApiSuccess($response);
        $products = $response->json('data.products');
        expect($products[0]['name'])->toBe($best->name)
            ->and($products[0]['revenue'])->toBe(270000.0)
            ->and($products[0]['quantity'])->toBe(3);
    });

    test('la répartition par catégorie totalise environ 100 %', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext(['selling_price' => 10000]);

        app(SaleService::class)->create([
            'items' => [['product_id' => $product->id, 'quantity' => 1]],
            'tax_rate' => 0, 'payment_method' => 'especes',
        ], $user);

        $response = $this->actingAs($user, 'sanctum')->getJson('/api/v1/dashboard/sales-by-category');

        expectApiSuccess($response);
        $categories = $response->json('data.categories');
        expect(count($categories))->toBe(1)
            ->and($categories[0]['revenue'])->toBe(10000.0)
            ->and($categories[0]['percentage'])->toBe(100.0);
    });

    test('les ventes récentes sont triées de la plus récente à la plus ancienne', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext();
        $saleService = app(SaleService::class);

        $first = $saleService->create([
            'items' => [['product_id' => $product->id, 'quantity' => 1]],
            'payment_method' => 'especes',
        ], $user);

        Sale::whereKey($first->id)->update(['sold_at' => now()->subDay()]);

        $second = $saleService->create([
            'items' => [['product_id' => $product->id, 'quantity' => 1]],
            'payment_method' => 'especes',
        ], $user);

        $response = $this->actingAs($user, 'sanctum')->getJson('/api/v1/dashboard/recent-sales');

        expectApiSuccess($response)
            ->assertJsonPath('data.0.reference', $second->reference)
            ->assertJsonPath('data.1.reference', $first->reference);
    });

    test('le tableau de bord nécessite une authentification', function () {
        $this->getJson('/api/v1/dashboard/summary')->assertStatus(401);
    });
});
