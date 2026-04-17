<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Keranjang;
use App\Models\KeranjangItem;
use App\Models\Pelanggan;
use App\Models\Pesanan;
use App\Models\PesananDetail;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class CheckoutController extends Controller
{
    public function checkout(Request $request)
    {
        $user = $request->user();

        $pelanggan = Pelanggan::where('email', $user->email)->first();

        if (! $pelanggan) {
            return response()->json([
                'success' => false,
                'message' => 'Data pelanggan tidak ditemukan',
            ], 404);
        }

        $keranjang = Keranjang::where('id_pelanggan', $pelanggan->id_pelanggan)->first();

        if (! $keranjang) {
            return response()->json([
                'success' => false,
                'message' => 'Keranjang tidak ditemukan',
            ], 404);
        }

        $items = KeranjangItem::where('id_keranjang', $keranjang->id_keranjang)->get();

        if ($items->isEmpty()) {
            return response()->json([
                'success' => false,
                'message' => 'Keranjang kosong',
            ], 400);
        }

        DB::beginTransaction();

        try {
            $pesanan = Pesanan::create([
                'id_pelanggan' => $pelanggan->id_pelanggan,
                'tanggal_pesanan' => now(),
                'alamat_kirim' => $pelanggan->alamat, 
                'no_telp' => $pelanggan->no_telp,
                'total' => $items->sum('subtotal'),
                'status_pesanan' => 'baru',
            ]);

            foreach ($items as $item) {
                PesananDetail::create([
                    'id_pesanan' => $pesanan->id_pesanan,
                    'id_produk' => $item->id_produk,
                    'qty' => $item->qty,
                    'harga_satuan' => $item->harga_satuan,
                    'subtotal' => $item->subtotal,
                ]);
            }

            KeranjangItem::where('id_keranjang', $keranjang->id_keranjang)->delete();
            $keranjang->total = 0;
            $keranjang->save();

            DB::commit();

            return response()->json([
                'success' => true,
                'message' => 'Checkout berhasil',
                'data' => $pesanan,
            ], 201);
        } catch (\Throwable $th) {
            DB::rollBack();
            return response()->json([
                'success' => false,
                'message' => 'Checkout gagal',
                'error' => $th->getMessage(),
            ], 500);
        }
    }
}