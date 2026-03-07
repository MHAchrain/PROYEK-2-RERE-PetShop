<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProdukController;

Route::get('/test', function () {
    return response()->json([
        'message' => 'API jalan',
    ]);
});

Route::get('/produk', [ProdukController::class, 'index']);
Route::get('/produk/{id}', [ProdukController::class, 'show']);

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->get('/me', function (Request $request) {
    return response()->json([
        'success' => true,
        'data' => $request->user(),
    ]);
});
Route::get('/cek-token', function (Request $request) {
    $token = $request->bearerToken();

    $accessToken = \Laravel\Sanctum\PersonalAccessToken::findToken($token);

    return response()->json([
        'token_dikirim' => $token,
        'token_ketemu' => $accessToken ? true : false,
        'user' => $accessToken?->tokenable,
    ]);
});