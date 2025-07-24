<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        // Tambahkan index untuk performa query FOB yang lebih baik
        Schema::table('data_pencatatan', function (Blueprint $table) {
            // Index untuk customer_id dan harga_final (untuk rekalkulasi cepat)
            $table->index(['customer_id', 'harga_final'], 'idx_customer_harga_final');

            // Index untuk created_at (untuk filter tanggal)
            $table->index('created_at', 'idx_created_at');
        });

        Schema::table('users', function (Blueprint $table) {
            // Index untuk role FOB
            $table->index('role', 'idx_role');
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('data_pencatatan', function (Blueprint $table) {
            $table->dropIndex('idx_customer_harga_final');
            $table->dropIndex('idx_created_at');
        });

        Schema::table('users', function (Blueprint $table) {
            $table->dropIndex('idx_role');
        });
    }
};
