<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pelanggan;
use App\Models\Pesanan;
use App\Models\Produk;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class PesananController extends Controller
{
    public function index(Request $request)
    {
        $user = $request->user();

        $pelanggan = Pelanggan::where('email', $user->email)->first();

        if (!$pelanggan) {
            return response()->json([
                'message' => 'Data pelanggan tidak ditemukan.'
            ], 404);
        }

        $pesanan = Pesanan::with(['details.produk', 'pembayaran', 'pengiriman'])
            ->where('id_pelanggan', $pelanggan->id_pelanggan)
            ->latest('id_pesanan')
            ->get();

        foreach ($pesanan as $item) {
            if ($item->pembayaran && $item->pembayaran->status_bayar === 'pending') {
                $this->syncMidtransStatus($item);
            }
        }

        return response()->json([
            'message' => 'Riwayat pesanan berhasil diambil.',
            'data' => $pesanan
        ]);
    }

    public function show(Request $request, $id)
    {
        $user = $request->user();

        $pelanggan = Pelanggan::where('email', $user->email)->first();

        if (!$pelanggan) {
            return response()->json([
                'message' => 'Data pelanggan tidak ditemukan.'
            ], 404);
        }

        $pesanan = Pesanan::with(['details.produk', 'pembayaran', 'pengiriman'])
            ->where('id_pelanggan', $pelanggan->id_pelanggan)
            ->where('id_pesanan', $id)
            ->first();

        if (!$pesanan) {
            return response()->json([
                'message' => 'Pesanan tidak ditemukan.'
            ], 404);
        }

        $this->syncMidtransStatus($pesanan);

        return response()->json([
            'message' => 'Detail pesanan berhasil diambil.',
            'data' => $pesanan
        ]);
    }

    private function syncMidtransStatus(Pesanan $pesanan): void
    {
        $pembayaran = $pesanan->pembayaran;
        if (!$pembayaran || $pembayaran->status_bayar !== 'pending' || empty($pembayaran->ref_gateway)) {
            return;
        }

        try {
            \Midtrans\Config::$serverKey = config('midtrans.server_key');
            \Midtrans\Config::$isProduction = (bool) config('midtrans.is_production', false);

            $status = (object) \Midtrans\Transaction::status($pembayaran->ref_gateway);
            $txStatus = $status->transaction_status ?? null;
            $fraudStatus = $status->fraud_status ?? null;

            $isPaid = $txStatus === 'settlement' ||
                ($txStatus === 'capture' && $fraudStatus !== 'challenge' && $fraudStatus !== 'deny');

            if ($isPaid) {
                $paymentType = $status->payment_type ?? null;
                $vaBank = $status->va_numbers[0]->bank ?? null;
                if ($paymentType === 'bank_transfer' && $vaBank) {
                    $pembayaran->metode_bayar = strtoupper($vaBank) . ' VA';
                } elseif ($paymentType === 'echannel') {
                    $pembayaran->metode_bayar = 'MANDIRI VA';
                } elseif (!empty($paymentType)) {
                    $pembayaran->metode_bayar = strtoupper(str_replace('_', ' ', $paymentType));
                }

                $pembayaran->status_bayar = 'paid';
                $pembayaran->save();

                if (in_array($pesanan->status_pesanan, ['baru', 'menunggu_verifikasi'], true)) {
                    $pesanan->status_pesanan = 'diproses';
                    $pesanan->save();
                }

                $pesanan->refresh();
                $pesanan->load(['details.produk', 'pembayaran', 'pengiriman']);
            }
        } catch (\Throwable $e) {
            \Illuminate\Support\Facades\Log::warning('Midtrans sync error for order ' . $pesanan->id_pesanan . ': ' . $e->getMessage());
        }
    }
public function status(Request $request, $id)
{
    $user = $request->user();

    $pelanggan = Pelanggan::where('email', $user->email)->first();

    if (!$pelanggan) {
        return response()->json([
            'message' => 'Data pelanggan tidak ditemukan.'
        ], 404);
    }

    $pesanan = Pesanan::with(['pembayaran', 'pengiriman'])
        ->where('id_pelanggan', $pelanggan->id_pelanggan)
        ->where('id_pesanan', $id)
        ->first();

    if (!$pesanan) {
        return response()->json([
            'message' => 'Pesanan tidak ditemukan.'
        ], 404);
    }

    return response()->json([
        'message' => 'Status pesanan berhasil diambil.',
        'data' => [
            'id_pesanan' => $pesanan->id_pesanan,
            'tanggal_pesanan' => $pesanan->tanggal_pesanan,
            'total' => $pesanan->total,
            'status_pesanan' => $pesanan->status_pesanan,

            'pembayaran' => $pesanan->pembayaran ? [
                'metode_bayar' => $pesanan->pembayaran->metode_bayar,
                'jumlah_bayar' => $pesanan->pembayaran->jumlah_bayar,
                'status_bayar' => $pesanan->pembayaran->status_bayar,
                'ref_gateway' => $pesanan->pembayaran->ref_gateway,
                'waktu_bayar' => $pesanan->pembayaran->waktu_bayar,
            ] : null,

            'pengiriman' => $pesanan->pengiriman ? [
                'kurir' => $pesanan->pengiriman->kurir,
                'resi' => $pesanan->pengiriman->resi,
                'status_kirim' => $pesanan->pengiriman->status_kirim,
                'tanggal_kirim' => $pesanan->pengiriman->tanggal_kirim,
            ] : null,
        ]
    ]);
}
    public function selesai(Request $request, $id)
    {
        $user = $request->user();

        $pelanggan = Pelanggan::where('email', $user->email)->first();

        if (!$pelanggan) {
            return response()->json([
                'message' => 'Data pelanggan tidak ditemukan.'
            ], 404);
        }

        $pesanan = Pesanan::with('pengiriman')
            ->where('id_pelanggan', $pelanggan->id_pelanggan)
            ->where('id_pesanan', $id)
            ->first();

        if (!$pesanan) {
            return response()->json([
                'message' => 'Pesanan tidak ditemukan.'
            ], 404);
        }

        if ($pesanan->status_pesanan !== 'dikirim') {
            return response()->json([
                'message' => 'Pesanan hanya bisa diselesaikan jika statusnya sudah dikirim.'
            ], 422);
        }

        $pesanan->status_pesanan = 'selesai';
        $pesanan->save();

        if ($pesanan->pengiriman) {
            $pesanan->pengiriman->status_kirim = 'diterima';
            $pesanan->pengiriman->save();
        }

        return response()->json([
            'message' => 'Pesanan berhasil dikonfirmasi selesai.',
            'data' => [
                'id_pesanan' => $pesanan->id_pesanan,
                'status_pesanan' => $pesanan->status_pesanan,
                'status_kirim' => $pesanan->pengiriman?->status_kirim,
            ]
        ]);
    }

    public function batal(Request $request, $id)
    {
        $user = $request->user();

        $pelanggan = Pelanggan::where('email', $user->email)->first();

        if (!$pelanggan) {
            return response()->json([
                'message' => 'Data pelanggan tidak ditemukan.'
            ], 404);
        }

        $pesanan = Pesanan::with(['pembayaran', 'details'])
            ->where('id_pelanggan', $pelanggan->id_pelanggan)
            ->where('id_pesanan', $id)
            ->first();

        if (!$pesanan) {
            return response()->json([
                'message' => 'Pesanan tidak ditemukan.'
            ], 404);
        }

        if (!in_array($pesanan->status_pesanan, ['baru', 'menunggu_verifikasi'])) {
            return response()->json([
                'message' => 'Pesanan tidak bisa dibatalkan karena sudah diproses lebih lanjut.'
            ], 422);
        }

        if ($pesanan->pembayaran && $pesanan->pembayaran->status_bayar === 'paid') {
            return response()->json([
                'message' => 'Pesanan tidak bisa dibatalkan karena pembayaran sudah dikonfirmasi.'
            ], 422);
        }

        DB::transaction(function () use ($pesanan) {
            foreach ($pesanan->details as $detail) {
                $produk = Produk::where('id_produk', $detail->id_produk)
                    ->lockForUpdate()
                    ->first();

                if ($produk) {
                    $produk->stok += (int) $detail->qty;
                    $produk->save();
                }
            }

            $pesanan->status_pesanan = 'batal';
            $pesanan->save();

            if ($pesanan->pembayaran && $pesanan->pembayaran->status_bayar === 'pending') {
                $pesanan->pembayaran->status_bayar = 'failed';
                $pesanan->pembayaran->save();
            }
        });

        return response()->json([
            'message' => 'Pesanan berhasil dibatalkan.',
            'data' => [
                'id_pesanan' => $pesanan->id_pesanan,
                'status_pesanan' => $pesanan->status_pesanan,
                'status_bayar' => $pesanan->pembayaran?->status_bayar,
            ]
        ]);
    }
}
