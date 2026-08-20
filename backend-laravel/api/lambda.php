<?php

use Illuminate\Foundation\Application;
use Illuminate\Http\Request;

define('LARAVEL_START', microtime(true));

// 1. Buat direktori wajib di /tmp agar tidak crash read-only filesystem
$tmpDirs = [
    '/tmp/views',
    '/tmp/cache',
    '/tmp/sessions',
    '/tmp/logs',
    '/tmp/bootstrap'
];

foreach ($tmpDirs as $dir) {
    if (!is_dir($dir)) {
        mkdir($dir, 0777, true);
    }
}

// 2. Set environment path runtime ke /tmp
putenv('APP_CONFIG_CACHE=/tmp/bootstrap/config.php');
putenv('APP_ROUTES_CACHE=/tmp/bootstrap/routes.php');
putenv('APP_EVENTS_CACHE=/tmp/bootstrap/events.php');
putenv('APP_PACKAGES_CACHE=/tmp/bootstrap/packages.php');
putenv('APP_SERVICES_CACHE=/tmp/bootstrap/services.php');
putenv('VIEW_COMPILED_PATH=/tmp/views');

// 3. Autoloader & Bootstrap
require __DIR__ . '/../vendor/autoload.php';

/** @var Application $app */
$app = require_once __DIR__ . '/../bootstrap/app.php';

$app->handleRequest(Request::capture());