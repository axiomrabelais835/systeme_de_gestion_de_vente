<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\ApiController;
use App\Http\Requests\Auth\LoginRequest;
use App\Http\Resources\UserResource;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Validation\ValidationException;

class AuthController extends ApiController
{
    /**
     * Connexion : renvoie un token Sanctum personnel.
     */
    public function login(LoginRequest $request): JsonResponse
    {
        $user = User::query()->where('email', $request->validated('email'))->first();

        if ($user === null || ! Hash::check($request->string('password')->toString(), $user->password)) {
            throw ValidationException::withMessages([
                'email' => ['Identifiants incorrects. Vérifiez votre e-mail et votre mot de passe.'],
            ]);
        }

        if (! $user->is_active) {
            throw ValidationException::withMessages([
                'email' => ['Ce compte a été désactivé. Contactez un administrateur.'],
            ]);
        }

        $token = $user->createToken($request->input('device_name', 'salesstock-web'));

        return $this->success([
            'user' => new UserResource($user),
            'token' => $token->plainTextToken,
        ]);
    }

    /**
     * Déconnexion : révoque uniquement le token utilisé.
     */
    public function logout(Request $request): JsonResponse
    {
        $request->user()->currentAccessToken()?->delete();

        return $this->success(['message' => 'Déconnexion réussie.']);
    }

    public function me(Request $request): JsonResponse
    {
        return $this->success(new UserResource($request->user()));
    }
}
