<?php

use Illuminate\Contracts\Http\Kernel;
use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

// 1. Buat direktori temp wajib
$dirs = [
    '/tmp/views',
    '/tmp/cache',
    '/tmp/sessions',
    '/tmp/logs',
    '/tmp/bootstrap'
];

foreach ($dirs as $dir) {
    if (!is_dir($dir)) {
        @mkdir($dir, 0777, true);
    }
}

// 2. Set environment runtime untuk write permission
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

    if (method_exists($app, 'handleRequest')) {
        $app->handleRequest(Request::capture());
    } else {
        $kernel = $app->make(Kernel::class);
        $response = $kernel->handle($request = Request::capture());
        $response->send();
        $kernel->terminate($request, $response);
    }
} catch (\Throwable $e) {
    http_response_code(500);
    header('Content-Type: application/json');
    echo json_encode([
        'status'  => 'error',
        'message' => $e->getMessage(),
        'file'    => $e->getFile(),
        'line'    => $e->getLine(),
        'trace'   => explode("\n", $e->getTraceAsString())
    ], JSON_PRETTY_PRINT);
    exit(1);
}