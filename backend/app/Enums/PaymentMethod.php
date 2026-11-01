<?php

declare(strict_types=1);

namespace App\Enums;

enum PaymentMethod: string
{
    case Especes = 'especes';
    case MobileMoney = 'mobile_money';
    case Carte = 'carte';
    case Virement = 'virement';

    public function label(): string
    {
        return match ($this) {
            self::Especes => 'Espèces',
            self::MobileMoney => 'Mobile Money',
            self::Carte => 'Carte bancaire',
            self::Virement => 'Virement',
        };
    }

    /**
     * @return array<string, string>
     */
    public static function options(): array
    {
        return [
            self::Especes->value => self::Especes->label(),
            self::MobileMoney->value => self::MobileMoney->label(),
            self::Carte->value => self::Carte->label(),
            self::Virement->value => self::Virement->label(),
        ];
    }
}
