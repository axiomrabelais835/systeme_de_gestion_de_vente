<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Exceptions\BusinessException;
use App\Http\Controllers\ApiController;
use App\Http\Requests\AdjustStockRequest;
use App\Http\Requests\StoreProductRequest;
use App\Http\Requests\UpdateProductRequest;
use App\Http\Resources\ProductResource;
use App\Models\Product;
use App\Services\StockService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class ProductController extends ApiController
{
    public function __construct(private readonly StockService $stockService) {}

    public function index(Request $request): JsonResponse
    {
        $this->authorize('viewAny', Product::class);

        $query = Product::query()
            ->with('category:id,name,slug')
            ->search($request->string('q')->toString())
            ->when($request->filled('category_id'), fn ($q) => $q->where('category_id', $request->integer('category_id')))
            ->when($request->filled('is_active'), fn ($q) => $q->where('is_active', $request->boolean('is_active')))
            ->stockStatus($request->string('status')->toString());

        $sortField = match ($request->string('sort')->toString()) {
            'selling_price', '-selling_price' => 'selling_price',
            'quantity', '-quantity' => 'quantity',
            'created_at', '-created_at' => 'created_at',
            '-name' => 'name',
            default => 'name',
        };
        $direction = str_starts_with($request->string('sort')->toString(), '-') ? 'desc' : 'asc';

        $products = $query->orderBy($sortField, $direction)->orderBy('id')
            ->paginate($this->perPage($request));

        return $this->success(
            ProductResource::collection($products)->resolve(),
            200,
            $this->pageMeta($products)
        );
    }

    public function store(StoreProductRequest $request): JsonResponse
    {
        $this->authorize('create', Product::class);

        $product = Product::create($request->validated());

        // Traçabilité : le stock initial est justifié par un mouvement d'entrée.
        $this->stockService->initialize($product, $request->user());

        return $this->success(new ProductResource($product->load('category:id,name,slug')), 201);
    }

    public function show(Request $request, Product $product): JsonResponse
    {
        $this->authorize('view', $product);

        return $this->success(new ProductResource($product->load('category:id,name,slug')));
    }

    public function update(UpdateProductRequest $request, Product $product): JsonResponse
    {
        $this->authorize('update', $product);

        // Le stock ne se modifie jamais ici : uniquement via adjust-stock.
        $product->update($request->validated());

        return $this->success(new ProductResource($product->fresh('category:id,name,slug')));
    }

    public function destroy(Request $request, Product $product): JsonResponse
    {
        $this->authorize('delete', $product);

        if ($product->hasSales()) {
            throw new BusinessException(sprintf(
                'Impossible de supprimer « %s » : ce produit figure dans des ventes enregistrées. Désactivez-le plutôt (is_active = faux) pour le retirer du catalogue.',
                $product->name,
            ));
        }

        $product->delete();

        return $this->success(['message' => 'Produit supprimé.']);
    }

    /**
     * Ajustement rapide de stock (+ / −) avec traçabilité.
     */
    public function adjustStock(AdjustStockRequest $request, Product $product): JsonResponse
    {
        $this->authorize('update', $product);

        $product = $this->stockService->adjust(
            $product,
            (int) $request->validated('quantity_delta'),
            $request->validated('reason'),
            $request->user(),
        );

        return $this->success(new ProductResource($product->load('category:id,name,slug')));
    }

    /**
     * Produits en alerte (stock <= seuil), actifs uniquement.
     */
    public function lowStock(Request $request): JsonResponse
    {
        $this->authorize('viewAny', Product::class);

        $products = Product::query()
            ->with('category:id,name,slug')
            ->lowStock()
            ->orderByRaw('CASE WHEN quantity = 0 THEN 0 ELSE 1 END')
            ->orderBy('quantity')
            ->paginate($this->perPage($request, 50));

        return $this->success(
            ProductResource::collection($products)->resolve(),
            200,
            $this->pageMeta($products)
        );
    }
}
