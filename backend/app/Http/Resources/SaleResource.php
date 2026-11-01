<?php

declare(strict_types=1);

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class SaleResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'reference' => $this->reference,
            'customer_id' => $this->customer_id,
            'customer' => new CustomerResource($this->whenLoaded('customer')),
            'user' => new UserResource($this->whenLoaded('user')),
            'subtotal' => $this->subtotal,
            'discount' => $this->discount,
            'tax' => $this->tax,
            'total' => $this->total,
            'payment_method' => $this->payment_method->value,
            'payment_method_label' => $this->payment_method->label(),
            'payment_status' => $this->payment_status->value,
            'payment_status_label' => $this->payment_status->label(),
            'status' => $this->status->value,
            'status_label' => $this->status->label(),
            'items' => SaleItemResource::collection($this->whenLoaded('items')),
            // Compteur agrégé en liste, sinon décompte des lignes chargées.
            'items_count' => $this->resource->relationLoaded('items')
                ? $this->items->count()
                : ($this->resource->items_count ?? null),
            'sold_at' => $this->sold_at?->toIso8601String(),
            'cancelled_at' => $this->cancelled_at?->toIso8601String(),
            'cancel_reason' => $this->cancel_reason,
        ];
    }
}
