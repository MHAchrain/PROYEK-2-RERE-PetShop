<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\BinaryFileResponse;

class ImageController extends Controller
{
    public function show($path)
    {
        // Decode path jika encoded
        $path = urldecode($path);

        // Path lengkap ke file
        $filePath = storage_path('app/public/' . $path);

        // Cek file exist
        if (!file_exists($filePath)) {
            return response()->json(['error' => 'Image not found'], 404);
        }

        // Return file dengan CORS headers
        return response()->file($filePath, [
            'Access-Control-Allow-Origin' => '*',
            'Access-Control-Allow-Methods' => 'GET, OPTIONS',
            'Access-Control-Allow-Headers' => 'Content-Type',
        ]);
    }
}