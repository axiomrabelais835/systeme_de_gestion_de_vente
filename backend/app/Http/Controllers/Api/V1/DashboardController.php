<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\ApiController;
use App\Http\Resources\SaleResource;
use App\Services\DashboardService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DashboardController extends ApiController
{
    public function __construct(private readonly DashboardService $dashboard) {}

    public function summary(): JsonResponse
    {
        return $this->success($this->dashboard->summary());
    }

    public function salesChart(Request $request): JsonResponse
    {
        $period = $request->string('period', '30d')->toString();

        if (! in_array($period, ['7d', '30d', '12m'], true)) {
            $period = '30d';
        }

        return $this->success([
            'period' => $period,
            'points' => $this->dashboard->salesChart($period),
        ]);
    }

    public function topProducts(Request $request): JsonResponse
    {
        $period = $this->validPeriod($request);
        $limit = min(max($request->integer('limit', 5), 1), 20);

        return $this->success([
            'period' => $period,
            'products' => $this->dashboard->topProducts($limit, $period),
        ]);
    }

    public function salesByCategory(Request $request): JsonResponse
    {
        $period = $this->validPeriod($request);

        return $this->success([
            'period' => $period,
            'categories' => $this->dashboard->salesByCategory($period),
        ]);
    }

    public function recentSales(Request $request): JsonResponse
    {
        $limit = min(max($request->integer('limit', 8), 1), 30);

        return $this->success(
            SaleResource::collection($this->dashboard->recentSales($limit))->resolve()
        );
    }

    private function validPeriod(Request $request): string
    {
        $period = $request->string('period', '30d')->toString();

        return in_array($period, ['7d', '30d', '12m'], true) ? $period : '30d';
    }
}
