<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('grooming_bookings', function (Blueprint $table) {
            $table->id();
            
            // Relasi ke Pelanggan (PK pelanggan di sistem: id_pelanggan)
            $table->unsignedInteger('id_pelanggan')->index();
            $table->foreign('id_pelanggan')->references('id_pelanggan')->on('pelanggan')->cascadeOnDelete();

            // Relasi ke Layanan Grooming
            $table->foreignId('grooming_service_id')->constrained('grooming_services')->cascadeOnDelete();

            // Sesuai persis dengan Form FE
            $table->string('pet_name', 100);
            $table->string('pet_type', 100);
            $table->string('pet_breed', 100);
            $table->string('pet_size', 50);
            $table->text('pet_note')->nullable();

            // Jadwal
            $table->date('date');
            $table->string('time', 20);

            // Snapshot Harga saat transaksi & Status
            $table->decimal('price', 12, 2)->default(0);
            $table->enum('status', [
                'menunggu_pembayaran',
                'terjadwal',
                'dikonfirmasi',
                'selesai',
                'dibatalkan',
                'gagal'
            ])->default('menunggu_pembayaran');

            $table->timestamps();
            $table->softDeletes();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('grooming_bookings');
    }
};
