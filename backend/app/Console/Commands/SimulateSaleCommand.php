<?php

declare(strict_types=1);

namespace App\Console\Commands;

use App\Models\User;
use App\Services\SaleService;
use Illuminate\Console\Command;

/**
 * Tente de créer une vente via SaleService et affiche le résultat en JSON.
 * Utilisée par les tests de concurrence (SaleConcurrencyTest) qui lancent
 * plusieurs processus simultanés pour vérifier le verrouillage du stock.
 *
 * Cette commande n'est PAS destinée à une utilisation en production.
 */
class SimulateSaleCommand extends Command
{
    protected $signature = 'sale:simulate
        {--product= : Identifiant du produit}
        {--qty=1 : Quantité demandée}
        {--email= : E-mail du vendeur à utiliser}
        {--discount=0 : Remise éventuelle}
        {--payment=especes : Mode de paiement}
        {--ready-file= : Fichier de signalisation « prêt » créé avant la barrière}
        {--wait-for= : Fichier-barrière : la commande attend sa création avant de démarrer}';

    protected $description = '[TEST] Tente une vente via SaleService et affiche le résultat en JSON';

    public function handle(SaleService $saleService): int
    {
        $this->signalReady();
        $this->waitForBarrier();

        $productId = (int) $this->option('product');
        $quantity = (int) $this->option('qty');
        $email = $this->option('email') ?: User::query()->first()?->email;

        $user = User::query()->where('email', $email)->first();

        if ($user === null) {
            $this->line(json_encode(['ok' => false, 'message' => 'Utilisateur introuvable.']));

            return self::FAILURE;
        }

        $started = microtime(true);

        try {
            $sale = $saleService->create([
                'items' => [['product_id' => $productId, 'quantity' => $quantity]],
                'discount' => (float) $this->option('discount'),
                'payment_method' => $this->option('payment'),
            ], $user);

            $this->line(json_encode([
                'ok' => true,
                'reference' => $sale->reference,
                'total' => (float) $sale->total,
                'elapsed_ms' => (int) ((microtime(true) - $started) * 1000),
            ]));

            return self::SUCCESS;
        } catch (\Throwable $e) {
            $this->line(json_encode([
                'ok' => false,
                'message' => $e->getMessage(),
                'elapsed_ms' => (int) ((microtime(true) - $started) * 1000),
            ]));

            return self::FAILURE;
        }
    }

    /**
     * Signale au test que ce processus est prêt à démarrer la simulation.
     */
    private function signalReady(): void
    {
        $file = (string) $this->option('ready-file');

        if ($file !== '') {
            file_put_contents($file, 'ready');
        }
    }

    /**
     * Barrière de démarrage : attend la création d'un fichier partagé,
     * ce qui garantit que tous les processus démarrent ensemble.
     */
    private function waitForBarrier(): void
    {
        $file = (string) $this->option('wait-for');

        if ($file === '') {
            return;
        }

        $deadline = microtime(true) + 30;

        while (! file_exists($file)) {
            if (microtime(true) > $deadline) {
                $this->line(json_encode(['ok' => false, 'message' => 'Barrière expirée.']));

                exit(self::FAILURE);
            }

            usleep(5000); // 5 ms
        }
    }
}
