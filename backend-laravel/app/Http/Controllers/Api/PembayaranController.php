<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pelanggan;
use App\Models\Pesanan;
use App\Models\Pembayaran;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Midtrans\Config;
use Midtrans\Snap;
use Midtrans\Notification;

class PembayaranController extends Controller
{
    public function __construct()
    {
        // Konfigurasi khusus Sandbox
        Config::$serverKey = config('midtrans.server_key'); 
        Config::$isProduction = false; // Wajib false untuk Sandbox
        Config::$isSanitized = true;
        Config::$is3ds = true;
    }

    public function store(Request $request)
{
    $request->validate([
        'id_pesanan' => 'required|integer',
        'metode_bayar' => 'required|string|max:50',
    ]);

    $user = $request->user();
    $pelanggan = Pelanggan::where('email', $user->email)->first();

    if (!$pelanggan) {
        return response()->json([
            'success' => false,
            'message' => 'Data pelanggan tidak ditemukan',
        ], 404);
    }

    $pesanan = Pesanan::with('details.produk')
        ->where('id_pesanan', $request->id_pesanan)
        ->where('id_pelanggan', $pelanggan->id_pelanggan)
        ->first();

    if (!$pesanan) {
        return response()->json([
            'success' => false,
            'message' => 'Pesanan tidak ditemukan',
        ], 404);
    }

    // Cek apakah payment sudah ada
    $existingPayment = Pembayaran::where('id_pesanan', $pesanan->id_pesanan)->first();
    if ($existingPayment && $existingPayment->status_bayar === 'paid') {
        return response()->json([
            'success' => false,
            'message' => 'Pesanan ini sudah dibayar.',
        ], 400);
    }

    // Siapkan data transaksi untuk Midtrans
    $transactionDetails = [
        'order_id'     => 'ORDER-' . $pesanan->id_pesanan . '-' . time(),
        'gross_amount' => (int) $pesanan->total,
    ];

    $customerDetails = [
        'first_name' => $pelanggan->nama_pelanggan,
        'email'      => $pelanggan->email,
        'phone'      => $pelanggan->no_hp ?? '',
    ];

    $itemDetails = $pesanan->details->map(function ($detail) {
        return [
            'id'       => $detail->id_detail,
            'price'    => (int) $detail->harga_satuan,
            'quantity' => (int) $detail->qty,
            'name'     => $detail->produk->nama_produk ?? 'Produk',
        ];
    })->toArray();

    $params = [
        'transaction_details' => $transactionDetails,
        'customer_details'    => $customerDetails,
        'item_details'        => $itemDetails,
    ];

    try {
        $snapToken = Snap::getSnapToken($params);

        // Simpan atau update data pembayaran
        Pembayaran::updateOrCreate(
            ['id_pesanan' => $pesanan->id_pesanan],
            [
                'metode_bayar'  => $request->metode_bayar,
                'status_bayar'  => 'pending',
                'jumlah_bayar'  => (int) $pesanan->total,
                'ref_gateway'   => $transactionDetails['order_id'],
                'snap_token'    => $snapToken,
            ]
        );

        // Update status pesanan
        $pesanan->update(['status_pesanan' => 'baru']);

        return response()->json([
            'success'    => true,
            'snap_token' => $snapToken,
        ]);

    } catch (\Exception $e) {
        return response()->json([
            'success' => false,
            'message' => 'Midtrans error: ' . $e->getMessage(),
        ], 500);
    }
}
public function webhook(Request $request)
{
    Config::$serverKey = config('midtrans.server_key');
    Config::$isProduction = false;

    try {
        $notif = new Notification();

        $orderId       = $notif->order_id;        // "ORDER-4-1777111127"
        $statusCode    = $notif->status_code;
        $grossAmount   = $notif->gross_amount;
        $transactionStatus = $notif->transaction_status;
        $fraudStatus   = $notif->fraud_status;

        // Ambil id_pesanan dari order_id
        // format order_id: ORDER-{id_pesanan}-{timestamp}
        $idPesanan = explode('-', $orderId)[1];

        $pembayaran = Pembayaran::where('id_pesanan', $idPesanan)->first();

        if (!$pembayaran) {
            return response()->json(['message' => 'Pembayaran tidak ditemukan'], 404);
        }

        // Tentukan status berdasarkan response Midtrans
        if ($transactionStatus == 'capture') {
            $pembayaran->status_bayar = ($fraudStatus == 'challenge') ? 'pending' : 'paid';
        } elseif ($transactionStatus == 'settlement') {
            $pembayaran->status_bayar = 'paid';
            $pembayaran->waktu_bayar  = now();
        } elseif (in_array($transactionStatus, ['cancel', 'deny', 'expire'])) {
            $pembayaran->status_bayar = 'failed';
        } elseif ($transactionStatus == 'pending') {
            $pembayaran->status_bayar = 'pending';
        }

        $pembayaran->save(); // Model booted() akan auto update status_pesanan jadi 'diproses'

        return response()->json(['message' => 'Webhook berhasil diproses']);

    } catch (\Exception $e) {
        return response()->json(['message' => $e->getMessage()], 500);
    }
}
    public function show(Request $request, $id)
    {
        $user = $request->user();
        $pelanggan = Pelanggan::where('email', $user->email)->first();

        if (!$pelanggan) {
            return response()->json(['success' => false, 'message' => 'Pelanggan tidak ditemukan'], 404);
        }

        $pembayaran = Pembayaran::where('id_pesanan', $id)->first();

        if (!$pembayaran) {
            return response()->json(['success' => false, 'message' => 'Data pembayaran belum ada'], 404);
        }

        return response()->json([
            'success' => true,
            'data' => $pembayaran,
        ]);
    }
}