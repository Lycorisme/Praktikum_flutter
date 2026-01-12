<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Smartphone extends Model
{
    protected $table = "smartphones";
    protected $fillable = [
        'nama_hp',
        'harga',
        'ram',
        'kamera',
        'baterai'
    ];
}
