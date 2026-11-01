<?php

declare(strict_types=1);

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class StockMovementResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'product_id' => $this->product_id,
            'product' => new ProductResource($this->whenLoaded('product')),
            'type' => $this->type->value,
            'type_label' => $this->type->label(),
            'quantity' => $this->quantity,
            'reason' => $this->reason,
            'reference' => $this->reference,
            'user' => new UserResource($this->whenLoaded('user')),
            'created_at' => $this->created_at?->toIso8601String(),
        ];
    }
}
