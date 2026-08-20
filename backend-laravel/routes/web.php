<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return response()->json([
        'status' => 'success',
        'message' => 'Backend Rere Petshop API is running on Vercel',
        'timestamp' => now()->toDateTimeString()
    ]);
});