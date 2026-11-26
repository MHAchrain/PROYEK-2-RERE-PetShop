<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\GroomingBooking;
use App\Models\Pelanggan;
use App\Models\Pesanan;
use App\Models\Produk;
use Barryvdh\DomPDF\Facade\Pdf;
use Illuminate\Support\Carbon;

class DashboardController extends Controller
{
    public function index()
    {
        $today = Carbon::today();

        // 1. Metrik Utama
        $totalProduk = Produk::count();
        $totalPelanggan = Pelanggan::count();
        $totalPesanan = Pesanan::count();

        // Total Pendapatan Hari Ini (Pesanan yang sudah dibayar lunas hari ini)
        $totalPendapatanHariIni = (float) Pesanan::where(function ($query) use ($today) {
            $query->whereHas('pembayaran', function ($q) use ($today) {
                $q->where('status_bayar', 'paid')
                  ->where(function ($w) use ($today) {
                      $w->whereDate('waktu_bayar', $today)
                        ->orWhere(function ($or) use ($today) {
                            $or->whereNull('waktu_bayar')
                               ->whereDate('updated_at', $today);
                        });
                  });
            })->orWhere(function ($q) use ($today) {
                $q->whereDate('tanggal_pesanan', $today)
                  ->whereIn('status_pesanan', ['diproses', 'dikirim', 'selesai'])
                  ->whereHas('pembayaran', function ($p) {
                      $p->where('status_bayar', 'paid');
                  });
            });
        })->sum('total');

        // 2. Pesanan Siap Kirim (Hanya yang status_pesanan = 'diproses' / sedang diproses saja)
        $pesananSiapKirim = Pesanan::with(['pelanggan', 'pembayaran', 'pengiriman'])
            ->where('status_pesanan', 'diproses')
            ->latest('id_pesanan')
            ->take(6)
            ->get();

        // 3. Grooming Hari Ini (Kolom database TiDB: date & time)
        $groomingHariIni = GroomingBooking::with(['service', 'pelanggan'])
            ->whereDate('date', $today)
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
            'totalPendapatanHariIni',
            'pesananSiapKirim',
            'groomingHariIni',
            'stokMenipis',
            'chartDates',
            'chartTotals'
        ));
    }

    /**
     * Download Invoice / Rekap PDF Pesanan yang Sudah Dibayar Hari Ini
     */
    public function downloadInvoiceHariIni()
    {
        $today = Carbon::today();

        $pesananPaidHariIni = Pesanan::with(['pelanggan', 'details.produk', 'pembayaran', 'pengiriman'])
            ->where(function ($query) use ($today) {
                $query->whereHas('pembayaran', function ($q) use ($today) {
                    $q->where('status_bayar', 'paid')
                      ->where(function ($w) use ($today) {
                          $w->whereDate('waktu_bayar', $today)
                            ->orWhere(function ($or) use ($today) {
                                $or->whereNull('waktu_bayar')
                                   ->whereDate('updated_at', $today);
                            });
                      });
                })->orWhere(function ($q) use ($today) {
                    $q->whereDate('tanggal_pesanan', $today)
                      ->whereIn('status_pesanan', ['diproses', 'dikirim', 'selesai'])
                      ->whereHas('pembayaran', function ($p) {
                          $p->where('status_bayar', 'paid');
                      });
                });
            })
            ->latest('id_pesanan')
            ->get();

        $totalPendapatanHariIni = (float) $pesananPaidHariIni->sum('total');
        $tanggalFormatted = $today->translatedFormat('d F Y');

        $pdf = Pdf::loadView('admin.dashboard.invoice_pdf', compact(
            'pesananPaidHariIni',
            'totalPendapatanHariIni',
            'tanggalFormatted'
        ))->setPaper('a4', 'portrait');

        return $pdf->download('INVOICE-HARIAN-RERE-PETSHOP-' . date('Ymd') . '.pdf');
    }
}
