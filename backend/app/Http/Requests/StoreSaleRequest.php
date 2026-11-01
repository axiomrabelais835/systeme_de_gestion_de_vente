<?php

declare(strict_types=1);

namespace App\Http\Requests;

use App\Enums\PaymentMethod;
use App\Enums\PaymentStatus;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreSaleRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        return [
            'customer_id' => ['nullable', 'integer', 'exists:customers,id'],
            'items' => ['required', 'array', 'min:1'],
            'items.*.product_id' => ['required', 'integer', 'exists:products,id'],
            'items.*.quantity' => ['required', 'integer', 'min:1', 'max:100000'],
            'discount' => ['nullable', 'numeric', 'min:0'],
            'tax_rate' => ['nullable', 'numeric', 'min:0', 'max:100'],
            'payment_method' => ['required', Rule::enum(PaymentMethod::class)],
            'payment_status' => ['sometimes', Rule::enum(PaymentStatus::class)],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'items.required' => 'La vente doit contenir au moins un article.',
            'items.min' => 'La vente doit contenir au moins un article.',
            'items.*.product_id.required' => 'Chaque ligne doit référencer un produit.',
            'items.*.product_id.exists' => 'L\'un des produits sélectionnés n\'existe pas.',
            'items.*.quantity.required' => 'La quantité est obligatoire pour chaque ligne.',
            'items.*.quantity.min' => 'La quantité doit être au moins égale à 1.',
            'discount.numeric' => 'La remise doit être un nombre.',
            'discount.min' => 'La remise ne peut pas être négative.',
            'tax_rate.min' => 'Le taux de taxe ne peut pas être négatif.',
            'tax_rate.max' => 'Le taux de taxe ne peut pas dépasser 100 %.',
            'payment_method.required' => 'Le mode de paiement est obligatoire.',
        ];
    }

    /**
     * @return array<string, string>
     */
    public function attributes(): array
    {
        return [
            'customer_id' => 'le client',
            'discount' => 'la remise',
            'tax_rate' => 'le taux de taxe',
            'payment_method' => 'le mode de paiement',
            'payment_status' => 'le statut de paiement',
        ];
    }
}
