<?php

declare(strict_types=1);

namespace App\Http\Controllers;

use App\Enums\UserRole;
use Illuminate\Foundation\Auth\Access\AuthorizesRequests;
use Illuminate\Foundation\Validation\ValidatesRequests;
use Illuminate\Routing\Controller as BaseController;

abstract class ApiController extends BaseController
{
    use AuthorizesRequests, ValidatesRequests;

    /**
     * Réponse JSON homogène : { success, data, meta? }.
     *
     * @param  array<string, mixed>  $meta
     */
    protected function success(mixed $data, int $status = 200, array $meta = []): \Illuminate\Http\JsonResponse
    {
        // JSON_PRESERVE_ZERO_FRACTION : un montant float entier reste "20000.0"
        // au lieu d'être sérialisé en entier "20000" (types JSON stables côté client).
        return response()->json([
            'success' => true,
            'data' => $data,
            'meta' => (object) $meta,
        ], $status, [], JSON_PRESERVE_ZERO_FRACTION);
    }

    protected function isAdmin(\App\Models\User $user): bool
    {
        return $user->role === UserRole::Admin;
    }

    protected function perPage(\Illuminate\Http\Request $request, int $default = 15): int
    {
        return min(max((int) $request->input('per_page', $default), 1), 100);
    }

    /**
     * @return array<string, int>
     */
    protected function pageMeta(\Illuminate\Pagination\AbstractPaginator $paginator): array
    {
        return [
            'current_page' => $paginator->currentPage(),
            'per_page' => $paginator->perPage(),
            'total' => $paginator->total(),
            'last_page' => $paginator->lastPage(),
        ];
    }
}
