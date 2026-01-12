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
        Schema::create('smartphones', function (Blueprint $table) {
            $table->id();
            $table->string('nama_hp');
            $table->float('harga');
            $table->float('ram');
            $table->float('kamera');
            $table->float('baterai');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('smartphones');
    }
};
