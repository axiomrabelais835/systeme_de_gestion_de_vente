<?php

declare(strict_types=1);

namespace Database\Factories;

use App\Models\Category;
use App\Models\Product;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Product>
 */
class ProductFactory extends Factory
{
    /**
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        $purchase = fake()->randomFloat(0, 1000, 150000);
        $selling = round($purchase * fake()->randomFloat(2, 1.2, 2.2), -2);

        return [
            'name' => ucwords(fake()->unique()->words(3, true)),
            'sku' => strtoupper(fake()->unique()->bothify('???-#####')),
            'category_id' => Category::factory(),
            'description' => fake()->optional()->paragraph(),
            'purchase_price' => $purchase,
            'selling_price' => max($selling, 500),
            'quantity' => fake()->numberBetween(0, 120),
            'low_stock_threshold' => fake()->numberBetween(3, 10),
            'image' => null,
            'is_active' => true,
        ];
    }

    public function outOfStock(): static
    {
        return $this->state(fn () => ['quantity' => 0]);
    }

    public function lowStock(): static
    {
        return $this->state(fn () => ['quantity' => 3, 'low_stock_threshold' => 5]);
    }
}
