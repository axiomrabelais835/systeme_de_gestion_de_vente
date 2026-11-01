<?php

declare(strict_types=1);

namespace App\Policies;

use App\Models\User;

/**
 * Les paramètres globaux ne sont modifiables que par un administrateur.
 */
class SettingPolicy
{
    public function viewAny(User $user): bool
    {
        return true;
    }

    public function update(User $user): bool
    {
        return $user->isAdmin();
    }
}
