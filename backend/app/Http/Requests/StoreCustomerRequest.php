<?php

declare(strict_types=1);

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreCustomerRequest extends FormRequest
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
            'email' => ['nullable', 'email', 'max:200', 'unique:customers,email'],
            'phone' => ['nullable', 'string', 'max:50'],
            'address' => ['nullable', 'string', 'max:255'],
            'notes' => ['nullable', 'string', 'max:2000'],
        ];
    }

    /**
     * @return array<string, string>
     */
    public function messages(): array
    {
        return [
            'name.required' => 'Le nom du client est obligatoire.',
            'email.email' => 'L\'adresse e-mail est invalide.',
            'email.unique' => 'Un client avec cette adresse e-mail existe déjà.',
        ];
    }

    /**
     * @return array<string, string>
     */
    public function attributes(): array
    {
        return [
            'name' => 'le nom du client',
            'email' => 'l\'adresse e-mail',
            'phone' => 'le téléphone',
            'address' => 'l\'adresse',
            'notes' => 'les notes',
        ];
    }
}
