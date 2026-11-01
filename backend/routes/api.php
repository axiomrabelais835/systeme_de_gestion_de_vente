<?php

use App\Http\Controllers\Api\V1\AuthController;
use App\Http\Controllers\Api\V1\CategoryController;
use App\Http\Controllers\Api\V1\CustomerController;
use App\Http\Controllers\Api\V1\DashboardController;
use App\Http\Controllers\Api\V1\ProductController;
use App\Http\Controllers\Api\V1\SaleController;
use App\Http\Controllers\Api\V1\SettingController;
use App\Http\Controllers\Api\V1\StockMovementController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API — SalesStock (préfixe /api/v1)
|--------------------------------------------------------------------------
| Réponses homogènes : { success, data, meta } / { success, message, errors }.
*/

Route::prefix('v1')->middleware(['api', 'throttle:api'])->group(function () {

    // Authentification (rate limit spécifique sur la connexion).
    Route::post('auth/login', [AuthController::class, 'login'])->middleware('throttle:login');

    Route::middleware('auth:sanctum')->group(function () {

        Route::post('auth/logout', [AuthController::class, 'logout']);
        Route::get('auth/me', [AuthController::class, 'me']);

        // Catégories
        Route::get('categories', [CategoryController::class, 'index']);
        Route::post('categories', [CategoryController::class, 'store']);
        Route::get('categories/{category}', [CategoryController::class, 'show'])->whereNumber('category');
        Route::put('categories/{category}', [CategoryController::class, 'update'])->whereNumber('category');
        Route::patch('categories/{category}', [CategoryController::class, 'update'])->whereNumber('category');
        Route::delete('categories/{category}', [CategoryController::class, 'destroy'])->whereNumber('category');

        // Produits (routes littérales avant la binding {product})
        Route::get('products/low-stock', [ProductController::class, 'lowStock']);
        Route::get('products', [ProductController::class, 'index']);
        Route::post('products', [ProductController::class, 'store']);
        Route::get('products/{product}', [ProductController::class, 'show'])->whereNumber('product');
        Route::put('products/{product}', [ProductController::class, 'update'])->whereNumber('product');
        Route::patch('products/{product}', [ProductController::class, 'update'])->whereNumber('product');
        Route::delete('products/{product}', [ProductController::class, 'destroy'])->whereNumber('product');
        Route::post('products/{product}/adjust-stock', [ProductController::class, 'adjustStock'])->whereNumber('product');

        // Clients
        Route::get('customers', [CustomerController::class, 'index']);
        Route::post('customers', [CustomerController::class, 'store']);
        Route::get('customers/{customer}', [CustomerController::class, 'show'])->whereNumber('customer')->name('customers.show');
        Route::put('customers/{customer}', [CustomerController::class, 'update'])->whereNumber('customer');
        Route::patch('customers/{customer}', [CustomerController::class, 'update'])->whereNumber('customer');
        Route::delete('customers/{customer}', [CustomerController::class, 'destroy'])->whereNumber('customer');

        // Ventes (export avant {sale})
        Route::get('sales/export', [SaleController::class, 'export']);
        Route::get('sales', [SaleController::class, 'index']);
        Route::post('sales', [SaleController::class, 'store']);
        Route::get('sales/{sale}', [SaleController::class, 'show'])->whereNumber('sale');
        Route::post('sales/{sale}/cancel', [SaleController::class, 'cancel'])->whereNumber('sale');

        // Mouvements de stock (export avant l'index)
        Route::get('stock-movements/export', [StockMovementController::class, 'export']);
        Route::get('stock-movements', [StockMovementController::class, 'index']);

        // Tableau de bord
        Route::get('dashboard/summary', [DashboardController::class, 'summary']);
        Route::get('dashboard/sales-chart', [DashboardController::class, 'salesChart']);
        Route::get('dashboard/top-products', [DashboardController::class, 'topProducts']);
        Route::get('dashboard/sales-by-category', [DashboardController::class, 'salesByCategory']);
        Route::get('dashboard/recent-sales', [DashboardController::class, 'recentSales']);

        // Paramètres (modification réservée à l'admin via policy)
        Route::get('settings', [SettingController::class, 'index']);
        Route::put('settings', [SettingController::class, 'update']);
        Route::patch('settings', [SettingController::class, 'update']);
    });
});
