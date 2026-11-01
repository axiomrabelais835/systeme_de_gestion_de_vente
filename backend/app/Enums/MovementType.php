<?php

declare(strict_types=1);

namespace App\Enums;

enum MovementType: string
{
    case Entree = 'entree';
    case Sortie = 'sortie';
    case Ajustement = 'ajustement';
    case Annulation = 'annulation';

    public function label(): string
    {
        return match ($this) {
            self::Entree => 'Entrée',
            self::Sortie => 'Sortie',
            self::Ajustement => 'Ajustement',
            self::Annulation => 'Annulation',
        };
    }

    /**
     * Les types qui augmentent toujours le stock.
     *
     * @return list<string>
     */
    public static function increasingValues(): array
    {
        return [self::Entree->value, self::Annulation->value];
    }

    /**
     * @return array<string, string>
     */
    public static function options(): array
    {
        return [
            self::Entree->value => self::Entree->label(),
            self::Sortie->value => self::Sortie->label(),
            self::Ajustement->value => self::Ajustement->label(),
            self::Annulation->value => self::Annulation->label(),
        ];
    }
}
