<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
<<<<<<< HEAD
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\BinaryFileResponse;
=======
>>>>>>> origin/rayen

class ImageController extends Controller
{
    public function show($path)
    {
<<<<<<< HEAD
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
=======
        // Decode path
        $path = urldecode($path);
        
        // Bersihkan path dari 'produk/' prefix
        $cleanPath = preg_replace('#^produk/#', '', $path);
        
        // Cek lokasi file yang benar (sama seperti yang dipakai FE)
        $possiblePaths = [
            public_path('storage/produk/' . $cleanPath),      // ← PRIORITAS
            storage_path('app/public/produk/' . $cleanPath),
            public_path('storage/' . $path),
            storage_path('app/public/' . $path),
        ];
        
        $filePath = null;
        foreach ($possiblePaths as $tryPath) {
            if (file_exists($tryPath)) {
                $filePath = $tryPath;
                break;
            }
        }
        
        if (!$filePath) {
            return response()->json([
                'error' => 'Image not found',
                'path' => $path,
                'cleanPath' => $cleanPath
            ], 404);
        }
        
        return response()->file($filePath, [
            'Access-Control-Allow-Origin' => '*',
            'Access-Control-Allow-Methods' => 'GET, OPTIONS',
            'Access-Control-Allow-Headers' => 'Content-Type, Authorization',
        ]);
    }
    
    public function options()
    {
        return response('', 200)
            ->header('Access-Control-Allow-Origin', '*')
            ->header('Access-Control-Allow-Methods', 'GET, OPTIONS')
            ->header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    }
}
>>>>>>> origin/rayen
