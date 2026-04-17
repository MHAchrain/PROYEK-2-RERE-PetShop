<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Favorite;

class FavoriteController extends Controller
{
    public function index()
    {
        $user = auth('sanctum')->user();

        if (! $user) {
            return response()->json(['message' => 'Unauthorized'], 401);
        }

        $pelangganId = $user->id_pelanggan;

        $favorites = Favorite::with('produk')
            ->where('pelanggan_id', $pelangganId)
            ->get();

        return response()->json([
            'success' => true,
            'data'    => $favorites,
        ]);
    }

    public function store(Request $request)
    {
        $user = auth('sanctum')->user();
    
    // DEBUG: Cek apakah user dapet dan punya id_pelanggan
    if (!$user->id_pelanggan) {
        return response()->json([
            'message' => 'User tidak memiliki ID Pelanggan. Cek database tabel users lu.',
            'user_data' => $user
        ], 500);
    }

    $pelangganId = $user->id_pelanggan;

        $request->validate([
            'produk_id' => 'required|exists:produk,id_produk',
        ]);

        $data = [
            'pelanggan_id' => $pelangganId,
            'produk_id'    => $request->input('produk_id'),
        ];

        $exists = Favorite::where($data)->first();

        if ($exists) {
            $exists->delete();
            return response()->json([
                'success' => true,
                'message' => 'Dihapus dari favorit'
            ]);
        }

        Favorite::create($data);

        return response()->json([
            'success' => true,
            'message' => 'Ditambahkan ke favorit'
        ]);
    }
}