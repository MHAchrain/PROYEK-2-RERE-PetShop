<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class PesananDetail extends Model
{
    protected $table = 'pesanan_detail';
    protected $primaryKey = 'id_detail'; // ganti kalau PK kamu beda
    protected $guarded = [];

    public function pesanan()
    {
        return $this->belongsTo(Pesanan::class, 'id_pesanan', 'id_pesanan');
    }

    public function produk()
    {
        return $this->belongsTo(Produk::class, 'id_produk', 'id_produk');
    }
}