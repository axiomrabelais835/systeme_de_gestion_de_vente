<?php

declare(strict_types=1);

namespace App\Enums;

enum UserRole: string
{
    case Admin = 'admin';
    case Vendeur = 'vendeur';

    public function label(): string
    {
        return match ($this) {
            self::Admin => 'Administrateur',
            self::Vendeur => 'Vendeur',
        };
    }

    /**
     * @return array<string, string>
     */
    public static function options(): array
    {
        return [
            self::Admin->value => self::Admin->label(),
            self::Vendeur->value => self::Vendeur->label(),
        ];
    }
}
