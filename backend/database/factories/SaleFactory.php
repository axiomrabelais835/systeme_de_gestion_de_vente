<?php

declare(strict_types=1);

namespace Database\Factories;

use App\Enums\PaymentMethod;
use App\Enums\PaymentStatus;
use App\Enums\SaleStatus;
use App\Models\Sale;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Sale>
 */
class SaleFactory extends Factory
{
    /**
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $subtotal = fake()->randomFloat(2, 2000, 400000);
        $discount = 0;
        $tax = round(($subtotal - $discount) * 0.18, 2);

        return [
            'reference' => 'VTE-'.now()->year.'-'.fake()->unique()->numberBetween(1, 999999),
            'customer_id' => null,
            'user_id' => User::factory(),
            'subtotal' => $subtotal,
            'discount' => $discount,
            'tax' => $tax,
            'total' => round($subtotal - $discount + $tax, 2),
            'payment_method' => fake()->randomElement(PaymentMethod::cases()),
            'payment_status' => PaymentStatus::Payee,
            'status' => SaleStatus::Validee,
            'sold_at' => fake()->dateTimeBetween('-6 months', 'now'),
        ];
    }

    public function cancelled(): static
    {
        return $this->state(fn () => [
            'status' => SaleStatus::Annulee,
            'cancelled_at' => fake()->dateTimeBetween('-3 months', 'now'),
            'cancel_reason' => fake()->sentence(),
        ]);
    }
}
