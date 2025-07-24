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
        // Buat tabel alamat_pengambilan untuk menyimpan daftar alamat
        Schema::create('alamat_pengambilan', function (Blueprint $table) {
            $table->id();
            $table->string('nama_alamat', 500)->unique();
            $table->timestamps();
        });

        // Tambahkan kolom alamat_pengambilan_id ke tabel rekap_pengambilan
        Schema::table('rekap_pengambilan', function (Blueprint $table) {
            $table->foreignId('alamat_pengambilan_id')->nullable()->after('volume')
                  ->constrained('alamat_pengambilan')->nullOnDelete();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Hapus foreign key dan kolom dari tabel rekap_pengambilan
        Schema::table('rekap_pengambilan', function (Blueprint $table) {
            $table->dropForeign(['alamat_pengambilan_id']);
            $table->dropColumn('alamat_pengambilan_id');
        });

        // Hapus tabel alamat_pengambilan
        Schema::dropIfExists('alamat_pengambilan');
    }
};
