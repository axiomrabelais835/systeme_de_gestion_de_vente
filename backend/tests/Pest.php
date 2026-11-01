<?php

declare(strict_types=1);

use App\Enums\MovementType;
use App\Models\Category;
use App\Models\Product;
use App\Models\User;
use Illuminate\Testing\TestResponse;

/*
|--------------------------------------------------------------------------
| Bootstrap des tests
|--------------------------------------------------------------------------
| Les tests Feature tournent sur une base MySQL dédiée (salesstock_test),
| créée automatiquement ici si elle n'existe pas encore.
*/

$host = getenv('DB_HOST') ?: '127.0.0.1';
$port = getenv('DB_PORT') ?: '3306';
$database = getenv('DB_DATABASE') ?: 'salesstock_test';
$username = getenv('DB_USERNAME') ?: 'root';
$password = getenv('DB_PASSWORD') ?: '';

try {
    $pdo = new PDO("mysql:host={$host};port={$port}", $username, $password, [
        PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
    ]);
    $pdo->exec("CREATE DATABASE IF NOT EXISTS `{$database}` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci");
} catch (Throwable) {
    // Le serveur MySQL n'est pas accessible : les tests le signaleront plus clairement.
}

pest()->extend(Tests\TestCase::class)
    ->in('Feature');

/*
|--------------------------------------------------------------------------
| Helpers de tests
|--------------------------------------------------------------------------
*/

function createAdmin(array $attributes = []): User
{
    return User::factory()->admin()->create($attributes);
}

function createVendeur(array $attributes = []): User
{
    return User::factory()->vendeur()->create($attributes);
}

/**
 * Vérifie la forme homogène des réponses API : { success, data, meta }.
 */
function expectApiSuccess(TestResponse $response, int $status = 200): TestResponse
{
    $response->assertStatus($status)->assertJsonStructure(['success', 'data']);
    $response->assertJsonPath('success', true);

    return $response;
}

/**
 * Contexte minimal pour les tests de vente : un produit en stock et un vendeur.
 * Le stock initial est justifié par un mouvement d'entrée (invariant de traçabilité).
 *
 * @return array{product: Product, user: User, category: Category}
 */
function makeSaleContext(array $productAttributes = []): array
{
    $category = Category::factory()->create();
    $product = Product::factory()->create(array_merge([
        'category_id' => $category->id,
        'selling_price' => 10000,
        'purchase_price' => 6000,
        'quantity' => 20,
        'low_stock_threshold' => 5,
        'is_active' => true,
    ], $productAttributes));

    $product->recordMovement(MovementType::Entree, $product->quantity, 'Stock initial');

    return ['product' => $product, 'user' => createVendeur(), 'category' => $category];
}
