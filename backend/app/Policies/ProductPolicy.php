<?php

declare(strict_types=1);

namespace App\Policies;

use App\Models\Product;
use App\Models\User;

class ProductPolicy
{
    public function viewAny(User $user): bool
    {
        return true;
    }

    public function view(User $user, Product $product): bool
    {
        return true;
    }

    public function create(User $user): bool
    {
        return true;
    }

    public function update(User $user, Product $product): bool
    {
        return true;
    }

    /**
     * Seul un administrateur peut supprimer (soft delete) un produit,
     * et encore uniquement s'il n'est lié à aucune vente.
     */
    public function delete(User $user): bool
    {
        return $user->isAdmin();
    }
}
