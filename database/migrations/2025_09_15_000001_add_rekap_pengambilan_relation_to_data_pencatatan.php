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
        Schema::table('data_pencatatan', function (Blueprint $table) {
            // Tambahkan kolom untuk relasi ke rekap_pengambilan
            $table->unsignedBigInteger('rekap_pengambilan_id')->nullable()->after('customer_id');
            
            // Tambahkan foreign key constraint
            $table->foreign('rekap_pengambilan_id')
                  ->references('id')
                  ->on('rekap_pengambilan')
                  ->onDelete('cascade');
                  
            // Tambahkan index untuk performa
            $table->index(['customer_id', 'rekap_pengambilan_id']);
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('data_pencatatan', function (Blueprint $table) {
            // Drop foreign key dan kolom
            $table->dropForeign(['rekap_pengambilan_id']);
            $table->dropIndex(['customer_id', 'rekap_pengambilan_id']);
            $table->dropColumn('rekap_pengambilan_id');
        });
    }
};
