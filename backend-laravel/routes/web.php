<?php

use App\Http\Controllers\Admin\AuthController as AdminAuthController;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\GroomingController;
use App\Http\Controllers\Admin\KategoriController;
use App\Http\Controllers\Admin\PelangganController;
use App\Http\Controllers\Admin\PengirimanController;
use App\Http\Controllers\Admin\PesananController;
use App\Http\Controllers\Admin\PesananDetailController;
use App\Http\Controllers\Admin\ProdukController;
use App\Http\Middleware\EnsureAdminUser;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Response;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
*/

// Landing Page / Status Portal
Route::get('/', function () {
    $env = config('app.env', 'production');
    $time = date('Y-m-d H:i:s');
    $laravelVer = app()->version();
    $phpVer = phpversion();

    return response(<<<HTML
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ReRe Petshop API Service</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-slate-950 text-slate-100 min-h-screen flex items-center justify-center p-6 font-sans">
    <div class="max-w-xl w-full bg-slate-900 border border-slate-800 rounded-3xl p-8 shadow-2xl relative overflow-hidden backdrop-blur-xl">
        <div class="flex items-center justify-between pb-6 border-b border-slate-800">
            <div class="flex items-center space-x-3">
                <div class="w-10 h-10 rounded-2xl bg-gradient-to-tr from-amber-500 to-red-500 flex items-center justify-center text-white font-bold text-xl shadow-lg">
                    🐾
                </div>
                <div>
                    <h1 class="text-lg font-bold text-white tracking-wide">ReRe Petshop API</h1>
                    <p class="text-xs text-slate-400">Core RESTful Backend Engine</p>
                </div>
            </div>
            <div class="flex items-center space-x-2 bg-emerald-500/10 border border-emerald-500/30 px-3 py-1.5 rounded-full">
                <span class="w-2.5 h-2.5 rounded-full bg-emerald-400 animate-pulse"></span>
                <span class="text-xs font-semibold text-emerald-400">SYSTEM OPERATIONAL</span>
            </div>
        </div>

        <div class="mt-6 p-3.5 rounded-2xl bg-emerald-950/40 border border-emerald-500/30 flex items-center justify-between">
            <div class="flex items-center space-x-2.5">
                <div class="w-2 h-2 rounded-full bg-emerald-400 animate-ping"></div>
                <span class="text-xs font-medium text-emerald-300">API Status: Terhubung & Aktif</span>
            </div>
            <span class="text-[11px] font-mono bg-emerald-500/20 text-emerald-300 px-2 py-0.5 rounded-md border border-emerald-500/30">Frontend ⚡ TiDB</span>
        </div>

        <div class="grid grid-cols-2 gap-4 my-6">
            <div class="bg-slate-950/60 border border-slate-800/80 p-4 rounded-2xl">
                <p class="text-xs text-slate-400 mb-1">Environment</p>
                <p class="text-sm font-semibold text-slate-200 uppercase">{$env}</p>
            </div>
            <div class="bg-slate-950/60 border border-slate-800/80 p-4 rounded-2xl">
                <p class="text-xs text-slate-400 mb-1">Server Time</p>
                <p class="text-sm font-semibold text-slate-200 font-mono">{$time}</p>
            </div>
        </div>

        <div class="space-y-2.5">
            <a href="https://rerepetshop.biz.id/" target="_blank" class="flex items-center justify-between p-3.5 rounded-2xl bg-slate-800/60 hover:bg-slate-800 border border-slate-700/50 transition group">
                <div class="flex items-center space-x-3">
                    <i class="fa-solid fa-globe text-cyan-400 group-hover:scale-110 transition"></i>
                    <span class="text-sm font-medium text-slate-200">Kunjungi Website Utama (Frontend)</span>
                </div>
                <i class="fa-solid fa-up-right-from-square text-xs text-slate-500 group-hover:text-slate-200 transition"></i>
            </a>

            <a href="/admin" target="_blank" class="flex items-center justify-between p-3.5 rounded-2xl bg-slate-800/60 hover:bg-slate-800 border border-slate-700/50 transition group">
                <div class="flex items-center space-x-3">
                    <i class="fa-solid fa-gauge-high text-brand-500 group-hover:scale-110 transition"></i>
                    <span class="text-sm font-medium text-slate-200">Admin Control Panel</span>
                </div>
                <i class="fa-solid fa-up-right-from-square text-xs text-slate-500 group-hover:text-slate-200 transition"></i>
            </a>
        </div>

        <div class="mt-6 pt-4 border-t border-slate-800/60 text-center">
            <p class="text-xs text-slate-500">Laravel v{$laravelVer} (PHP v{$phpVer})</p>
        </div>
    </div>
</body>
</html>
HTML, 200)->header('Content-Type', 'text/html');
});

/*
|--------------------------------------------------------------------------
| Custom Admin Panel Routes (Blade Engine)
|--------------------------------------------------------------------------
*/
Route::prefix('admin')->name('admin.')->group(function () {
    // Auth Routes
    Route::get('/login', [AdminAuthController::class, 'showLoginForm'])->name('login');
    Route::post('/login', [AdminAuthController::class, 'login'])->name('login.submit');
    Route::post('/logout', [AdminAuthController::class, 'logout'])->name('logout');

    // Protected Admin Routes
    Route::middleware([EnsureAdminUser::class])->group(function () {
        Route::get('/', function () {
            return redirect()->route('admin.dashboard');
        });
        Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

        // Modul Produk & Excel
        Route::get('/produk/export', [ProdukController::class, 'export'])->name('produk.export');
        Route::post('/produk/import', [ProdukController::class, 'import'])->name('produk.import');
        Route::resource('/produk', ProdukController::class)->names('produk')->except(['show']);

        // Modul Kategori
        Route::get('/kategori/export', [KategoriController::class, 'export'])->name('kategori.export');
        Route::resource('/kategori', KategoriController::class)->names('kategori')->only(['index', 'store', 'update', 'destroy']);

        // Modul 1: Pesanan Toko
        Route::get('/pesanan/export', [PesananController::class, 'export'])->name('pesanan.export');
        Route::patch('/pesanan/{pesanan}/status', [PesananController::class, 'updateStatus'])->name('pesanan.status');
        Route::patch('/pesanan/{pesanan}/pengiriman', [PesananController::class, 'updatePengiriman'])->name('pesanan.pengiriman');
        Route::resource('/pesanan', PesananController::class)->names('pesanan')->only(['index', 'show']);

        // Modul 2: Detail Pesanan Item
        Route::get('/pesanan-detail', [PesananDetailController::class, 'index'])->name('pesanan-detail.index');
        Route::get('/pesanan-detail/export', [PesananDetailController::class, 'export'])->name('pesanan-detail.export');

        // Modul 3: Pengiriman Ekspedisi & Resi
        Route::get('/pengiriman', [PengirimanController::class, 'index'])->name('pengiriman.index');
        Route::get('/pengiriman/export', [PengirimanController::class, 'export'])->name('pengiriman.export');
        Route::patch('/pengiriman/{pengiriman}', [PengirimanController::class, 'update'])->name('pengiriman.update');

        // Modul 4: Grooming Terpisah (Layanan & Pesanan/Booking)
        Route::get('/grooming/layanan', [GroomingController::class, 'services'])->name('grooming.services');
        Route::get('/grooming/pesanan', [GroomingController::class, 'bookings'])->name('grooming.bookings');
        Route::get('/grooming/export', [GroomingController::class, 'exportBookings'])->name('grooming.export');
        Route::post('/grooming/service', [GroomingController::class, 'storeService'])->name('grooming.service.store');
        Route::put('/grooming/service/{service}', [GroomingController::class, 'updateService'])->name('grooming.service.update');
        Route::patch('/grooming/booking/{booking}/status', [GroomingController::class, 'updateBookingStatus'])->name('grooming.booking.status');

        // Modul Pelanggan
        Route::get('/pelanggan/export', [PelangganController::class, 'export'])->name('pelanggan.export');
        Route::resource('/pelanggan', PelangganController::class)->names('pelanggan')->only(['index', 'show']);
    });
});

// Route Akses Gambar dengan Handshake CORS & Bypass Ngrok
Route::match(['GET', 'OPTIONS'], '/storage/{folder}/{filename}', function ($folder, $filename) {
    if (request()->isMethod('OPTIONS')) {
        return response('', 204, [
            'Access-Control-Allow-Origin' => '*',
            'Access-Control-Allow-Methods' => 'GET, OPTIONS',
            'Access-Control-Allow-Headers' => 'ngrok-skip-browser-warning, Content-Type, Authorization, X-Requested-With',
            'Access-Control-Max-Age' => '86400',
        ]);
    }

    $path = storage_path('app/public/' . $folder . '/' . $filename);

    if (!File::exists($path)) {
        abort(404);
    }

    $file = File::get($path);
    $type = File::mimeType($path);

    return Response::make($file, 200, [
        'Content-Type' => $type,
        'Access-Control-Allow-Origin' => '*',
        'Access-Control-Allow-Methods' => 'GET, OPTIONS',
        'Access-Control-Allow-Headers' => 'ngrok-skip-browser-warning, Content-Type, Authorization, X-Requested-With',
        'Cache-Control' => 'public, max-age=86400',
    ]);
})->where('filename', '.*');
