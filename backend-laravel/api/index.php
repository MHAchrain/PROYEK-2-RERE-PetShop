<?php

use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

// Buat direktori temporary wajib Lambda
$dirs = ['/tmp/views', '/tmp/cache', '/tmp/sessions', '/tmp/logs', '/tmp/bootstrap'];
foreach ($dirs as $dir) {
    if (!is_dir($dir)) {
        @mkdir($dir, 0777, true);
    }
}

// Redirect path cache & storage ke /tmp
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

require __DIR__ . '/../vendor/autoload.php';

$app = require_once __DIR__ . '/../bootstrap/app.php';

if (method_exists($app, 'handleRequest')) {
    $app->handleRequest(Request::capture());
} else {
    $kernel = $app->make(\Illuminate\Contracts\Http\Kernel::class);
    $response = $kernel->handle($request = Request::capture());
    $response->send();
    $kernel->terminate($request, $response);
}