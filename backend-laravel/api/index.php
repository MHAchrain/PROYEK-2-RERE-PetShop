<?php

header('Content-Type: application/json');

$vendorExists = file_exists(__DIR__ . '/../vendor/autoload.php');
$bootstrapExists = file_exists(__DIR__ . '/../bootstrap/app.php');
$phpVersion = phpversion();

echo json_encode([
    'status' => 'diagnostic_running',
    'php_version' => $phpVersion,
    'vendor_autoload_found' => $vendorExists,
    'bootstrap_app_found' => $bootstrapExists,
    'env_app_key' => getenv('APP_KEY') ? 'EXISTS' : 'MISSING',
], JSON_PRETTY_PRINT);