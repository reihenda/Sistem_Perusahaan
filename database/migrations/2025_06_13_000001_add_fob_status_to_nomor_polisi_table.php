<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Update ENUM status untuk menambahkan 'FOB'
        DB::statement("ALTER TABLE nomor_polisi MODIFY COLUMN status ENUM('milik', 'sewa', 'disewakan', 'FOB') NULL");
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Kembalikan ENUM status ke semula
        DB::statement("ALTER TABLE nomor_polisi MODIFY COLUMN status ENUM('milik', 'sewa', 'disewakan') NULL");
    }
};
