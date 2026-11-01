<?php

declare(strict_types=1);

namespace App\Models;

use App\Enums\MovementType;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class StockMovement extends Model
{
    /** @use HasFactory<\Database\Factories\StockMovementFactory> */
    use HasFactory;

    public const UPDATED_AT = null;

    /**
     * @var list<string>
     */
    protected $fillable = [
        'product_id',
        'type',
        'quantity',
        'reason',
        'reference',
        'user_id',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'type' => MovementType::class,
            'quantity' => 'integer',
            'created_at' => 'datetime',
        ];
    }

    public function product(): BelongsTo
    {
        return $this->belongsTo(Product::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function scopeFilter(Builder $query, ?int $productId, ?string $type, ?string $from, ?string $to): Builder
    {
        if (filled($productId)) {
            $query->where('product_id', $productId);
        }

        if (filled($type)) {
            $query->where('type', $type);
        }

        if (filled($from)) {
            $query->where('created_at', '>=', $from);
        }

        if (filled($to)) {
            $query->where('created_at', '<=', $to.' 23:59:59');
        }

        return $query;
    }
}
