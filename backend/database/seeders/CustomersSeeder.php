<?php

declare(strict_types=1);

namespace Database\Seeders;

use App\Models\Customer;
use Illuminate\Database\Seeder;

class CustomersSeeder extends Seeder
{
    /**
     * Quarante clients réalistes (particuliers et entreprises).
     *
     * @var list<string>
     */
    private array $names = [
        'Entreprise Kodjo & Fils',
        'Marie Konan',
        'Serge Kouadio',
        'Aïcha Traoré',
        'Boutique La Grâce',
        'Jean-Baptiste N\'Guessan',
        'Fatoumata Coulibaly',
        'Pharmacie du Plateau',
        'Établissements Diabaté',
        'Clarisse Yao',
        'Moussa Ouédraogo',
        'Superette Espoir',
        'Patrice Zongo',
        'Nadège Bamba',
        'Centre informatique Adjangba',
        'Ibrahim Cissé',
        'Solange Assamoi',
        'Boulangerie Le Délice',
        'Éric Tanoh',
        'Awa Sanogo',
        'Restaurant Chez Mama',
        'Hervé Gnahoré',
        'Chantal Doumbia',
        'Librairie La Plume',
        'Yaya Camara',
        'Georgette Amani',
        'Cabinet Conseil Abidjan',
        'Sékou Touré',
        'Rachelle Kouamé',
        'Quincaillerie du Nord',
        'Alain Bogui',
        'Miriam Sery',
        'Garage Auto Plus',
        'Fabrice Yapo',
        'Émilie Sow',
        'Épicerie Bonheur',
        'Constant Aké',
        'Josiane Ehoulé',
        'SARL Matériaux BTP',
        'Olivier Sankara',
    ];

    public function run(): void
    {
        foreach ($this->names as $index => $name) {
            $isCompany = str_contains($name, 'Entreprise')
                || str_contains($name, 'Boutique')
                || str_contains($name, 'Superette')
                || str_contains($name, 'Pharmacie')
                || str_contains($name, 'Restaurant')
                || str_contains($name, 'Librairie')
                || str_contains($name, 'Garage')
                || str_contains($name, 'Épicerie')
                || str_contains($name, 'Boulangerie')
                || str_contains($name, 'Quincaillerie')
                || str_contains($name, 'Centre')
                || str_contains($name, 'Cabinet')
                || str_contains($name, 'SARL')
                || str_contains($name, 'Établissements');

            Customer::firstOrCreate(
                ['name' => $name],
                [
                    'email' => $isCompany
                        ? \Illuminate\Support\Str::slug($name, '.').'@exemple.ci'
                        : fake()->unique()->safeEmail(),
                    'phone' => '+225 0'.fake()->numberBetween(1, 7).' '.fake()->numerify('## ## ## ##'),
                    'address' => fake()->optional($isCompany ? 0.9 : 0.5)->streetAddress().', '.fake()->city(),
                    'notes' => $index % 7 === 0 ? 'Client régulier, privilégie la livraison.' : null,
                ]
            );
        }
    }
}
