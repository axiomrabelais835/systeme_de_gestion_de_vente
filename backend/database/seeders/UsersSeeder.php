<?php

declare(strict_types=1);

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;

class UsersSeeder extends Seeder
{
    /**
     * Comptes de démonstration : un administrateur et deux vendeurs.
     * Mot de passe commun : "password".
     */
    public function run(): void
    {
        User::query()->upsert(
            [
                [
                    'name' => 'Aminata Koné',
                    'email' => 'admin@salesstock.test',
                    'password' => bcrypt('password'),
                    'role' => 'admin',
                    'is_active' => true,
                    'email_verified_at' => now(),
                    'created_at' => now(),
                    'updated_at' => now(),
                ],
                [
                    'name' => 'Yao Kouassi',
                    'email' => 'vendeur@salesstock.test',
                    'password' => bcrypt('password'),
                    'role' => 'vendeur',
                    'is_active' => true,
                    'email_verified_at' => now(),
                    'created_at' => now(),
                    'updated_at' => now(),
                ],
                [
                    'name' => 'Fatou Diallo',
                    'email' => 'vendeur2@salesstock.test',
                    'password' => bcrypt('password'),
                    'role' => 'vendeur',
                    'is_active' => true,
                    'email_verified_at' => now(),
                    'created_at' => now(),
                    'updated_at' => now(),
                ],
            ],
            ['email'],
            ['name', 'password', 'role', 'is_active', 'email_verified_at', 'updated_at']
        );
    }
}
