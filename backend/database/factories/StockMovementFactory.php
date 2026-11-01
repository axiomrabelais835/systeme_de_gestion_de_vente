<?php

declare(strict_types=1);

namespace Database\Factories;

use App\Enums\MovementType;
use App\Models\Product;
use App\Models\StockMovement;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<StockMovement>
 */
class StockMovementFactory extends Factory
{
    /**
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'product_id' => Product::factory(),
            'type' => MovementType::Entree,
            'quantity' => fake()->numberBetween(1, 50),
            'reason' => 'Réapprovisionnement',
            'reference' => null,
            'user_id' => User::factory(),
            'created_at' => fake()->dateTimeBetween('-6 months', 'now'),
        ];
    }
}
