<?php

declare(strict_types=1);

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class AdjustStockRequest extends FormRequest
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
            'quantity_delta' => ['required', 'integer', 'not_in:0', 'between:-1000000,1000000'],
            'reason' => ['nullable', 'string', 'max:255'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'quantity_delta.required' => 'La quantité d\'ajustement est obligatoire.',
            'quantity_delta.integer' => 'L\'ajustement doit être un nombre entier.',
            'quantity_delta.not_in' => 'L\'ajustement ne peut pas être égal à zéro.',
        ];
    }

    /**
     * @return array<string, string>
     */
    public function attributes(): array
    {
        return [
            'quantity_delta' => 'la quantité d\'ajustement',
            'reason' => 'le motif',
        ];
    }
}
