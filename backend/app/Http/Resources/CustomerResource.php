<?php

declare(strict_types=1);

namespace App\Http\Resources;

use App\Enums\SaleStatus;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class CustomerResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'email' => $this->email,
            'phone' => $this->phone,
            'address' => $this->address,
            'notes' => $this->notes,
            'total_spent' => $this->when($request->routeIs('customers.show'), fn () => $this->computedTotalSpent()),
            'sales_count' => $this->when($request->routeIs('customers.show'), fn () => $this->sales()->where('status', SaleStatus::Validee->value)->count()),
            'created_at' => $this->created_at?->toIso8601String(),
            'updated_at' => $this->updated_at?->toIso8601String(),
        ];
    }

    private function computedTotalSpent(): float
    {
        return round((float) $this->sales()->where('status', SaleStatus::Validee->value)->sum('total'), 2);
    }
}
