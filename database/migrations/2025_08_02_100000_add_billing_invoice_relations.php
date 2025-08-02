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
        // Tambah kolom relasi di tabel billings
        Schema::table('billings', function (Blueprint $table) {
            $table->bigInteger('invoice_id')->unsigned()->nullable()->after('id');
            $table->foreign('invoice_id')->references('id')->on('invoices')->onDelete('cascade');
        });

        // Tambah kolom relasi di tabel invoices
        Schema::table('invoices', function (Blueprint $table) {
            $table->bigInteger('billing_id')->unsigned()->nullable()->after('id');
            $table->foreign('billing_id')->references('id')->on('billings')->onDelete('cascade');
        });

        // Hapus kolom status dari tabel billings (status hanya di invoice)
        Schema::table('billings', function (Blueprint $table) {
            $table->dropColumn('status');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Tambah kembali kolom status di billings
        Schema::table('billings', function (Blueprint $table) {
            $table->enum('status', ['paid', 'unpaid', 'partial', 'cancelled'])->default('unpaid')->after('period_year');
        });

        // Hapus foreign key dan kolom relasi dari invoices
        Schema::table('invoices', function (Blueprint $table) {
            $table->dropForeign(['billing_id']);
            $table->dropColumn('billing_id');
        });

        // Hapus foreign key dan kolom relasi dari billings
        Schema::table('billings', function (Blueprint $table) {
            $table->dropForeign(['invoice_id']);
            $table->dropColumn('invoice_id');
        });
    }
};
