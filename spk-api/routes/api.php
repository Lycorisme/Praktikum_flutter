<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\SmartphoneController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// Route SPK - VIKOR dan WP
Route::get('/spk/vikor-proses', [SmartphoneController::class, 'hitungDanSimpanVikor']);
Route::post('/spk/wp-proses', [SmartphoneController::class, 'hitungDanSimpanWP']);

// Route CRUD Smartphones
Route::apiResource('smartphones', SmartphoneController::class);
