<?php

// 1. Buat folder temporary yang wajib ada di serverless
$dirs = [
    '/tmp/storage/framework/views',
    '/tmp/storage/framework/cache/data',
    '/tmp/storage/framework/sessions',
    '/tmp/storage/logs',
    '/tmp/bootstrap/cache'
];

foreach ($dirs as $dir) {
    if (!is_dir($dir)) {
        mkdir($dir, 0777, true);
    }
}

// 2. Set environment path runtime
putenv('APP_STORAGE=/tmp/storage');
putenv('APP_SERVICES_CACHE=/tmp/bootstrap/cache/services.php');
putenv('APP_PACKAGES_CACHE=/tmp/bootstrap/cache/packages.php');
putenv('APP_CONFIG_CACHE=/tmp/bootstrap/cache/config.php');
putenv('APP_ROUTES_CACHE=/tmp/bootstrap/cache/routes.php');
putenv('APP_EVENTS_CACHE=/tmp/bootstrap/cache/events.php');
putenv('VIEW_COMPILED_PATH=/tmp/storage/framework/views');

// 3. Load Autoload Composer
require __DIR__ . '/../vendor/autoload.php';

// 4. Load Laravel Application (Kompatibel Laravel 10, 11, & 12)
$app = require_once __DIR__ . '/../bootstrap/app.php';

// 5. Handle Request
if ($app instanceof Illuminate\Foundation\Application) {
    $kernel = $app->make(Illuminate\Contracts\Http\Kernel::class);
    $response = $kernel->handle(
        $request = Illuminate\Http\Request::capture()
    );
    $response->send();
    $kernel->terminate($request, $response);
} else {
    // Untuk format Laravel 11/12 bootstrap closure
    $app->handleRequest(Illuminate\Http\Request::capture());
}