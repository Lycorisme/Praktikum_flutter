<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class vikor_results extends Model
{
    use HasFactory;

    protected $table = "vikor_results";

    protected $fillable = ['smartphone_id', 'nilai_s', 'nilai_r', 'nilai_q', 'ranking'];
}
