<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('sales', function (Blueprint $table) {
            $table->id();
            $table->string('reference')->unique();
            $table->foreignId('customer_id')->nullable()->constrained('customers')->nullOnDelete();
            $table->foreignId('user_id')->constrained('users')->restrictOnDelete();
            $table->decimal('subtotal', 14, 2);
            $table->decimal('discount', 14, 2)->default(0);
            $table->decimal('tax', 14, 2)->default(0);
            $table->decimal('total', 14, 2);
            $table->enum('payment_method', ['especes', 'mobile_money', 'carte', 'virement']);
            $table->enum('payment_status', ['payee', 'en_attente'])->default('payee');
            $table->enum('status', ['validee', 'annulee'])->default('validee');
            $table->dateTime('sold_at')->index();
            $table->dateTime('cancelled_at')->nullable();
            $table->string('cancel_reason')->nullable();
            $table->timestamps();

            $table->index('status');
            $table->index('customer_id');
            $table->index('user_id');
            $table->index('payment_method');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('sales');
    }
};
