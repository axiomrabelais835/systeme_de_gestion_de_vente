<?php

declare(strict_types=1);

namespace Database\Seeders;

use App\Models\Category;
use Illuminate\Database\Seeder;

class CategoriesSeeder extends Seeder
{
    /**
     * Huit catégories réalistes en français.
     *
     * @var list<array{name: string, description: string}>
     */
    private array $categories = [
        ['name' => 'Électronique', 'description' => 'Accessoires et périphériques électroniques du quotidien.'],
        ['name' => 'Informatique', 'description' => 'Ordinateurs, composants et équipements de bureau.'],
        ['name' => 'Téléphonie', 'description' => 'Accessoires pour smartphones et tablettes.'],
        ['name' => 'Maison & Électroménager', 'description' => 'Appareils et équipements pour la maison.'],
        ['name' => 'Bureau & Fournitures', 'description' => 'Fournitures et matériel de bureau.'],
        ['name' => 'Vêtements & Accessoires', 'description' => 'Mode, chaussures et accessoires.'],
        ['name' => 'Alimentation', 'description' => 'Produits d\'épicerie et denrées de base.'],
        ['name' => 'Sport & Loisirs', 'description' => 'Équipements de sport et articles de loisirs.'],
    ];

    public function run(): void
    {
        foreach ($this->categories as $category) {
            Category::firstOrCreate(
                ['name' => $category['name']],
                ['description' => $category['description']]
            );
        }
    }
}
