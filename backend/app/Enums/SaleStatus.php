<?php

declare(strict_types=1);

namespace App\Enums;

enum SaleStatus: string
{
    case Validee = 'validee';
    case Annulee = 'annulee';

    public function label(): string
    {
        return match ($this) {
            self::Validee => 'Validée',
            self::Annulee => 'Annulée',
        };
    }

    /**
     * @return array<string, string>
     */
    public static function options(): array
    {
        return [
            self::Validee->value => self::Validee->label(),
            self::Annulee->value => self::Annulee->label(),
        ];
    }
}
