<?php

declare(strict_types=1);

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProductResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'name' => $this->name,
            'sku' => $this->sku,
            'category_id' => $this->category_id,
            'category' => new CategoryResource($this->whenLoaded('category')),
            'description' => $this->description,
            'purchase_price' => $this->purchase_price,
            'selling_price' => $this->selling_price,
            'quantity' => $this->quantity,
            'low_stock_threshold' => $this->low_stock_threshold,
            'image' => $this->image,
            'is_active' => $this->is_active,
            'stock_status' => $this->stockStatus(),
            'stock_status_label' => $this->stockStatusLabel(),
            'created_at' => $this->created_at?->toIso8601String(),
            'updated_at' => $this->updated_at?->toIso8601String(),
        ];
    }

    private function stockStatus(): string
    {
        return match (true) {
            $this->quantity <= 0 => 'out',
            $this->quantity <= $this->low_stock_threshold => 'low',
            default => 'ok',
        };
    }

    private function stockStatusLabel(): string
    {
        return match ($this->stockStatus()) {
            'out' => 'Rupture',
            'low' => 'Stock faible',
            default => 'En stock',
        };
    }
}
