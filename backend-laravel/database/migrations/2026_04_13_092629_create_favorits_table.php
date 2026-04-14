<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    public function up(): void
{
    Schema::dropIfExists('favorits');

    Schema::create('favorits', function (Blueprint $table) {
        $table->id();
        $table->unsignedInteger('pelanggan_id'); 
        $table->foreign('pelanggan_id')
              ->references('id_pelanggan') 
              ->on('pelanggan')
              ->onDelete('cascade');

        // Tetap hubungkan ke Produk
        $table->unsignedInteger('produk_id'); 
        $table->foreign('produk_id')
              ->references('id_produk')
              ->on('produk')
              ->onDelete('cascade');

        $table->timestamps();
    });
}

    public function down(): void
    {
        Schema::dropIfExists('favorits');
    }
};