<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class wp_results extends Model
{
    use HasFactory;

    protected $table = "wp_results";

    protected $fillable = ['smartphone_id', 'nilai_s', 'nilai_v', 'ranking'];
}
