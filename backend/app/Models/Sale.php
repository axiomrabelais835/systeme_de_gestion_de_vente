<?php

declare(strict_types=1);

namespace App\Models;

use App\Enums\PaymentMethod;
use App\Enums\PaymentStatus;
use App\Enums\SaleStatus;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Sale extends Model
{
    /** @use HasFactory<\Database\Factories\SaleFactory> */
    use HasFactory;

    /**
     * @var list<string>
     */
    protected $fillable = [
        'reference',
        'customer_id',
        'user_id',
        'subtotal',
        'discount',
        'tax',
        'total',
        'payment_method',
        'payment_status',
        'status',
        'sold_at',
        'cancelled_at',
        'cancel_reason',
    ];

    /**
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'subtotal' => 'decimal:2',
            'discount' => 'decimal:2',
            'tax' => 'decimal:2',
            'total' => 'decimal:2',
            'payment_method' => PaymentMethod::class,
            'payment_status' => PaymentStatus::class,
            'status' => SaleStatus::class,
            'sold_at' => 'datetime',
            'cancelled_at' => 'datetime',
        ];
    }

    public function customer(): BelongsTo
    {
        return $this->belongsTo(Customer::class);
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function items(): HasMany
    {
        return $this->hasMany(SaleItem::class);
    }

    public function isCancelled(): bool
    {
        return $this->status === SaleStatus::Annulee;
    }

    public function scopeValidated(Builder $query): Builder
    {
        return $query->where('status', SaleStatus::Validee->value);
    }

    public function scopeBetweenDates(Builder $query, ?string $from, ?string $to): Builder
    {
        if (filled($from)) {
            $query->where('sold_at', '>=', $from);
        }

        if (filled($to)) {
            $query->where('sold_at', '<=', $to.' 23:59:59');
        }

        return $query;
    }

    public function scopeSearchReference(Builder $query, ?string $term): Builder
    {
        if (blank($term)) {
            return $query;
        }

        return $query->where('reference', 'like', "%{$term}%");
    }
}
