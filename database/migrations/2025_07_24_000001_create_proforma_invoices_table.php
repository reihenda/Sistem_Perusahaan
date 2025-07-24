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
        Schema::create('proforma_invoices', function (Blueprint $table) {
            $table->id();
            $table->foreignId('customer_id')->constrained('users')->onDelete('cascade');
            $table->string('proforma_number');
            $table->date('proforma_date');
            $table->date('due_date');
            $table->decimal('total_amount', 12, 2);
            $table->decimal('total_volume', 10, 3)->default(0);
            $table->enum('status', ['draft', 'sent', 'expired', 'converted'])->default('draft');
            $table->text('description')->nullable();
            $table->string('no_kontrak');
            $table->string('id_pelanggan');
            $table->date('period_start_date');
            $table->date('period_end_date');
            $table->date('validity_date')->nullable(); // Tanggal berlaku sampai
            $table->timestamps();
            
            // Index untuk pencarian
            $table->index(['customer_id', 'proforma_date']);
            $table->index('status');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('proforma_invoices');
    }
};
