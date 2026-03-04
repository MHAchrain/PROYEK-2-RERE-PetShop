<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Kategori extends Model
{
    protected $table = 'kategori';   // karena tabel kamu namanya "kategori"
    protected $guarded = [];         // biar gampang dulu
}