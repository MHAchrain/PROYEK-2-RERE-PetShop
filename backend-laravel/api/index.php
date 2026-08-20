<?php

use Illuminate\Contracts\Http\Kernel;
use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

// 1. Siapkan direktori writable di /tmp AWS Lambda
$tmpDirectories = [
    '/tmp/views',
    '/tmp/cache',
    '/tmp/sessions',
    '/tmp/logs',
    '/tmp/bootstrap'
];

foreach ($tmpDirectories as $dir) {
    if (!is_dir($dir)) {
        @mkdir($dir, 0777, true);
    }
}

// 2. Alihkan seluruh path cache & storage internal ke /tmp
putenv('APP_CONFIG_CACHE=/tmp/bootstrap/config.php');
putenv('APP_EVENTS_CACHE=/tmp/bootstrap/events.php');
putenv('APP_PACKAGES_CACHE=/tmp/bootstrap/packages.php');
putenv('APP_ROUTES_CACHE=/tmp/bootstrap/routes.php');
putenv('APP_SERVICES_CACHE=/tmp/bootstrap/services.php');
putenv('VIEW_COMPILED_PATH=/tmp/views');
putenv('CACHE_STORE=array');
putenv('CACHE_DRIVER=array');
putenv('SESSION_DRIVER=cookie');
putenv('LOG_CHANNEL=stderr');

try {
    require __DIR__ . '/../vendor/autoload.php';
    $app = require_once __DIR__ . '/../bootstrap/app.php';

    // Mendukung Laravel 10 & Laravel 11
    if (method_exists($app, 'handleRequest')) {
        $app->handleRequest(Request::capture());
    } else {
        $kernel = $app->make(Kernel::class);
        $response = $kernel->handle($request = Request::capture());
        $response->send();
        $kernel->terminate($request, $response);
    }
} catch (\Throwable $e) {
    // Tangkap fatal error dan kembalikan JSON bersih (bukan crash runtime)
    header('Content-Type: application/json; charset=utf-8');
    http_response_code(200); // 200 agar Vercel tidak menganggap container mati
    echo json_encode([
        'status'  => 'error',
        'type'    => get_class($e),
        'message' => $e->getMessage(),
        'file'    => $e->getFile(),
        'line'    => $e->getLine(),
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
}