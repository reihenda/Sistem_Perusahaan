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
        Schema::table('harga_gagas', function (Blueprint $table) {
            // Tambahkan unique constraint untuk kombinasi periode_tahun dan periode_bulan
            $table->unique(['periode_tahun', 'periode_bulan'], 'unique_periode_harga_gagas');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('harga_gagas', function (Blueprint $table) {
            $table->dropUnique('unique_periode_harga_gagas');
        });
    }
};
