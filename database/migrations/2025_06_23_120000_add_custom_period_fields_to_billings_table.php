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
        Schema::table('billings', function (Blueprint $table) {
            $table->enum('period_type', ['monthly', 'custom'])->default('monthly')->after('period_year');
            $table->date('custom_start_date')->nullable()->after('period_type');
            $table->date('custom_end_date')->nullable()->after('custom_start_date');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('billings', function (Blueprint $table) {
            $table->dropColumn(['period_type', 'custom_start_date', 'custom_end_date']);
        });
    }
};
