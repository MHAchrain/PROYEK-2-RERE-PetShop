<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pelanggan;
use App\Models\Pesanan;
use App\Models\Pembayaran;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class PembayaranController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'id_pesanan' => 'required|integer',
            'metode_bayar' => 'required|string|max:50',
            'ref_gateway' => 'nullable|string|max:100',
        ]);

        $user = $request->user();

        $pelanggan = Pelanggan::where('email', $user->email)->first();

        if (! $pelanggan) {
            return response()->json([
                'success' => false,
                'message' => 'Data pelanggan tidak ditemukan',
            ], 404);
        }

        $pesanan = Pesanan::where('id_pesanan', $request->id_pesanan)
            ->where('id_pelanggan', $pelanggan->id_pelanggan)
            ->first();

        if (! $pesanan) {
            return response()->json([
                'success' => false,
                'message' => 'Pesanan tidak ditemukan',
            ], 404);
        }

        $cekPembayaran = Pembayaran::where('id_pesanan', $pesanan->id_pesanan)->first();

        if ($cekPembayaran) {
            return response()->json([
                'success' => false,
                'message' => 'Pembayaran untuk pesanan ini sudah dibuat',
            ], 400);
        }

        DB::beginTransaction();

        try {
           $pembayaran = Pembayaran::create([
                'id_pesanan' => $pesanan->id_pesanan,
                'metode_bayar' => $request->metode_bayar,
                'status_bayar' => 'pending',
                'ref_gateway' => $request->ref_gateway,
                'waktu_bayar' => now(),
                'jumlah_bayar' => $pesanan->total,
                ]);
            $pesanan->status_pesanan = 'baru';
            $pesanan->save();

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Pembayaran berhasil dibuat',
                'data' => $pembayaran,
            ], 201);
        } catch (\Throwable $th) {
            DB::rollBack();

            return response()->json([
                'success' => false,
                'message' => 'Pembayaran gagal dibuat',
                'error' => $th->getMessage(),
            ], 500);
        }
    }

    public function show(Request $request, $id)
    {
        $user = $request->user();

        $pelanggan = Pelanggan::where('email', $user->email)->first();

        if (! $pelanggan) {
            return response()->json([
                'success' => false,
                'message' => 'Data pelanggan tidak ditemukan',
            ], 404);
        }

        $pesanan = Pesanan::where('id_pesanan', $id)
            ->where('id_pelanggan', $pelanggan->id_pelanggan)
            ->first();

        if (! $pesanan) {
            return response()->json([
                'success' => false,
                'message' => 'Pesanan tidak ditemukan',
            ], 404);
        }

        $pembayaran = Pembayaran::where('id_pesanan', $pesanan->id_pesanan)->first();

        if (! $pembayaran) {
            return response()->json([
                'success' => false,
                'message' => 'Data pembayaran belum ada',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'message' => 'Data pembayaran berhasil diambil',
            'data' => $pembayaran,
        ]);
    }
}