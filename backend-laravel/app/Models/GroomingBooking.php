<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class GroomingBooking extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'grooming_bookings';

    protected $fillable = [
        'id_pelanggan',
        'grooming_service_id',
        'pet_name',
        'pet_type',
        'pet_breed',
        'pet_size',
        'pet_note',
        'date',
        'time',
        'price',
        'status',
    ];

    protected $casts = [
        'date' => 'date',
        'price' => 'decimal:2',
    ];

    // Relasi ke Pelanggan
    public function pelanggan()
    {
        return $this->belongsTo(Pelanggan::class, 'id_pelanggan', 'id_pelanggan');
    }

    // Relasi ke Layanan Grooming
    public function service()
    {
        return $this->belongsTo(GroomingService::class, 'grooming_service_id');
    }

    // Accessor format kode booking untuk tampilan frontend/history (contoh: GR-0001)
    public function getKodeBookingAttribute(): string
    {
        return 'GR-' . str_pad((string) $this->id, 4, '0', STR_PAD_LEFT);
    }

    // Scopes
    public function scopeStatus($query, $status)
    {
        if ($status === 'dibatalkan') {
            return $query->whereIn('status', ['dibatalkan', 'gagal']);
        }
        return $query->where('status', $status);
    }
}
