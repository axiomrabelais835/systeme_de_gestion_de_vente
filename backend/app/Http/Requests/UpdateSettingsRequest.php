<?php

declare(strict_types=1);

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class UpdateSettingsRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->isAdmin() ?? false;
    }

    /**
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        return [
            'company_name' => ['sometimes', 'string', 'max:120'],
            'currency' => ['sometimes', 'string', 'max:12'],
            'currency_symbol' => ['sometimes', 'string', 'max:12'],
            'default_tax_rate' => ['sometimes', 'numeric', 'min:0', 'max:100'],
            'default_low_stock_threshold' => ['sometimes', 'integer', 'min:0', 'max:100000'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'default_tax_rate.min' => 'Le taux de taxe ne peut pas être négatif.',
            'default_tax_rate.max' => 'Le taux de taxe ne peut pas dépasser 100 %.',
            'default_low_stock_threshold.integer' => 'Le seuil de stock par défaut doit être un nombre entier.',
        ];
    }
}
