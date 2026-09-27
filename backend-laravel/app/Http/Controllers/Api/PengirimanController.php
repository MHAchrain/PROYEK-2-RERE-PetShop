<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pengiriman;
use App\Models\Pesanan;
use App\Models\Pelanggan;
use Illuminate\Http\Request;

class PengirimanController extends Controller
{
    public function show(Request $request, $id)
    {
        $user = $request->user();

        $pelanggan = Pelanggan::where('email', $user->email)->first();

        if (!$pelanggan) {
            return response()->json([
                'success' => false,
                'message' => 'Data pelanggan tidak ditemukan'
            ], 404);
        }

        $pesanan = Pesanan::where('id_pesanan', $id)
            ->where('id_pelanggan', $pelanggan->id_pelanggan)
            ->first();

        if (!$pesanan) {
            return response()->json([
                'success' => false,
                'message' => 'Pesanan tidak ditemukan'
            ], 404);
        }

        $pengiriman = Pengiriman::where('id_pesanan', $pesanan->id_pesanan)->first();

        if (!$pengiriman) {
            return response()->json([
                'success' => false,
                'message' => 'Pengiriman belum dibuat'
            ]);
        }

        return response()->json([
            'success' => true,
            'data' => $pengiriman
        ]);
    }

    // ✅ METHOD BARU (TAMBAHAN) - Konfirmasi pesanan sudah diterima
    public function terima(Request $request, $id)
    {
        $user = $request->user();

        // Cek pelanggan
        $pelanggan = Pelanggan::where('email', $user->email)->first();

        if (!$pelanggan) {
            return response()->json([
                'success' => false,
                'message' => 'Data pelanggan tidak ditemukan'
            ], 404);
        }

        // Cari pengiriman milik pelanggan ini
        $pengiriman = Pengiriman::where('id_pengiriman', $id)
            ->whereHas('pesanan', function ($q) use ($pelanggan) {
                $q->where('id_pelanggan', $pelanggan->id_pelanggan);
            })
            ->first();

        if (!$pengiriman) {
            return response()->json([
                'success' => false,
                'message' => 'Pengiriman tidak ditemukan'
            ], 404);
        }

        // Update status kirim jadi 'diterima'
        $pengiriman->update([
            'status_kirim' => 'diterima',
        ]);

        // Update status pesanan jadi 'selesai'
        if ($pengiriman->pesanan) {
            $pengiriman->pesanan->update([
                'status_pesanan' => 'selesai',
            ]);
        }

        return response()->json([
            'success' => true,
            'message' => 'Pesanan berhasil diterima!',
            'data' => $pengiriman->fresh(),
        ]);
    }
}