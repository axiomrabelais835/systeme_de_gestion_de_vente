<?php

declare(strict_types=1);

namespace Database\Seeders;

use App\Models\Setting;
use Illuminate\Database\Seeder;

class SettingsSeeder extends Seeder
{
    /**
     * Réglages par défaut de l'application (modifiables dans « Paramètres »).
     */
    public function run(): void
    {
        $defaults = [
            'company_name' => 'SalesStock',
            'currency' => 'FCFA',
            'currency_symbol' => 'FCFA',
            'default_tax_rate' => '18',
            'default_low_stock_threshold' => '5',
        ];

        foreach ($defaults as $key => $value) {
            Setting::setValue($key, $value);
        }
    }
}
