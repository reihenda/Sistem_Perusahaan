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
            // Ubah kolom kalori dari DECIMAL(20,12) ke DECIMAL(24,16)
            // untuk mendukung presisi hingga 16 angka di belakang koma
            $table->decimal('kalori', 24, 16)->change()->comment('Nilai kalori untuk konversi ke MMBTU (presisi 16 desimal)');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('harga_gagas', function (Blueprint $table) {
            // Kembalikan ke DECIMAL(20,12) jika rollback
            $table->decimal('kalori', 20, 12)->change()->comment('Nilai kalori untuk konversi ke MMBTU (presisi 12 desimal)');
        });
    }
};
