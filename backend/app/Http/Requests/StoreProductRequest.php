<?php

declare(strict_types=1);

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreProductRequest extends FormRequest
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
            'name' => ['required', 'string', 'max:200'],
            'sku' => ['required', 'string', 'max:60', 'unique:products,sku'],
            'category_id' => ['required', 'integer', 'exists:categories,id'],
            'description' => ['nullable', 'string', 'max:2000'],
            'purchase_price' => ['required', 'numeric', 'min:0', 'max:9999999999'],
            'selling_price' => ['required', 'numeric', 'min:0.01', 'max:9999999999'],
            'quantity' => ['required', 'integer', 'min:0', 'max:1000000'],
            'low_stock_threshold' => ['required', 'integer', 'min:0', 'max:100000'],
            'image' => ['nullable', 'string', 'max:500'],
            'is_active' => ['sometimes', 'boolean'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'name.required' => 'Le nom du produit est obligatoire.',
            'sku.required' => 'Le code SKU est obligatoire.',
            'sku.unique' => 'Un produit avec ce code SKU existe déjà.',
            'category_id.required' => 'La catégorie est obligatoire.',
            'category_id.exists' => 'La catégorie sélectionnée n\'existe pas.',
            'purchase_price.required' => 'Le prix d\'achat est obligatoire.',
            'purchase_price.numeric' => 'Le prix d\'achat doit être un nombre.',
            'selling_price.required' => 'Le prix de vente est obligatoire.',
            'selling_price.min' => 'Le prix de vente doit être supérieur à 0.',
            'quantity.required' => 'La quantité en stock est obligatoire.',
            'quantity.integer' => 'La quantité doit être un nombre entier.',
            'quantity.min' => 'La quantité ne peut pas être négative.',
            'low_stock_threshold.required' => 'Le seuil de stock faible est obligatoire.',
        ];
    }

    /**
     * @return array<string, string>
     */
    public function attributes(): array
    {
        return [
            'name' => 'le nom du produit',
            'sku' => 'le code SKU',
            'category_id' => 'la catégorie',
            'purchase_price' => 'le prix d\'achat',
            'selling_price' => 'le prix de vente',
            'quantity' => 'la quantité',
            'low_stock_threshold' => 'le seuil de stock faible',
        ];
    }
}
