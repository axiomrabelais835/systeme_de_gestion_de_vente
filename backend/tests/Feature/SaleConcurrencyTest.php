<?php

declare(strict_types=1);

use App\Enums\MovementType;
use App\Models\Product;
use App\Models\User;
use Illuminate\Support\Facades\Artisan;
use Symfony\Component\Process\Process;

/*
|--------------------------------------------------------------------------
| Test de concurrence (sans RefreshDatabase)
|--------------------------------------------------------------------------
| Ce test lance DEUX processus PHP réellement simultanés qui tentent de vendre
| chacun 5 unités d'un produit qui n'en possède que 5. La base MySQL réelle
| (salesstock_test) et le verrouillage des lignes (lockForUpdate) sont ainsi
| testés pour de bon : exactement une seule vente doit réussir.
|
| Toute la donnée créée ici est nettoyée après le test.
*/

uses()->group('concurrency');

class ConcurrencyState
{
    public static bool $migrated = false;
}

beforeEach(function () {
    if (! ConcurrencyState::$migrated) {
        Artisan::call('migrate:fresh', ['--force' => true]);
        ConcurrencyState::$migrated = true;
    }
});

afterEach(function () {
    // Nettoyage strict de toutes les données créées par ce test.
    \App\Models\StockMovement::query()->delete();
    \App\Models\SaleItem::query()->delete();
    \App\Models\Sale::query()->delete();
    Product::query()->delete();
    User::query()->delete();
});

test('deux ventes simultanées ne peuvent pas vendre plus que le stock disponible', function () {
    $user = User::factory()->admin()->create(['email' => 'concurrence@test.local']);
    $category = \App\Models\Category::factory()->create(['name' => 'Concurrence '.uniqid()]);

    $product = Product::create([
        'name' => 'Produit de concurrence',
        'sku' => 'CONC-'.uniqid(),
        'category_id' => $category->id,
        'purchase_price' => 1000,
        'selling_price' => 5000,
        'quantity' => 5,
        'low_stock_threshold' => 1,
        'is_active' => true,
    ]);
    $product->recordMovement(MovementType::Entree, 5, 'Stock initial');

    $barrier = storage_path('framework/testing/barrier-'.uniqid().'.txt');
    $readyFiles = [
        storage_path('framework/testing/ready-'.uniqid().'-1.txt'),
        storage_path('framework/testing/ready-'.uniqid().'-2.txt'),
    ];

    $env = [
        'APP_ENV' => 'testing',
        'APP_KEY' => config('app.key'),
        'APP_DEBUG' => 'false',
        'DB_CONNECTION' => config('database.default'),
        'DB_HOST' => config('database.connections.mysql.host'),
        'DB_PORT' => (string) config('database.connections.mysql.port'),
        'DB_DATABASE' => config('database.connections.mysql.database'),
        'DB_USERNAME' => (string) config('database.connections.mysql.username'),
        'DB_PASSWORD' => (string) config('database.connections.mysql.password'),
        'CACHE_STORE' => 'database',
        'SESSION_DRIVER' => 'database',
        'QUEUE_CONNECTION' => 'database',
    ];

    $processes = [];
    foreach ($readyFiles as $index => $readyFile) {
        $processes[$index] = new Process(
            [
                PHP_BINARY, 'artisan', 'sale:simulate',
                '--product='.$product->id,
                '--qty=5',
                '--email='.$user->email,
                '--ready-file='.$readyFile,
                '--wait-for='.$barrier,
            ],
            base_path(),
            $env,
            null,
            180
        );
        $processes[$index]->start();
    }

    // Attendre que les deux processus soient prêts, puis lever la barrière.
    $deadline = microtime(true) + 60;
    while (microtime(true) < $deadline) {
        if (file_exists($readyFiles[0]) && file_exists($readyFiles[1])) {
            break;
        }
        usleep(20000);
    }

    expect(file_exists($readyFiles[0]) && file_exists($readyFiles[1]))
        ->toBeTrue('Les processus de simulation ne se sont pas prêts à temps.');

    touch($barrier);

    foreach ($processes as $process) {
        $process->wait();
    }

    $results = array_map(
        fn (Process $process): array => json_decode(trim($process->getOutput()), true) ?? ['ok' => false, 'message' => $process->getErrorOutput()],
        $processes
    );

    // Nettoyage des fichiers de barrière.
    @unlink($barrier);
    @unlink($readyFiles[0]);
    @unlink($readyFiles[1]);

    $successes = array_filter($results, fn (array $r): bool => ($r['ok'] ?? false) === true);
    $failures = array_filter($results, fn (array $r): bool => ($r['ok'] ?? false) === false);

    // 1) Exactement une vente a réussi.
    expect(count($successes))->toBe(1, 'Résultats : '.json_encode($results));
    expect(count($failures))->toBe(1);

    // 2) La vente rejetée l'a été pour stock insuffisant.
    $failure = array_values($failures)[0];
    expect($failure['message'])->toContain('Stock insuffisant');

    // 3) Le stock final est exactement 0 et l'invariant mouvements est respecté.
    $product->refresh();
    expect($product->quantity)->toBe(0);
    expect((int) $product->stockMovements()->sum('quantity'))->toBe(0);

    // 4) Une seule vente existe en base.
    expect(\App\Models\Sale::count())->toBe(1);
});
