<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;

class GroomingService extends Model
{
    use HasFactory, SoftDeletes;

    protected $table = 'grooming_services';

    protected $fillable = [
        'name',
        'description',
        'price',
        'duration_minutes',
        'is_active',
    ];

    protected $casts = [
        'price' => 'decimal:2',
        'duration_minutes' => 'integer',
        'is_active' => 'boolean',
    ];

    public function bookings()
    {
        return $this->hasMany(GroomingBooking::class, 'grooming_service_id');
    }

    public function scopeActive($query)
    {
        return $query->where('is_active', true);
    }
}
