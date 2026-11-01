<?php

declare(strict_types=1);

namespace Database\Factories;

use App\Models\Customer;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Customer>
 */
class CustomerFactory extends Factory
{
    /**
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'name' => fake()->name(),
            'email' => fake()->unique()->optional(0.8)->safeEmail(),
            'phone' => fake()->optional(0.9)->numerify('+225 07 ########'),
            'address' => fake()->optional(0.6)->streetAddress(),
            'notes' => fake()->optional()->sentence(),
        ];
    }
}
