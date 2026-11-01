<?php

declare(strict_types=1);

namespace App\Exceptions;

use Exception;

/**
 * Exception métier : renvoyée au client sous forme de 422 (ou autre statut)
 * avec un message explicite en français.
 */
class BusinessException extends Exception
{
    /**
     * @param  array<string, list<string>>  $errors
     */
    public function __construct(
        string $message,
        protected int $status = 422,
        protected array $errors = [],
    ) {
        parent::__construct($message);
    }

    public function status(): int
    {
        return $this->status;
    }

    /**
     * @return array<string, list<string>>
     */
    public function errors(): array
    {
        return $this->errors;
    }
}
