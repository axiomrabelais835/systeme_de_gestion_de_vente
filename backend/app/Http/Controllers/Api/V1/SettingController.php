<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\V1;

use App\Http\Controllers\ApiController;
use App\Http\Requests\UpdateSettingsRequest;
use App\Models\Setting;
use Illuminate\Http\JsonResponse;

class SettingController extends ApiController
{
    /**
     * Réglages applicatifs (devise, taxe, seuil par défaut…).
     */
    public function index(): JsonResponse
    {
        return $this->success($this->settingsArray());
    }

    public function update(UpdateSettingsRequest $request): JsonResponse
    {
        foreach ($request->validated() as $key => $value) {
            Setting::setValue($key, $value === null ? null : (string) $value);
        }

        return $this->success($this->settingsArray());
    }

    /**
     * @return array<string, mixed>
     */
    private function settingsArray(): array
    {
        $settings = Setting::allSettings();

        return [
            'company_name' => $settings['company_name'] ?? 'SalesStock',
            'currency' => $settings['currency'] ?? 'FCFA',
            'currency_symbol' => $settings['currency_symbol'] ?? 'FCFA',
            'default_tax_rate' => (float) ($settings['default_tax_rate'] ?? 18),
            'default_low_stock_threshold' => (int) ($settings['default_low_stock_threshold'] ?? 5),
        ];
    }
}
