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
        Schema::table('proforma_invoices', function (Blueprint $table) {
            $table->decimal('volume_per_day', 10, 3)->after('total_volume'); // Volume per hari
            $table->decimal('price_per_sm3', 12, 2)->after('volume_per_day'); // Harga per sm3
            $table->integer('total_days')->after('price_per_sm3'); // Total hari dalam periode
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('proforma_invoices', function (Blueprint $table) {
            $table->dropColumn(['volume_per_day', 'price_per_sm3', 'total_days']);
        });
    }
};
