<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('products', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('sku')->unique();
            $table->foreignId('category_id')->constrained('categories')->restrictOnDelete();
            $table->text('description')->nullable();
            $table->decimal('purchase_price', 12, 2)->default(0);
            $table->decimal('selling_price', 12, 2);
            $table->unsignedInteger('quantity')->default(0);
            $table->unsignedInteger('low_stock_threshold')->default(5);
            $table->string('image')->nullable();
            $table->boolean('is_active')->default(true);
            $table->timestamps();
            $table->softDeletes();

            $table->index('name');
            $table->index('category_id');
            $table->index('is_active');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('products');
    }
};
