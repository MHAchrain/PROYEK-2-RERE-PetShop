<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\GroomingBooking;
use App\Models\Pelanggan;
use App\Models\Pesanan;
use App\Models\Produk;
use Illuminate\Support\Carbon;

class DashboardController extends Controller
{
    public function index()
    {
        // 1. Metrik Utama
        $totalProduk = Produk::count();
        $totalPelanggan = Pelanggan::count();
        $totalPesanan = Pesanan::count();
        $totalPendapatan = (float) Pesanan::whereIn('status_pesanan', ['diproses', 'dikirim', 'selesai'])
            ->sum('total');

        // 2. Pesanan Siap Kirim (Hanya yang SUDAH BAYAR / diproses atau siap dikirim)
        $pesananSiapKirim = Pesanan::with(['pelanggan', 'pembayaran'])
            ->where(function ($q) {
                // Posisi sudah bayar (paid / dibayar) atau status pesanan diproses / dikirim
                $q->whereHas('pembayaran', function ($pay) {
                    $pay->whereIn('status_bayar', ['paid', 'dibayar']);
                })->orWhereIn('status_pesanan', ['diproses', 'dikirim']);
            })
            ->whereNotIn('status_pesanan', ['batal', 'selesai'])
            ->latest('id_pesanan')
            ->take(6)
            ->get();

        // 3. Grooming Hari Ini (Kolom database TiDB: date & time)
        $groomingHariIni = GroomingBooking::with(['service', 'pelanggan'])
            ->whereDate('date', Carbon::today())
            ->orderBy('time', 'asc')
            ->take(6)
            ->get();

        // 4. Produk Stok Menipis (<= 5)
        $stokMenipis = Produk::with('kategori')
            ->where('stok', '<=', 5)
            ->orderBy('stok', 'asc')
            ->take(5)
            ->get();

        // 5. Statistik Penjualan 7 Hari Terakhir
        $chartDates = [];
        $chartTotals = [];
        for ($i = 6; $i >= 0; $i--) {
            $date = Carbon::today()->subDays($i);
            $chartDates[] = $date->translatedFormat('d M');
            $sum = (float) Pesanan::whereDate('tanggal_pesanan', $date)
                ->whereIn('status_pesanan', ['diproses', 'dikirim', 'selesai'])
                ->sum('total');
            $chartTotals[] = $sum;
        }

        return view('admin.dashboard.index', compact(
            'totalProduk',
            'totalPelanggan',
            'totalPesanan',
            'totalPendapatan',
            'pesananSiapKirim',
            'groomingHariIni',
            'stokMenipis',
            'chartDates',
            'chartTotals'
        ));
    }
}
