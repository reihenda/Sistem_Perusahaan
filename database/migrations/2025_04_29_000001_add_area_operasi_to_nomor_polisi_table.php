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
        Schema::table('nomor_polisi', function (Blueprint $table) {
            $table->string('area_operasi', 100)->nullable()->after('ukuran_id');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('nomor_polisi', function (Blueprint $table) {
            $table->dropColumn('area_operasi');
        });
    }
};