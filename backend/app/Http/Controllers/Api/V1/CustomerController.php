<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\ApiController;
use App\Http\Requests\StoreCustomerRequest;
use App\Http\Requests\UpdateCustomerRequest;
use App\Http\Resources\CustomerResource;
use App\Http\Resources\SaleResource;
use App\Models\Customer;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class CustomerController extends ApiController
{
    public function index(Request $request): JsonResponse
    {
        $customers = Customer::query()
            ->search($request->string('q')->toString())
            ->orderBy('name')
            ->paginate($this->perPage($request));

        return $this->success(
            CustomerResource::collection($customers)->resolve(),
            200,
            $this->pageMeta($customers)
        );
    }

    public function store(StoreCustomerRequest $request): JsonResponse
    {
        $customer = Customer::create($request->validated());

        return $this->success(new CustomerResource($customer), 201);
    }

    public function show(Request $request, Customer $customer): JsonResponse
    {
        $sales = $customer->sales()
            ->with('user:id,name,role')
            ->orderByDesc('sold_at')
            ->orderByDesc('id')
            ->paginate($this->perPage($request, 10));

        return $this->success([
            'customer' => new CustomerResource($customer),
            'sales' => SaleResource::collection($sales)->resolve(),
            'sales_meta' => $this->pageMeta($sales),
        ]);
    }

    public function update(UpdateCustomerRequest $request, Customer $customer): JsonResponse
    {
        $customer->update($request->validated());

        return $this->success(new CustomerResource($customer->refresh()));
    }

    /**
     * Soft delete : l'historique d'achats du client est préservé.
     */
    public function destroy(Request $request, Customer $customer): JsonResponse
    {
        $customer->delete();

        return $this->success(['message' => 'Client supprimé.']);
    }
}
