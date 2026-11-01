<?php

declare(strict_types=1);

namespace Database\Seeders;

use App\Enums\MovementType;
use App\Models\Category;
use App\Models\Product;
use Illuminate\Database\Seeder;

class ProductsSeeder extends Seeder
{
    /**
     * Soixante produits réalistes répartis sur 8 catégories.
     * Quelques-uns sont volontairement en stock faible ou en rupture
     * pour que les alertes du tableau de bord soient visibles.
     *
     * @var list<array{cat: string, prefix: string, name: string, price: float, qty: int, threshold: int}>
     */
    private array $products = [
        // Électronique
        ['cat' => 'Électronique', 'prefix' => 'ELEC', 'name' => 'Casque audio sans fil Pro', 'price' => 25000, 'qty' => 42, 'threshold' => 8],
        ['cat' => 'Électronique', 'prefix' => 'ELEC', 'name' => 'Enceinte Bluetooth nomade', 'price' => 18500, 'qty' => 30, 'threshold' => 6],
        ['cat' => 'Électronique', 'prefix' => 'ELEC', 'name' => 'Chargeur rapide USB-C 25W', 'price' => 6500, 'qty' => 120, 'threshold' => 15],
        ['cat' => 'Électronique', 'prefix' => 'ELEC', 'name' => 'Câble USB-C tressé 2 m', 'price' => 3500, 'qty' => 95, 'threshold' => 12],
        ['cat' => 'Électronique', 'prefix' => 'ELEC', 'name' => 'Batterie externe 20 000 mAh', 'price' => 15000, 'qty' => 3, 'threshold' => 8],
        ['cat' => 'Électronique', 'prefix' => 'ELEC', 'name' => 'Adaptateur secteur universel', 'price' => 5500, 'qty' => 0, 'threshold' => 5],
        ['cat' => 'Électronique', 'prefix' => 'ELEC', 'name' => 'Hub USB-C 4 ports', 'price' => 12000, 'qty' => 22, 'threshold' => 5],
        ['cat' => 'Électronique', 'prefix' => 'ELEC', 'name' => 'Lampe LED de bureau', 'price' => 8000, 'qty' => 4, 'threshold' => 6],
        // Informatique
        ['cat' => 'Informatique', 'prefix' => 'INFO', 'name' => 'Clavier mécanique rétroéclairé', 'price' => 32000, 'qty' => 25, 'threshold' => 5],
        ['cat' => 'Informatique', 'prefix' => 'INFO', 'name' => 'Souris gaming 6400 DPI', 'price' => 14500, 'qty' => 40, 'threshold' => 8],
        ['cat' => 'Informatique', 'prefix' => 'INFO', 'name' => 'Écran LED 24" Full HD', 'price' => 85000, 'qty' => 12, 'threshold' => 3],
        ['cat' => 'Informatique', 'prefix' => 'INFO', 'name' => 'SSD NVMe 1 To', 'price' => 52000, 'qty' => 18, 'threshold' => 4],
        ['cat' => 'Informatique', 'prefix' => 'INFO', 'name' => 'Barrette mémoire RAM 16 Go DDR4', 'price' => 28000, 'qty' => 2, 'threshold' => 4],
        ['cat' => 'Informatique', 'prefix' => 'INFO', 'name' => 'Webcam HD 1080p', 'price' => 16500, 'qty' => 35, 'threshold' => 6],
        ['cat' => 'Informatique', 'prefix' => 'INFO', 'name' => 'Station d\'accueil USB-C', 'price' => 45000, 'qty' => 9, 'threshold' => 3],
        ['cat' => 'Informatique', 'prefix' => 'INFO', 'name' => 'Disque dur externe 2 To', 'price' => 48000, 'qty' => 14, 'threshold' => 4],
        ['cat' => 'Informatique', 'prefix' => 'INFO', 'name' => 'Support portable ergonomique', 'price' => 21000, 'qty' => 0, 'threshold' => 3],
        // Téléphonie
        ['cat' => 'Téléphonie', 'prefix' => 'TEL', 'name' => 'Coque de protection iPhone 15', 'price' => 4500, 'qty' => 88, 'threshold' => 15],
        ['cat' => 'Téléphonie', 'prefix' => 'TEL', 'name' => 'Verre trempé universel', 'price' => 2500, 'qty' => 150, 'threshold' => 20],
        ['cat' => 'Téléphonie', 'prefix' => 'TEL', 'name' => 'Support voiture magnétique', 'price' => 5000, 'qty' => 60, 'threshold' => 10],
        ['cat' => 'Téléphonie', 'prefix' => 'TEL', 'name' => 'Chargeur secteur 33W double port', 'price' => 9500, 'qty' => 45, 'threshold' => 8],
        ['cat' => 'Téléphonie', 'prefix' => 'TEL', 'name' => 'Écouteurs sans fil TWS', 'price' => 12500, 'qty' => 55, 'threshold' => 10],
        ['cat' => 'Téléphonie', 'prefix' => 'TEL', 'name' => 'Câble Lightning tressé 1,5 m', 'price' => 4000, 'qty' => 3, 'threshold' => 10],
        ['cat' => 'Téléphonie', 'prefix' => 'TEL', 'name' => 'Batterie solaire 10 000 mAh', 'price' => 17500, 'qty' => 11, 'threshold' => 4],
        ['cat' => 'Téléphonie', 'prefix' => 'TEL', 'name' => 'Housse de téléphone en cuir', 'price' => 6000, 'qty' => 7, 'threshold' => 8],
        // Maison & Électroménager
        ['cat' => 'Maison & Électroménager', 'prefix' => 'MAIS', 'name' => 'Ventilateur tour 45 cm', 'price' => 22000, 'qty' => 26, 'threshold' => 5],
        ['cat' => 'Maison & Électroménager', 'prefix' => 'MAIS', 'name' => 'Bouilloire électrique 1,7 L', 'price' => 12500, 'qty' => 33, 'threshold' => 6],
        ['cat' => 'Maison & Électroménager', 'prefix' => 'MAIS', 'name' => 'Grill-pain 2 fentes', 'price' => 14000, 'qty' => 2, 'threshold' => 5],
        ['cat' => 'Maison & Électroménager', 'prefix' => 'MAIS', 'name' => 'Mixeur plongeant 3 vitesses', 'price' => 19500, 'qty' => 17, 'threshold' => 4],
        ['cat' => 'Maison & Électroménager', 'prefix' => 'MAIS', 'name' => 'Fer à repasser vapeur', 'price' => 16000, 'qty' => 21, 'threshold' => 5],
        ['cat' => 'Maison & Électroménager', 'prefix' => 'MAIS', 'name' => 'Machine à café expresso', 'price' => 65000, 'qty' => 8, 'threshold' => 3],
        ['cat' => 'Maison & Électroménager', 'prefix' => 'MAIS', 'name' => 'Robot pâtissier 5 L', 'price' => 78000, 'qty' => 0, 'threshold' => 2],
        ['cat' => 'Maison & Électroménager', 'prefix' => 'MAIS', 'name' => 'Aspirateur balai 2 en 1', 'price' => 42000, 'qty' => 13, 'threshold' => 4],
        // Bureau & Fournitures
        ['cat' => 'Bureau & Fournitures', 'prefix' => 'BUR', 'name' => 'Ramette A4 80 g (500 feuilles)', 'price' => 3800, 'qty' => 130, 'threshold' => 20],
        ['cat' => 'Bureau & Fournitures', 'prefix' => 'BUR', 'name' => 'Lot de 10 stylos bille', 'price' => 2500, 'qty' => 95, 'threshold' => 15],
        ['cat' => 'Bureau & Fournitures', 'prefix' => 'BUR', 'name' => 'Classeur à levier 8 cm', 'price' => 1800, 'qty' => 110, 'threshold' => 20],
        ['cat' => 'Bureau & Fournitures', 'prefix' => 'BUR', 'name' => 'Chaise de bureau ergonomique', 'price' => 58000, 'qty' => 6, 'threshold' => 3],
        ['cat' => 'Bureau & Fournitures', 'prefix' => 'BUR', 'name' => 'Bureau pliant 120x60 cm', 'price' => 35000, 'qty' => 5, 'threshold' => 3],
        ['cat' => 'Bureau & Fournitures', 'prefix' => 'BUR', 'name' => 'Cahier A5 200 p. (lot de 5)', 'price' => 4200, 'qty' => 74, 'threshold' => 12],
        ['cat' => 'Bureau & Fournitures', 'prefix' => 'BUR', 'name' => 'Toner laser noir compatible', 'price' => 24500, 'qty' => 16, 'threshold' => 4],
        // Vêtements & Accessoires
        ['cat' => 'Vêtements & Accessoires', 'prefix' => 'VET', 'name' => 'T-shirt coton unisexe', 'price' => 5500, 'qty' => 85, 'threshold' => 15],
        ['cat' => 'Vêtements & Accessoires', 'prefix' => 'VET', 'name' => 'Jean denim slim', 'price' => 15500, 'qty' => 40, 'threshold' => 8],
        ['cat' => 'Vêtements & Accessoires', 'prefix' => 'VET', 'name' => 'Sneakers cuir blanc', 'price' => 28000, 'qty' => 24, 'threshold' => 6],
        ['cat' => 'Vêtements & Accessoires', 'prefix' => 'VET', 'name' => 'Sac à dos ordinateur 15,6"', 'price' => 18500, 'qty' => 3, 'threshold' => 6],
        ['cat' => 'Vêtements & Accessoires', 'prefix' => 'VET', 'name' => 'Ceinture en cuir homme', 'price' => 7500, 'qty' => 52, 'threshold' => 10],
        ['cat' => 'Vêtements & Accessoires', 'prefix' => 'VET', 'name' => 'Robe wax élégante', 'price' => 22000, 'qty' => 18, 'threshold' => 5],
        ['cat' => 'Vêtements & Accessoires', 'prefix' => 'VET', 'name' => 'Casquette brodée', 'price' => 4500, 'qty' => 0, 'threshold' => 10],
        // Alimentation
        ['cat' => 'Alimentation', 'prefix' => 'ALI', 'name' => 'Riz parfumé 5 kg', 'price' => 4500, 'qty' => 140, 'threshold' => 25],
        ['cat' => 'Alimentation', 'prefix' => 'ALI', 'name' => 'Huile végétale 1 L', 'price' => 2200, 'qty' => 160, 'threshold' => 30],
        ['cat' => 'Alimentation', 'prefix' => 'ALI', 'name' => 'Sucre en poudre 1 kg', 'price' => 1200, 'qty' => 180, 'threshold' => 30],
        ['cat' => 'Alimentation', 'prefix' => 'ALI', 'name' => 'Café moulu 250 g', 'price' => 3500, 'qty' => 65, 'threshold' => 12],
        ['cat' => 'Alimentation', 'prefix' => 'ALI', 'name' => 'Lait en poudre 900 g', 'price' => 4800, 'qty' => 90, 'threshold' => 15],
        ['cat' => 'Alimentation', 'prefix' => 'ALI', 'name' => 'Farine de blé 1 kg', 'price' => 1500, 'qty' => 4, 'threshold' => 20],
        ['cat' => 'Alimentation', 'prefix' => 'ALI', 'name' => 'Concentré de tomate 400 g', 'price' => 1100, 'qty' => 120, 'threshold' => 25],
        // Sport & Loisirs
        ['cat' => 'Sport & Loisirs', 'prefix' => 'SPO', 'name' => 'Ballon de football taille 5', 'price' => 9500, 'qty' => 38, 'threshold' => 8],
        ['cat' => 'Sport & Loisirs', 'prefix' => 'SPO', 'name' => 'Paire d\'haltères réglables 20 kg', 'price' => 32000, 'qty' => 10, 'threshold' => 3],
        ['cat' => 'Sport & Loisirs', 'prefix' => 'SPO', 'name' => 'Tapis de yoga 6 mm', 'price' => 11500, 'qty' => 27, 'threshold' => 6],
        ['cat' => 'Sport & Loisirs', 'prefix' => 'SPO', 'name' => 'Corde à sauter cardio', 'price' => 3500, 'qty' => 3, 'threshold' => 10],
        ['cat' => 'Sport & Loisirs', 'prefix' => 'SPO', 'name' => 'Vélo de ville 26"', 'price' => 95000, 'qty' => 5, 'threshold' => 2],
        ['cat' => 'Sport & Loisirs', 'prefix' => 'SPO', 'name' => 'Jeu de société familial', 'price' => 13500, 'qty' => 22, 'threshold' => 5],
    ];

    public function run(): void
    {
        $categories = Category::query()->pluck('id', 'name');
        $counters = [];

        foreach ($this->products as $data) {
            $counters[$data['prefix']] = ($counters[$data['prefix']] ?? 0) + 1;
            $sku = sprintf('%s-%04d', $data['prefix'], $counters[$data['prefix']]);

            $product = Product::query()->firstOrCreate(
                ['sku' => $sku],
                [
                    'name' => $data['name'],
                    'category_id' => $categories[$data['cat']],
                    'description' => null,
                    'purchase_price' => round($data['price'] / 1.4, -2),
                    'selling_price' => $data['price'],
                    'quantity' => $data['qty'],
                    'low_stock_threshold' => $data['threshold'],
                    'is_active' => true,
                ]
            );

            // Traçabilité : le stock initial est toujours justifié par un mouvement.
            $hasMovement = $product->stockMovements()->exists();

            if (! $hasMovement) {
                $product->recordMovement(
                    MovementType::Entree,
                    $product->quantity,
                    'Stock initial'
                );
            }
        }
    }
}
