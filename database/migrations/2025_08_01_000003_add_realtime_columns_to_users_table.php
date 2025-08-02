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
        Schema::table('users', function (Blueprint $table) {
            // Tambahkan kolom untuk menyimpan JSON monthly balances yang sudah ada
            // tapi pastikan ada sebagai fallback
            if (!Schema::hasColumn('users', 'monthly_balances')) {
                $table->json('monthly_balances')->nullable()->after('pricing_history');
            }
            
            // Kolom untuk tracking terakhir kali saldo diupdate
            $table->timestamp('balance_last_updated_at')->nullable()->after('monthly_balances');
            
            // Flag untuk menandai apakah user menggunakan sistem real-time
            $table->boolean('use_realtime_calculation')->default(true)->after('balance_last_updated_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn([
                'balance_last_updated_at',
                'use_realtime_calculation'
            ]);
            // Jangan drop monthly_balances karena mungkin sudah ada data
        });
    }
};
