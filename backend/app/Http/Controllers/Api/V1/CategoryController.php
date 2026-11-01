<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Exceptions\BusinessException;
use App\Http\Controllers\ApiController;
use App\Http\Requests\StoreCategoryRequest;
use App\Http\Requests\UpdateCategoryRequest;
use App\Http\Resources\CategoryResource;
use App\Models\Category;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CategoryController extends ApiController
{
    public function index(Request $request): JsonResponse
    {
        $this->authorize('viewAny', Category::class);

        $sort = $request->string('sort', 'name')->toString();
        $allowedSorts = ['name', 'created_at', 'products_count'];

        $query = Category::query()
            ->withCount(['products as products_count' => fn ($q) => $q->whereNull('deleted_at')])
            ->search($request->string('q')->toString());

        if (in_array($sort, $allowedSorts, true)) {
            $direction = str_starts_with($request->string('sort')->toString(), '-') ? 'desc' : 'asc';
            $query->orderBy($sort, $direction);
        } else {
            $query->orderBy('name');
        }

        $categories = $query->paginate($this->perPage($request));

        return $this->success(
            CategoryResource::collection($categories)->resolve(),
            200,
            $this->pageMeta($categories)
        );
    }

    public function store(StoreCategoryRequest $request): JsonResponse
    {
        $this->authorize('create', Category::class);

        $category = Category::create($request->validated());

        return $this->success(new CategoryResource($category), 201);
    }

    public function show(Request $request, Category $category): JsonResponse
    {
        $this->authorize('view', $category);

        $category->loadCount(['products as products_count' => fn ($q) => $q->whereNull('deleted_at')]);

        return $this->success(new CategoryResource($category));
    }

    public function update(UpdateCategoryRequest $request, Category $category): JsonResponse
    {
        $this->authorize('update', $category);

        $category->update($request->validated());

        return $this->success(new CategoryResource($category->refresh()));
    }

    public function destroy(Request $request, Category $category): JsonResponse
    {
        $this->authorize('delete', $category);

        $productsCount = $category->products()->count();

        if ($productsCount > 0) {
            throw new BusinessException(sprintf(
                'Impossible de supprimer la catégorie « %s » : %d produit(s) y sont rattachés. Désactivez ou déplacez ces produits d\'abord.',
                $category->name,
                $productsCount,
            ));
        }

        $category->delete();

        return $this->success(['message' => 'Catégorie supprimée.']);
    }
}
