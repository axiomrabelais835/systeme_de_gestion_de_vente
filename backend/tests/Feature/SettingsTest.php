<?php

declare(strict_types=1);

use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class);

describe('Paramètres', function () {

    test('un administrateur peut modifier les réglages', function () {
        $admin = createAdmin();

        $response = $this->actingAs($admin, 'sanctum')->putJson('/api/v1/settings', [
            'company_name' => 'Boutique Test',
            'default_tax_rate' => 20,
            'default_low_stock_threshold' => 8,
        ]);

        expectApiSuccess($response)
            ->assertJsonPath('data.company_name', 'Boutique Test')
            ->assertJsonPath('data.default_tax_rate', 20.0)
            ->assertJsonPath('data.default_low_stock_threshold', 8);

        // Les valeurs sont bien persistées (relues depuis la base).
        $this->actingAs($admin, 'sanctum')->getJson('/api/v1/settings')
            ->assertJsonPath('data.company_name', 'Boutique Test');
    });

    test('un vendeur ne peut pas modifier les réglages', function () {
        $response = $this->actingAs(createVendeur(), 'sanctum')->putJson('/api/v1/settings', [
            'default_tax_rate' => 99,
        ]);

        $response->assertStatus(403);
    });

    test('la lecture des réglages est ouverte à tous les utilisateurs authentifiés', function () {
        $response = $this->actingAs(createVendeur(), 'sanctum')->getJson('/api/v1/settings');

        expectApiSuccess($response)
            ->assertJsonStructure(['data' => [
                'company_name', 'currency', 'currency_symbol',
                'default_tax_rate', 'default_low_stock_threshold',
            ]]);
    });

    test('un taux de TVA supérieur à 100 est refusé en français', function () {
        $this->actingAs(createAdmin(), 'sanctum')->putJson('/api/v1/settings', [
            'default_tax_rate' => 150,
        ])->assertStatus(422)
            ->assertJsonPath('errors.default_tax_rate.0', 'Le taux de taxe ne peut pas dépasser 100 %.');
    });
});
