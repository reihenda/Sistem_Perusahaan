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
            $table->date('tanggal_bergabung')->nullable()->after('gaji_pokok');
        });

        // Update tanggal bergabung existing dengan created_at
        DB::statement('UPDATE operator_gtm SET tanggal_bergabung = DATE(created_at) WHERE tanggal_bergabung IS NULL');
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('operator_gtm', function (Blueprint $table) {
            $table->dropColumn('tanggal_bergabung');
        });
    }
};