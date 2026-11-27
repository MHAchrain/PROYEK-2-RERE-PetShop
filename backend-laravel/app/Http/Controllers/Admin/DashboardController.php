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

        // Total Pendapatan Hari Ini: Toko + Grooming yang sudah lunas hari ini
        $pendapatanTokoHariIni = (float) Pesanan::whereDate('tanggal_pesanan', $today)
            ->whereHas('pembayaran', function ($p) {
                $p->where('status_bayar', 'paid');
            })
            ->sum('total');

        $pendapatanGroomingHariIni = (float) GroomingBooking::with('service')
            ->whereDate('created_at', $today)
            ->whereIn('status', ['terjadwal', 'dikonfirmasi', 'selesai'])
            ->get()
            ->sum(function ($g) {
                return (float) ($g->total_price ?? $g->price ?? $g->service->price ?? 0);
            });

        $totalPendapatanHariIni = $pendapatanTokoHariIni + $pendapatanGroomingHariIni;

        // 2. Pesanan Siap Kirim (Hanya yang status_pesanan = 'diproses' / sedang diproses saja)
        $pesananSiapKirim = Pesanan::with(['pelanggan', 'pembayaran', 'pengiriman'])
            ->where('status_pesanan', 'diproses')
            ->latest('id_pesanan')
            ->take(6)
            ->get();

        // 3. Grooming Hari Ini (Hanya yang sudah dibayar & status terjadwal)
        $groomingHariIni = GroomingBooking::with(['service', 'pelanggan'])
            ->whereDate('date', $today)
            ->where('status', 'terjadwal')
            ->orderBy('time', 'asc')
            ->take(6)
            ->get();

        // 4. Produk Stok Menipis (<= 5)
        $stokMenipis = Produk::with('kategori')
            ->where('stok', '<=', 5)
            ->orderBy('stok', 'asc')
            ->take(5)
            ->get();

        // 5. Statistik Penjualan 7 Hari Terakhir (Toko + Grooming yang sudah lunas)
        $chartDates = [];
        $chartTotals = [];
        for ($i = 6; $i >= 0; $i--) {
            $date = Carbon::today()->subDays($i);
            $chartDates[] = $date->translatedFormat('d M');
            $sumToko = (float) Pesanan::whereDate('tanggal_pesanan', $date)
                ->whereHas('pembayaran', function ($p) {
                    $p->where('status_bayar', 'paid');
                })
                ->sum('total');
            $sumGrooming = (float) GroomingBooking::with('service')
                ->whereDate('created_at', $date)
                ->whereIn('status', ['terjadwal', 'dikonfirmasi', 'selesai'])
                ->get()
                ->sum(function ($g) {
                    return (float) ($g->total_price ?? $g->price ?? $g->service->price ?? 0);
                });
            $chartTotals[] = $sumToko + $sumGrooming;
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

        // Rincian pesanan yang tanggal pesanannya hari ini DAN sudah dibayar lunas
        $pesananPaidHariIni = Pesanan::with(['pelanggan', 'details.produk', 'pembayaran', 'pengiriman'])
            ->whereDate('tanggal_pesanan', $today)
            ->whereHas('pembayaran', function ($p) {
                $p->where('status_bayar', 'paid');
            })
            ->latest('id_pesanan')
            ->get();

        $subtotalToko = (float) $pesananPaidHariIni->sum('total');

        $groomingPaidHariIni = GroomingBooking::with(['pelanggan', 'service'])
            ->whereDate('created_at', $today)
            ->whereIn('status', ['terjadwal', 'dikonfirmasi', 'selesai'])
            ->latest('id')
            ->get();

        $subtotalGrooming = (float) $groomingPaidHariIni->sum(function ($g) {
            return (float) ($g->total_price ?? $g->price ?? $g->service->price ?? 0);
        });

        $totalPendapatanHariIni = $subtotalToko + $subtotalGrooming;
        $tanggalFormatted = $today->translatedFormat('d F Y');

        $pdf = Pdf::loadView('admin.dashboard.invoice_pdf', compact(
            'pesananPaidHariIni',
            'groomingPaidHariIni',
            'subtotalToko',
            'subtotalGrooming',
            'totalPendapatanHariIni',
            'tanggalFormatted'
        ))->setPaper('a4', 'portrait');

        return $pdf->download('INVOICE-HARIAN-RERE-PETSHOP-' . date('Ymd') . '.pdf');
    }
}
