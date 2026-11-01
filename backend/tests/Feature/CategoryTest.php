<?php

declare(strict_types=1);

use App\Models\Category;
use App\Models\Product;
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class);

describe('Catégories', function () {

    test('un admin peut créer une catégorie', function () {
        $response = $this->actingAs(createAdmin(), 'sanctum')->postJson('/api/v1/categories', [
            'name' => 'Épicerie fine',
            'description' => 'Produits d\'exception.',
        ]);

        expectApiSuccess($response, 201)
            ->assertJsonPath('data.name', 'Épicerie fine')
            ->assertJsonPath('data.slug', 'epicerie-fine');

        expect(Category::count())->toBe(1);
    });

    test('un vendeur ne peut pas créer une catégorie (403)', function () {
        $this->actingAs(createVendeur(), 'sanctum')->postJson('/api/v1/categories', [
            'name' => 'Interdit',
        ])->assertStatus(403);

        expect(Category::count())->toBe(0);
    });

    test('le nom doit être unique', function () {
        Category::factory()->create(['name' => 'Électronique']);

        $this->actingAs(createAdmin(), 'sanctum')->postJson('/api/v1/categories', [
            'name' => 'Électronique',
        ])->assertStatus(422)
            ->assertJsonPath('errors.name.0', 'Une catégorie portant ce nom existe déjà.');
    });

    test('la liste affiche le nombre de produits par catégorie', function () {
        $category = Category::factory()->create(['name' => 'Vide']);
        Product::factory()->count(3)->create(['category_id' => $category->id]);

        $response = $this->actingAs(createVendeur(), 'sanctum')->getJson('/api/v1/categories');

        expectApiSuccess($response)
            ->assertJsonPath('data.0.products_count', 3);
    });

    test('la suppression est interdite si des produits sont rattachés', function () {
        $category = Category::factory()->create();
        Product::factory()->count(2)->create(['category_id' => $category->id]);

        $response = $this->actingAs(createAdmin(), 'sanctum')->deleteJson("/api/v1/categories/{$category->id}");

        $response->assertStatus(422)->assertJsonPath('success', false);
        expect($response->json('message'))->toContain('2 produit(s)');
        expect(Category::find($category->id))->not->toBeNull();
    });

    test('la suppression est autorisée si la catégorie est vide', function () {
        $category = Category::factory()->create();

        $this->actingAs(createAdmin(), 'sanctum')->deleteJson("/api/v1/categories/{$category->id}")
            ->assertStatus(200);

        expect(Category::find($category->id))->toBeNull()
            ->and(Category::withTrashed()->find($category->id))->not->toBeNull();
    });

    test('un vendeur peut modifier une catégorie', function () {
        $category = Category::factory()->create(['name' => 'Ancien nom']);

        $this->actingAs(createVendeur(), 'sanctum')->putJson("/api/v1/categories/{$category->id}", [
            'name' => 'Nouveau nom',
        ])->assertStatus(200)
            ->assertJsonPath('data.name', 'Nouveau nom');

        expect($category->fresh()->slug)->toBe('nouveau-nom');
    });
});
