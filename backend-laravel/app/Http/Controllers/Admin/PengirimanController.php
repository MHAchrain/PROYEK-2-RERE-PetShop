<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Pengiriman;
use Illuminate\Http\Request;
use Spatie\SimpleExcel\SimpleExcelWriter;

class PengirimanController extends Controller
{
    public function index(Request $request)
    {
        // Hanya tampilkan pengiriman dari pesanan yang statusnya 'dikirim' atau 'selesai'
        $query = Pengiriman::with(['pesanan.pelanggan'])
            ->whereHas('pesanan', function ($q) {
                $q->whereIn('status_pesanan', ['dikirim', 'selesai']);
            });

        if ($request->filled('kurir')) {
            $query->where('kurir', $request->kurir);
        }

        if ($request->filled('status_kirim')) {
            $query->where('status_kirim', $request->status_kirim);
        }

        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('kurir', 'like', "%{$search}%")
                  ->orWhere('resi', 'like', "%{$search}%")
                  ->orWhereHas('pesanan', function ($sub) use ($search) {
                      $sub->where('id_pesanan', 'like', "%{$search}%")
                          ->orWhere('alamat_kirim', 'like', "%{$search}%")
                          ->orWhereHas('pelanggan', function ($p) use ($search) {
                              $p->where('nama', 'like', "%{$search}%");
                          });
                  });
            });
        }

        $pengirimans = $query->latest('id_pengiriman')->paginate(15)->withQueryString();

        return view('admin.pengiriman.index', compact('pengirimans'));
    }

    public function update(Request $request, Pengiriman $pengiriman)
    {
        $validated = $request->validate([
            'kurir' => ['required', 'in:Internal,JNE,Ojol'],
            'resi' => ['nullable', 'string', 'max:100'],
            'status_kirim' => ['required', 'string', 'max:50'],
        ]);

        $pengiriman->update($validated);

        if (in_array($validated['status_kirim'], ['terkirim', 'diterima']) && $pengiriman->pesanan && $pengiriman->pesanan->status_pesanan !== 'selesai') {
            $pengiriman->pesanan->update(['status_pesanan' => 'selesai']);
        } elseif ($validated['status_kirim'] === 'dikirim' && $pengiriman->pesanan && $pengiriman->pesanan->status_pesanan !== 'dikirim') {
            $pengiriman->pesanan->update(['status_pesanan' => 'dikirim']);
        }

        return back()->with('success', 'Status pengiriman dan kurir berhasil diperbarui!');
    }

    public function export()
    {
        $fileName = 'data_pengiriman_' . date('Y-m-d_His') . '.xlsx';
        $filePath = storage_path('app/temp_' . $fileName);

        $writer = SimpleExcelWriter::create($filePath);

        Pengiriman::with(['pesanan.pelanggan'])
            ->whereHas('pesanan', function ($q) {
                $q->whereIn('status_pesanan', ['dikirim', 'selesai']);
            })
            ->chunk(100, function ($pengirimans) use ($writer) {
                foreach ($pengirimans as $p) {
                    $writer->addRow([
                        'ID Pengiriman' => $p->id_pengiriman,
                        'Kode Pesanan' => $p->pesanan ? $p->pesanan->kode_pesanan : '-',
                        'Penerima' => $p->pesanan->pelanggan->nama ?? '-',
                        'Alamat Kirim' => $p->pesanan->alamat_kirim ?? '-',
                        'Kurir' => $p->kurir,
                        'Nomor Resi' => $p->resi ?? '-',
                        'Status Pengiriman' => $p->status_kirim,
                        'Tanggal Kirim' => (string) $p->tanggal_kirim,
                    ]);
                }
            });

        return response()->download($filePath, $fileName)->deleteFileAfterSend(true);
    }
}
