<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Pesanan extends Model
{
    protected $table = 'pesanan';
    protected $primaryKey = 'id_pesanan'; // kalau PK kamu ini
    protected $guarded = [];

    public function details(): HasMany
    {
        return $this->hasMany(PesananDetail::class, 'id_pesanan', 'id_pesanan');
    }

   public function pelanggan()
{
    return $this->belongsTo(\App\Models\Pelanggan::class, 'id_pelanggan', 'id_pelanggan');
}
}