<?php

declare(strict_types=1);

namespace App\Enums;

enum PaymentStatus: string
{
    case Payee = 'payee';
    case EnAttente = 'en_attente';

    public function label(): string
    {
        return match ($this) {
            self::Payee => 'Payée',
            self::EnAttente => 'En attente',
        };
    }

    /**
     * @return array<string, string>
     */
    public static function options(): array
    {
        return [
            self::Payee->value => self::Payee->label(),
            self::EnAttente->value => self::EnAttente->label(),
        ];
    }
}
