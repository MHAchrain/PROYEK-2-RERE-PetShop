<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Pelanggan extends Model
{
    protected $table = 'pelanggan';
    protected $primaryKey = 'id_pelanggan'; // karena PK kamu pakai id_pelanggan
    public $incrementing = true;
    protected $keyType = 'int';

    protected $guarded = [];
}