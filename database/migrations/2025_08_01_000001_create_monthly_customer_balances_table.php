<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('monthly_customer_balances', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('customer_id');
            $table->string('year_month', 7); // Format: 2024-01
            $table->decimal('opening_balance', 15, 2)->default(0);
            $table->decimal('total_deposits', 15, 2)->default(0);
            $table->decimal('total_purchases', 15, 2)->default(0);
            $table->decimal('closing_balance', 15, 2)->default(0);
            $table->decimal('total_volume_sm3', 15, 4)->default(0);
            $table->json('calculation_details')->nullable(); // Detail perhitungan untuk audit
            $table->timestamp('last_calculated_at')->nullable();
            $table->timestamps();

            // Indexes
            $table->foreign('customer_id')->references('id')->on('users')->onDelete('cascade');
            $table->unique(['customer_id', 'year_month']);
            $table->index(['customer_id', 'year_month']);
            $table->index('year_month');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('monthly_customer_balances');
    }
};
