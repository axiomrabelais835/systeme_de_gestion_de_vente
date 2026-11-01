<?php

declare(strict_types=1);

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;

uses(RefreshDatabase::class);

describe('Authentification', function () {

    test('un utilisateur valide peut se connecter et reçoit un token', function () {
        $user = User::factory()->admin()->create([
            'email' => 'admin@salesstock.test',
            'password' => bcrypt('password'),
        ]);

        $response = $this->postJson('/api/v1/auth/login', [
            'email' => 'admin@salesstock.test',
            'password' => 'password',
        ]);

        expectApiSuccess($response, 200)
            ->assertJsonPath('data.user.email', 'admin@salesstock.test')
            ->assertJsonPath('data.user.role', 'admin')
            ->assertJsonStructure(['data' => ['user' => ['id', 'name', 'email', 'role'], 'token']]);

        expect($user->tokens()->count())->toBe(1);
    });

    test('un mauvais mot de passe est refusé avec 422', function () {
        User::factory()->create([
            'email' => 'vendeur@salesstock.test',
            'password' => bcrypt('password'),
        ]);

        $response = $this->postJson('/api/v1/auth/login', [
            'email' => 'vendeur@salesstock.test',
            'password' => 'mauvais-mot-de-passe',
        ]);

        $response->assertStatus(422)
            ->assertJsonPath('success', false)
            ->assertJsonPath('errors.email.0', 'Identifiants incorrects. Vérifiez votre e-mail et votre mot de passe.');
    });

    test('un compte désactivé ne peut pas se connecter', function () {
        User::factory()->create([
            'email' => 'suspendu@salesstock.test',
            'password' => bcrypt('password'),
            'is_active' => false,
        ]);

        $response = $this->postJson('/api/v1/auth/login', [
            'email' => 'suspendu@salesstock.test',
            'password' => 'password',
        ]);

        $response->assertStatus(422)
            ->assertJsonPath('success', false);
    });

    test('la connexion est limitée à 5 tentatives par minute', function () {
        User::factory()->create([
            'email' => 'limité@salesstock.test',
            'password' => bcrypt('password'),
        ]);

        foreach (range(1, 5) as $i) {
            $this->postJson('/api/v1/auth/login', [
                'email' => 'limité@salesstock.test',
                'password' => 'faux',
            ])->assertStatus(422);
        }

        $this->postJson('/api/v1/auth/login', [
            'email' => 'limité@salesstock.test',
            'password' => 'faux',
        ])->assertStatus(429);
    });

    test('me renvoie le profil de l\'utilisateur connecté', function () {
        $user = createVendeur();

        $response = $this->actingAs($user, 'sanctum')->getJson('/api/v1/auth/me');

        expectApiSuccess($response)
            ->assertJsonPath('data.email', $user->email)
            ->assertJsonPath('data.role', 'vendeur');
    });

    test('me rejette les requêtes non authentifiées avec 401', function () {
        $this->getJson('/api/v1/auth/me')->assertStatus(401);
    });

    test('logout révoque le token courant', function () {
        $user = createVendeur();
        $this->actingAs($user, 'sanctum')->postJson('/api/v1/auth/logout')
            ->assertStatus(200);

        expect($user->tokens()->count())->toBe(0);
    });
});
