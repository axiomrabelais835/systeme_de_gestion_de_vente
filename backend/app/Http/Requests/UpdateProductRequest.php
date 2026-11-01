<?php

declare(strict_types=1);

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class UpdateProductRequest extends FormRequest
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
            'sku' => ['required', 'string', 'max:60', Rule::unique('products', 'sku')->ignore($this->route('product'))],
            'category_id' => ['required', 'integer', 'exists:categories,id'],
            'description' => ['nullable', 'string', 'max:2000'],
            'purchase_price' => ['required', 'numeric', 'min:0', 'max:9999999999'],
            'selling_price' => ['required', 'numeric', 'min:0.01', 'max:9999999999'],
            // Le stock ne se modifie jamais ici : uniquement via adjust-stock.
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
            'category_id.exists' => 'La catégorie sélectionnée n\'existe pas.',
            'selling_price.min' => 'Le prix de vente doit être supérieur à 0.',
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
            'low_stock_threshold' => 'le seuil de stock faible',
        ];
    }
}
