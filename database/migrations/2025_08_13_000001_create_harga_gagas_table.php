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
        Schema::create('harga_gagas', function (Blueprint $table) {
            $table->id();
            $table->decimal('harga_usd', 10, 2)->comment('Harga dalam USD');
            $table->decimal('rate_konversi_idr', 10, 2)->comment('Rate konversi USD ke IDR');
            $table->decimal('kalori', 10, 2)->comment('Nilai kalori untuk konversi ke MMBTU');
            $table->integer('periode_tahun')->comment('Tahun periode berlaku');
            $table->integer('periode_bulan')->comment('Bulan periode berlaku');
            $table->timestamps();
            
            // Index untuk pencarian berdasarkan periode
            $table->index(['periode_tahun', 'periode_bulan']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('harga_gagas');
    }
};
