<?php

return [

    'paths' => ['api/*', 'sanctum/csrf-cookie', '*'],

    'allowed_methods' => ['*'],

    'allowed_origins' => ['https://rerepetshop.biz.id',
    'https://www.rerepetshop.biz.id',
    'https://rere-petshop-frontend.vercel.app',
    'http://localhost:5173', // jaga-jaga kalau testing lokal
], // Mengizinkan semua domain (termasuk Vercel)

    'allowed_origins_patterns' => [],

    'allowed_headers' => ['*'], // Mengizinkan semua custom header (termasuk ngrok header)

    'exposed_headers' => [],

    'max_age' => 0,

    'supports_credentials' => true,

];