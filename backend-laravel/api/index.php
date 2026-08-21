<?php

ini_set('display_errors', '1');
ini_set('display_startup_errors', '1');
error_reporting(E_ALL);

// Direktori cache & storage wajib di RAM Lambda (/tmp)
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

    // Laravel 12 Bootstrapping Request Capture
    $kernel = $app->make(\Illuminate\Contracts\Http\Kernel::class);
    $response = $kernel->handle(
        $request = \Illuminate\Http\Request::capture()
    );
    $response->send();
    $kernel->terminate($request, $response);
} catch (\Throwable $e) {
    header('Content-Type: application/json; charset=utf-8');
    http_response_code(500);
    echo json_encode([
        'error_type' => get_class($e),
        'message'    => $e->getMessage(),
        'file'       => $e->getFile(),
        'line'       => $e->getLine(),
        'trace'      => explode("\n", $e->getTraceAsString())
    ], JSON_PRETTY_PRINT | JSON_UNESCAPED_SLASHES);
}