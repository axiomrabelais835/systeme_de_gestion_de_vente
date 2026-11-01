<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\ApiController;
use App\Http\Resources\StockMovementResource;
use App\Models\StockMovement;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\StreamedResponse;

class StockMovementController extends ApiController
{
    public function index(Request $request): JsonResponse
    {
        $movements = $this->filteredQuery($request)
            ->orderByDesc('created_at')
            ->orderByDesc('id')
            ->paginate($this->perPage($request));

        return $this->success(
            StockMovementResource::collection($movements)->resolve(),
            200,
            $this->pageMeta($movements)
        );
    }

    /**
     * Export CSV du journal (mêmes filtres que l'index).
     */
    public function export(Request $request): StreamedResponse
    {
        $query = $this->filteredQuery($request)
            ->orderByDesc('created_at')
            ->orderByDesc('id')
            ->cursor();

        $filename = 'mouvements-'.now()->format('Ymd-His').'.csv';

        return response()->streamDownload(function () use ($query): void {
            $handle = fopen('php://output', 'w');
            fwrite($handle, "\xEF\xBB\xBF"); // BOM UTF-8 pour Excel.

            fputcsv($handle, [
                'Date', 'Produit', 'SKU', 'Type',
                'Quantité', 'Motif', 'Référence', 'Opérateur',
            ], ';');

            foreach ($query as $movement) {
                fputcsv($handle, [
                    $movement->created_at?->format('d/m/Y H:i'),
                    $movement->product?->name ?? 'Produit supprimé',
                    $movement->product?->sku ?? '—',
                    $movement->type->label(),
                    $movement->quantity,
                    $movement->reason ?? '—',
                    $movement->reference ?? '—',
                    $movement->user?->name ?? '—',
                ], ';');
            }

            fclose($handle);
        }, $filename, [
            'Content-Type' => 'text/csv; charset=UTF-8',
        ]);
    }

    /**
     * @return Builder<StockMovement>
     */
    private function filteredQuery(Request $request): Builder
    {
        return StockMovement::query()
            ->with(['product:id,name,sku', 'user:id,name,role'])
            ->filter(
                $request->filled('product_id') ? $request->integer('product_id') : null,
                $request->string('type')->toString() ?: null,
                $request->string('date_from')->toString() ?: null,
                $request->string('date_to')->toString() ?: null,
            );
    }
}
