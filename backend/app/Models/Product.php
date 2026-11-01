<?php

declare(strict_types=1);

namespace App\Models;

use App\Enums\MovementType;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Product extends Model
{
    /** @use HasFactory<\Database\Factories\ProductFactory> */
    use HasFactory, SoftDeletes;

    /**
     * @var list<string>
     */
    protected $fillable = [
        'name',
        'sku',
        'category_id',
        'description',
        'purchase_price',
        'selling_price',
        'quantity',
        'low_stock_threshold',
        'image',
        'is_active',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'purchase_price' => 'decimal:2',
            'selling_price' => 'decimal:2',
            'quantity' => 'integer',
            'low_stock_threshold' => 'integer',
            'is_active' => 'boolean',
        ];
    }

    public function category(): BelongsTo
    {
        return $this->belongsTo(Category::class);
    }

    public function saleItems(): HasMany
    {
        return $this->hasMany(SaleItem::class);
    }

    public function stockMovements(): HasMany
    {
        return $this->hasMany(StockMovement::class);
    }

    public function isOutOfStock(): bool
    {
        return $this->quantity <= 0;
    }

    public function isLowStock(): bool
    {
        return $this->quantity > 0 && $this->quantity <= $this->low_stock_threshold;
    }

    public function hasSales(): bool
    {
        return $this->saleItems()->exists();
    }

    public function scopeSearch(Builder $query, ?string $term): Builder
    {
        if (blank($term)) {
            return $query;
        }

        return $query->where(function (Builder $q) use ($term): void {
            $q->where('name', 'like', "%{$term}%")
                ->orWhere('sku', 'like', "%{$term}%");
        });
    }

    public function scopeStockStatus(Builder $query, ?string $status): Builder
    {
        return match ($status) {
            'out' => $query->where('quantity', '<=', 0),
            'low' => $query->whereColumn('quantity', '<=', 'low_stock_threshold')
                ->where('quantity', '>', 0),
            'ok' => $query->whereColumn('quantity', '>', 'low_stock_threshold'),
            default => $query,
        };
    }

    public function scopeLowStock(Builder $query): Builder
    {
        return $query->where('is_active', true)
            ->whereColumn('quantity', '<=', 'low_stock_threshold');
    }

    /**
     * Mouvements de stock à valeur signée cohérente avec le stock courant.
     */
    public function recordMovement(MovementType $type, int $delta, ?string $reason = null, ?string $reference = null, ?int $userId = null): StockMovement
    {
        return $this->stockMovements()->create([
            'type' => $type->value,
            'quantity' => $delta,
            'reason' => $reason,
            'reference' => $reference,
            'user_id' => $userId,
        ]);
    }
}
