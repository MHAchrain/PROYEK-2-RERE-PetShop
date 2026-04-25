<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\ProdukController;
use App\Http\Controllers\Api\CartController;
use App\Http\Controllers\Api\CheckoutController;
use App\Http\Controllers\Api\PesananController;
use App\Http\Controllers\Api\KategoriController;
use App\Http\Controllers\Api\PembayaranController;
use App\Http\Controllers\Api\PengirimanController;
use App\Http\Controllers\Api\DashboardController;
use App\Http\Controllers\Api\PelangganController;
use App\Http\Controllers\Api\FavoriteController;

Route::get('/test', function () {
    return response()->json([
        'message' => 'API jalan',
    ]);
});

Route::get('/kategori', [KategoriController::class, 'index']);
Route::get('/kategori/{id}', [KategoriController::class, 'show']);
Route::get('/kategori/{id}/produk', [KategoriController::class, 'produkByKategori']);

Route::get('/produk', [ProdukController::class, 'index']);
Route::get('/produk/{id}', [ProdukController::class, 'show']);

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/login/google', [AuthController::class, 'loginWithGoogle']);
Route::post('/forgot-password/send-code', [AuthController::class, 'sendResetCode']);
Route::post('/forgot-password/verify-code', [AuthController::class, 'verifyResetCode']);
Route::post('/forgot-password/reset', [AuthController::class, 'resetPassword']);
Route::post('/midtrans/webhook', [PembayaranController::class, 'webhook']);



Route::middleware('auth:sanctum')->get('/me', [AuthController::class, 'me']);

Route::middleware('auth:sanctum')->group(function () {

    Route::post('/pelanggan/update', [PelangganController::class, 'updateProfile']);
    Route::get('/favorites', [FavoriteController::class, 'index']);
    Route::post('/favorites', [FavoriteController::class, 'store']);
    Route::delete('/favorites/{productId}', [FavoriteController::class, 'destroy']);
    Route::post('/cart/add', [CartController::class, 'add']);
    Route::get('/cart', [CartController::class, 'cart']);
    Route::patch('/cart/item/{id}', [CartController::class, 'update']);
    Route::delete('/cart/item/{id}', [CartController::class, 'remove']);
    Route::post('/checkout', [CheckoutController::class, 'checkout']);
    Route::get('/pesanan', [PesananController::class, 'index']);
    Route::get('/pesanan/{id}', [PesananController::class, 'show']);
    Route::post('/pembayaran', [PembayaranController::class, 'store']);
    Route::get('/pembayaran/{id}', [PembayaranController::class, 'show']);
    Route::get('/pesanan/{id}/pengiriman', [PengirimanController::class, 'show']);
    Route::post('/pesanan/{id}/selesai', [PesananController::class, 'selesai']);
    Route::post('/pesanan/{id}/batal', [PesananController::class, 'batal']);
    Route::get('/dashboard', [DashboardController::class, 'index']);
    Route::get('/pesanan/{id}/status', [PesananController::class, 'status']);
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
