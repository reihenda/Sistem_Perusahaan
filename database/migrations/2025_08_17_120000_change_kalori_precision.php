<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('harga_gagas', function (Blueprint $table) {
            $table->decimal('kalori', 20, 12)->change();
        });
    }

    public function down(): void
    {
        Schema::table('harga_gagas', function (Blueprint $table) {
            $table->decimal('kalori', 10, 2)->change();
        });
    }
};
