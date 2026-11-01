<?php

declare(strict_types=1);

namespace App\Services;

use App\Models\Sale;

/**
 * Génération des références de vente au format VTE-AAAA-NNNNNN.
 */
class ReferenceService
{
    public function nextSaleReference(): string
    {
        $prefix = sprintf('VTE-%d-', now()->year);

        $last = Sale::query()
            ->where('reference', 'like', $prefix.'%')
            ->orderByDesc('reference')
            ->value('reference');

        $next = $last !== null ? (int) substr($last, strlen($prefix)) + 1 : 1;

        return $prefix.str_pad((string) $next, 6, '0', STR_PAD_LEFT);
    }
}
