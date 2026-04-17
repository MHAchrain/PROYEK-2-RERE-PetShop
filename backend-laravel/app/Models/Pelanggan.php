<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Laravel\Sanctum\HasApiTokens;

class Pelanggan extends Authenticatable
{
    use HasApiTokens;

    protected $table = 'pelanggan';
    protected $primaryKey = 'id_pelanggan';
    public $incrementing = true;
    protected $keyType = 'int';

    protected $fillable = [
        'nama', 'email', 'no_hp', 'password', 'alamat'
    ];

    protected $hidden = ['password'];

    // Accessor kode pelanggan
    public function getKodePelangganAttribute(): string
    {
        return 'PLG-' . str_pad((string) $this->id_pelanggan, 4, '0', STR_PAD_LEFT);
    }

    public function produkFavorit()
{
    return $this->belongsToMany(
        Produk::class,
        'favorites',
        'pelanggan_id',
        'produk_id',
        'id_pelanggan',
        'id_produk'
    );
}
}