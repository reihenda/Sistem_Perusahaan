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
        Schema::table('operator_gtm', function (Blueprint $table) {
            $table->integer('jam_kerja')->default(8)->after('gaji_pokok');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('operator_gtm', function (Blueprint $table) {
            $table->dropColumn('jam_kerja');
        });
    }
};
