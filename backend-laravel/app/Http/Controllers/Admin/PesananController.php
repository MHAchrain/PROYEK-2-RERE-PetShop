<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Pembayaran;
use App\Models\Pengiriman;
use App\Models\Pesanan;
use Illuminate\Http\Request;
use Spatie\SimpleExcel\SimpleExcelWriter;

class PesananController extends Controller
{
    public function index(Request $request)
    {
        $query = Pesanan::with(['pelanggan', 'pembayaran', 'pengiriman']);

        if ($request->filled('status')) {
            $query->where('status_pesanan', $request->status);
        }

        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('id_pesanan', 'like', "%{$search}%")
                  ->orWhere('alamat_kirim', 'like', "%{$search}%")
                  ->orWhere('no_telp', 'like', "%{$search}%")
                  ->orWhereHas('pelanggan', function ($sub) use ($search) {
                      $sub->where('nama', 'like', "%{$search}%")
                          ->orWhere('email', 'like', "%{$search}%")
                          ->orWhere('no_hp', 'like', "%{$search}%");
                  });
            });
        }

        $pesanans = $query->latest('id_pesanan')->paginate(15)->withQueryString();

        return view('admin.pesanan.index', compact('pesanans'));
    }

    public function show(Pesanan $pesanan)
    {
        $pesanan->load(['pelanggan', 'details.produk', 'pembayaran', 'pengiriman']);
        return view('admin.pesanan.show', compact('pesanan'));
    }

    public function updateStatus(Request $request, Pesanan $pesanan)
    {
        $validated = $request->validate([
            'status_pesanan' => ['required', 'in:baru,menunggu_verifikasi,diproses,dikirim,selesai,batal'],
        ]);

        $pesanan->update($validated);

        return back()->with('success', 'Status pesanan berhasil diperbarui!');
    }

    public function updatePengiriman(Request $request, Pesanan $pesanan)
    {
        $validated = $request->validate([
            'kurir' => ['required', 'string', 'max:50'],
            'resi' => ['nullable', 'string', 'max:100'],
            'status_kirim' => ['required', 'string', 'max:50'],
        ]);

        if ($pesanan->pengiriman) {
            $pesanan->pengiriman->update($validated);
        } else {
            Pengiriman::create(array_merge($validated, [
                'id_pesanan' => $pesanan->id_pesanan,
                'tanggal_kirim' => now(),
            ]));
        }

        if (!empty($validated['resi']) && $pesanan->status_pesanan !== 'dikirim') {
            $pesanan->update(['status_pesanan' => 'dikirim']);
        }

        return back()->with('success', 'Informasi pengiriman berhasil disimpan!');
    }

    public function export()
    {
        $fileName = 'rekap_pesanan_' . date('Y-m-d_His') . '.xlsx';
        $filePath = storage_path('app/temp_' . $fileName);

        $writer = SimpleExcelWriter::create($filePath);

        Pesanan::with(['pelanggan', 'pembayaran', 'pengiriman'])->chunk(100, function ($pesanans) use ($writer) {
            foreach ($pesanans as $p) {
                $writer->addRow([
                    'Kode Pesanan' => $p->kode_pesanan,
                    'Tanggal' => (string) $p->tanggal_pesanan,
                    'Pelanggan' => $p->pelanggan->nama ?? '-',
                    'No Telepon' => $p->no_telp ?? $p->pelanggan->no_hp ?? '-',
                    'Alamat Kirim' => $p->alamat_kirim,
                    'Total Tagihan (Rp)' => (float) $p->total,
                    'Status Pesanan' => (string) $p->status_pesanan,
                    'Metode Bayar' => $p->pembayaran->metode_bayar ?? '-',
                    'Status Bayar' => $p->pembayaran->status_bayar ?? '-',
                    'Kurir' => $p->pengiriman->kurir ?? '-',
                    'No Resi' => $p->pengiriman->resi ?? '-',
                ]);
            }
        });

        return response()->download($filePath, $fileName)->deleteFileAfterSend(true);
    }
}
