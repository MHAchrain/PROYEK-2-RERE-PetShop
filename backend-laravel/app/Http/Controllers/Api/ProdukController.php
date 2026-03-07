<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Produk;
use Illuminate\Http\Request;

class ProdukController extends Controller
{
    public function index(Request $request)
    {
        $query = Produk::with('kategori');

        if ($request->filled('search')) {
            $query->where('nama_produk', 'like', '%' . $request->search . '%');
        }

        if ($request->filled('id_kategori')) {
            $query->where('id_kategori', $request->id_kategori);
        }

        $produk = $query
            ->orderBy('id_produk', 'desc')
            ->paginate(10);

        return response()->json([
            'success' => true,
            'message' => 'Daftar produk berhasil diambil',
            'data' => $produk,
        ]);
    }

    public function show($id)
    {
        $produk = Produk::with('kategori')->find($id);

        if (! $produk) {
            return response()->json([
                'success' => false,
                'message' => 'Produk tidak ditemukan',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Detail produk berhasil diambil',
            'data' => $produk,
        ]);
    }
}