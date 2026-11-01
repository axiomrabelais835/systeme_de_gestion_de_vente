<?php

declare(strict_types=1);

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Facades\Cache;

class Setting extends Model
{
    /**
     * @var list<string>
     */
    protected $fillable = [
        'key',
        'value',
    ];

    public const CACHE_KEY = 'settings.all';

    public static function getValue(string $key, ?string $default = null): ?string
    {
        return static::allSettings()[$key] ?? $default;
    }

    /**
     * @return array<string, string|null>
     */
    public static function allSettings(): array
    {
        return Cache::rememberForever(self::CACHE_KEY, function (): array {
            return static::query()->pluck('value', 'key')->all();
        });
    }

    public static function setValue(string $key, ?string $value): void
    {
        static::updateOrCreate(['key' => $key], ['value' => $value]);
        Cache::forget(self::CACHE_KEY);
    }

    protected static function booted(): void
    {
        static::saved(fn () => Cache::forget(self::CACHE_KEY));
        static::deleted(fn () => Cache::forget(self::CACHE_KEY));
    }
}
