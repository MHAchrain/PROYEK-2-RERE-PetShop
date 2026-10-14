<?php

return [

    'paths' => ['api/*', 'sanctum/csrf-cookie', '*'],

    'allowed_methods' => ['*'],

    'allowed_origins' => ['*'], // Mengizinkan semua domain (termasuk Vercel)

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'], // Mengizinkan semua custom header (termasuk ngrok header)

    'exposed_headers' => [],

    'max_age' => 0,

    'supports_credentials' => false,

];