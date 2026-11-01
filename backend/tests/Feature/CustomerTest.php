<?php

declare(strict_types=1);

use App\Models\Customer;
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class);

describe('Clients', function () {

    test('création et affichage d\'un client', function () {
        $user = createVendeur();

        $response = $this->actingAs($user, 'sanctum')->postJson('/api/v1/customers', [
            'name' => 'Marie Konan',
            'email' => 'marie.konan@exemple.ci',
            'phone' => '+225 07 11 22 33 44',
        ]);

        expectApiSuccess($response, 201)->assertJsonPath('data.name', 'Marie Konan');

        $this->actingAs($user, 'sanctum')->getJson('/api/v1/customers?q=Marie')
            ->assertJsonCount(1, 'data');
    });

    test('l\'e-mail doit être unique', function () {
        Customer::factory()->create(['email' => 'duplique@exemple.ci']);

        $this->actingAs(createVendeur(), 'sanctum')->postJson('/api/v1/customers', [
            'name' => 'Autre client',
            'email' => 'duplique@exemple.ci',
        ])->assertStatus(422)
            ->assertJsonPath('errors.email.0', 'Un client avec cette adresse e-mail existe déjà.');
    });

    test('la fiche client inclut l\'historique d\'achats et le total dépensé', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext(['selling_price' => 10000]);
        $customer = Customer::factory()->create(['name' => 'Serge Kouadio']);

        $sale = app(\App\Services\SaleService::class)->create([
            'customer_id' => $customer->id,
            'items' => [['product_id' => $product->id, 'quantity' => 2]],
            'tax_rate' => 0,
            'payment_method' => 'especes',
        ], $user);

        $response = $this->actingAs($user, 'sanctum')->getJson("/api/v1/customers/{$customer->id}");

        expectApiSuccess($response)
            ->assertJsonPath('data.customer.name', 'Serge Kouadio')
            ->assertJsonPath('data.customer.total_spent', 20000.0)
            ->assertJsonPath('data.customer.sales_count', 1)
            ->assertJsonPath('data.sales.0.reference', $sale->reference);
    });

    test('les ventes annulées ne comptent pas dans le total dépensé', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext(['selling_price' => 10000]);
        $customer = Customer::factory()->create();

        $sale = app(\App\Services\SaleService::class)->create([
            'customer_id' => $customer->id,
            'items' => [['product_id' => $product->id, 'quantity' => 1]],
            'tax_rate' => 0,
            'payment_method' => 'especes',
        ], $user);

        app(\App\Services\SaleService::class)->cancel($sale, null, $user);

        $response = $this->actingAs($user, 'sanctum')->getJson("/api/v1/customers/{$customer->id}");

        expectApiSuccess($response)
            ->assertJsonPath('data.customer.total_spent', 0.0)
            ->assertJsonPath('data.customer.sales_count', 0);
    });

    test('la suppression d\'un client est un soft delete qui préserve l\'historique', function () {
        ['product' => $product, 'user' => $user] = makeSaleContext();
        $customer = Customer::factory()->create();

        app(\App\Services\SaleService::class)->create([
            'customer_id' => $customer->id,
            'items' => [['product_id' => $product->id, 'quantity' => 1]],
            'payment_method' => 'especes',
        ], $user);

        $this->actingAs($user, 'sanctum')->deleteJson("/api/v1/customers/{$customer->id}")
            ->assertStatus(200);

        expect(Customer::find($customer->id))->toBeNull()
            ->and(Customer::withTrashed()->find($customer->id))->not->toBeNull()
            ->and($customer->sales()->count())->toBe(1);
    });
});
