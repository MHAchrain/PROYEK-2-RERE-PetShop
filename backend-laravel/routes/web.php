<?php

use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\File;
use Illuminate\Support\Facades\Response;

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
        <!-- Background Glow -->
        <div class="absolute -top-24 -right-24 w-48 h-48 bg-emerald-500/20 rounded-full blur-3xl pointer-events-none"></div>
        <div class="absolute -bottom-24 -left-24 w-48 h-48 bg-blue-500/20 rounded-full blur-3xl pointer-events-none"></div>

        <!-- Header Status -->
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

        <!-- Connection Status Banner -->
        <div class="mt-6 p-3.5 rounded-2xl bg-emerald-950/40 border border-emerald-500/30 flex items-center justify-between">
            <div class="flex items-center space-x-2.5">
                <div class="w-2 h-2 rounded-full bg-emerald-400 animate-ping"></div>
                <span class="text-xs font-medium text-emerald-300">API Status: Terhubung & Aktif</span>
            </div>
            <span class="text-[11px] font-mono bg-emerald-500/20 text-emerald-300 px-2 py-0.5 rounded-md border border-emerald-500/30">Frontend ⚡ TiDB</span>
        </div>

        <!-- Metrics Section -->
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

        <!-- Quick Link Buttons -->
        <div class="space-y-2.5">
            <!-- Website Frontend (Vercel) -->
            <a href="https://rerepetshop.biz.id/" target="_blank" class="flex items-center justify-between p-3.5 rounded-2xl bg-slate-800/60 hover:bg-slate-800 border border-slate-700/50 hover:border-slate-600 transition duration-200 group">
                <div class="flex items-center space-x-3">
                    <i class="fa-solid fa-globe text-cyan-400 group-hover:scale-110 transition"></i>
                    <span class="text-sm font-medium text-slate-200">Kunjungi Website Utama (Frontend)</span>
                </div>
                <i class="fa-solid fa-up-right-from-square text-xs text-slate-500 group-hover:text-slate-200 transition"></i>
            </a>

            <!-- Admin Control Panel (Buka Tab Baru) -->
            <a href="/admin/login" target="_blank" class="flex items-center justify-between p-3.5 rounded-2xl bg-slate-800/60 hover:bg-slate-800 border border-slate-700/50 hover:border-slate-600 transition duration-200 group">
                <div class="flex items-center space-x-3">
                    <i class="fa-solid fa-gauge-high text-amber-400 group-hover:scale-110 transition"></i>
                    <span class="text-sm font-medium text-slate-200">Admin Control Panel</span>
                </div>
                <i class="fa-solid fa-up-right-from-square text-xs text-slate-500 group-hover:text-slate-200 transition"></i>
            </a>
        </div>

        <!-- Footer -->
        <div class="mt-6 pt-4 border-t border-slate-800/60 text-center">
            <p class="text-xs text-slate-500">Laravel v{$laravelVer} (PHP v{$phpVer})</p>
        </div>
    </div>

</body>
</html>
HTML, 200)->header('Content-Type', 'text/html');
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