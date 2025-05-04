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
        // Buat tabel ukuran untuk menyimpan daftar ukuran
        Schema::create('ukuran', function (Blueprint $table) {
            $table->id();
            $table->string('nama_ukuran', 50)->unique();
            $table->timestamps();
        });

        // Tambahkan kolom baru ke tabel nomor_polisi
        Schema::table('nomor_polisi', function (Blueprint $table) {
            $table->string('jenis', 100)->nullable()->after('keterangan');
            $table->foreignId('ukuran_id')->nullable()->after('jenis')
                  ->constrained('ukuran')->nullOnDelete();
            $table->string('no_gtm', 20)->nullable()->after('ukuran_id');
            $table->enum('status', ['milik', 'sewa', 'disewakan'])->nullable()->after('no_gtm');
            $table->enum('iso', ['ISO - 11439', 'ISO - 11119'])->nullable()->after('status');
            $table->enum('coi', ['sudah', 'belum'])->nullable()->after('iso');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Hapus kolom dari tabel nomor_polisi
        Schema::table('nomor_polisi', function (Blueprint $table) {
            $table->dropForeign(['ukuran_id']);
            $table->dropColumn(['jenis', 'ukuran_id', 'no_gtm', 'status', 'iso', 'coi']);
        });

        // Hapus tabel ukuran
        Schema::dropIfExists('ukuran');
    }
};