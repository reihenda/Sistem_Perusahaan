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
            // Mengubah kolom kalori dari DECIMAL(10,2) ke DECIMAL(20,12)
            // untuk mendukung presisi hingga 12 angka di belakang koma
            $table->decimal('kalori', 20, 12)->change()->comment('Nilai kalori untuk konversi ke MMBTU (presisi 12 desimal)');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('harga_gagas', function (Blueprint $table) {
            // Kembalikan ke format asli
            $table->decimal('kalori', 10, 2)->change()->comment('Nilai kalori untuk konversi ke MMBTU');
        });
    }
};
