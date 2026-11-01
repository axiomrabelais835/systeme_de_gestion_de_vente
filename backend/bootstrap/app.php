<?php

use App\Exceptions\BusinessException;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Validation\ValidationException;
use Illuminate\Auth\AuthenticationException;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware) {
        $middleware->statefulApi();
    })
    ->withExceptions(function (Exceptions $exceptions) {
        // Erreurs de validation : messages en français, format uniforme.
        $exceptions->shouldRenderJsonWhen(
            fn (Request $request): bool => $request->is('api/*') || $request->expectsJson()
        );

        $exceptions->render(function (ValidationException $e, Request $request) {
            if (! $request->is('api/*')) {
                return null;
            }

            return response()->json([
                'success' => false,
                'message' => 'Les données envoyées sont invalides.',
                'errors' => $e->errors(),
            ], 422);
        });

        // Règles métier (stock insuffisant, suppression interdite, etc.).
        $exceptions->render(function (BusinessException $e, Request $request) {
            if (! $request->is('api/*')) {
                return null;
            }

            return response()->json([
                'success' => false,
                'message' => $e->getMessage(),
                'errors' => $e->errors(),
            ], $e->status());
        });

        // Non authentifié : 401 JSON homogène (sinon le renderer générique
        // ci-dessous renverrait un 500 puisque cette exception n'a pas de statut).
        $exceptions->render(function (AuthenticationException $e, Request $request) {
            if (! $request->is('api/*')) {
                return null;
            }

            return response()->json([
                'success' => false,
                'message' => 'Authentification requise. Veuillez vous connecter.',
                'errors' => [],
            ], 401);
        });

        // Erreurs génériques API : JSON homogène.
        $exceptions->render(function (\Throwable $e, Request $request) {
            if (! $request->is('api/*')) {
                return null;
            }

            $status = method_exists($e, 'getStatusCode') ? $e->getStatusCode() : 500;

            if ($status === 404) {
                return response()->json([
                    'success' => false,
                    'message' => 'Ressource introuvable.',
                    'errors' => [],
                ], 404);
            }

            if ($status === 403) {
                return response()->json([
                    'success' => false,
                    'message' => 'Vous n\'avez pas les permissions nécessaires pour effectuer cette action.',
                    'errors' => [],
                ], 403);
            }

            if ($status === 405) {
                return response()->json([
                    'success' => false,
                    'message' => 'Méthode non autorisée.',
                    'errors' => [],
                ], 405);
            }

            if ($status === 429) {
                return response()->json([
                    'success' => false,
                    'message' => 'Trop de tentatives. Veuillez réessayer dans quelques instants.',
                    'errors' => [],
                ], 429);
            }

            if ($status < 500) {
                return response()->json([
                    'success' => false,
                    'message' => $e->getMessage(),
                    'errors' => [],
                ], $status);
            }

            return response()->json([
                'success' => false,
                'message' => config('app.debug')
                    ? $e->getMessage()
                    : 'Une erreur interne est survenue. Veuillez réessayer plus tard.',
                'errors' => [],
            ], 500);
        });
    })->create();
