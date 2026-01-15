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
        Schema::create('vikor_results', function (Blueprint $table) {
            $table->id();
            $table->foreignId('smartphone_id')->constrained('smartphones')->onDelete('cascade');
            $table->double('nilai_s');
            $table->double('nilai_r');
            $table->double('nilai_q');
            $table->integer('ranking');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('vikor_results');
    }
};
