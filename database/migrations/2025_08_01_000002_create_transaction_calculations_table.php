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
        Schema::create('transaction_calculations', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('customer_id');
            $table->unsignedBigInteger('data_pencatatan_id');
            $table->string('year_month', 7); // Format: 2024-01
            $table->date('transaction_date');
            
            // Data volume dan perhitungan
            $table->decimal('volume_flow_meter', 15, 4)->default(0);
            $table->decimal('koreksi_meter', 15, 8)->default(1);
            $table->decimal('volume_sm3', 15, 4)->default(0);
            $table->decimal('harga_per_m3', 15, 2)->default(0);
            $table->decimal('total_harga', 15, 2)->default(0);
            
            // Pricing yang digunakan saat perhitungan
            $table->json('pricing_used')->nullable();
            
            // Kondisi teknis saat perhitungan
            $table->decimal('tekanan_keluar', 10, 3)->nullable();
            $table->decimal('suhu', 10, 2)->nullable();
            
            // Metadata
            $table->timestamp('calculated_at');
            $table->boolean('is_recalculated')->default(false);
            $table->timestamps();

            // Indexes
            $table->foreign('customer_id')->references('id')->on('users')->onDelete('cascade');
            $table->foreign('data_pencatatan_id')->references('id')->on('data_pencatatan')->onDelete('cascade');
            $table->unique('data_pencatatan_id'); // Satu data pencatatan hanya punya satu calculation
            $table->index(['customer_id', 'year_month']);
            $table->index(['customer_id', 'transaction_date']);
            $table->index('year_month');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('transaction_calculations');
    }
};
