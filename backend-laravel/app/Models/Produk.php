<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Produk extends Model
{
    use HasFactory;

    protected $table = 'produk';
    protected $primaryKey = 'id_produk';

    protected $fillable = [
        'id_kategori',
        'nama_produk',
        'harga',
        'stok',
        'deskripsi',
        'foto',
    ];

    // Otomatis sertakan field foto_base64 di response JSON API
    protected $appends = ['foto_base64'];

    public function getFotoBase64Attribute()
    {
        if (!$this->foto) {
            return null;
        }

        // Cek path file di storage/app/public/
        $path = storage_path('app/public/' . $this->foto);

        if (file_exists($path)) {
            $mime = mime_content_type($path);
            $data = file_get_contents($path);
            return 'data:' . $mime . ';base64,' . base64_encode($data);
        }

        return null;
    }

    public function kategori()
    {
        return $this->belongsTo(Kategori::class, 'id_kategori', 'id_kategori');
    }

    public function pesananDetails()
    {
        return $this->hasMany(PesananDetail::class, 'id_produk', 'id_produk');
    }
}