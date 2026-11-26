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
        $query = Pesanan::with(['pelanggan', 'pembayaran', 'pengiriman', 'details.produk']);

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
        return response()->json([
            'id_pesanan' => $pesanan->id_pesanan,
            'kode_pesanan' => $pesanan->kode_pesanan,
            'tanggal' => $pesanan->tanggal_pesanan ?? ($pesanan->created_at ? $pesanan->created_at->format('d M Y, H:i') : '-'),
            'status_pesanan' => $pesanan->status_pesanan,
            'status_label' => ucfirst(str_replace('_', ' ', $pesanan->status_pesanan)),
            'total' => (float) $pesanan->total,
            'total_formatted' => 'Rp ' . number_format($pesanan->total, 0, ',', '.'),
            'alamat_kirim' => $pesanan->alamat_kirim,
            'no_telp' => $pesanan->no_telp ?? $pesanan->pelanggan->no_hp ?? '-',
            'pelanggan' => [
                'nama' => $pesanan->pelanggan->nama ?? 'Customer',
                'email' => $pesanan->pelanggan->email ?? '-',
                'no_hp' => $pesanan->pelanggan->no_hp ?? '-',
            ],
            'pembayaran' => [
                'metode_bayar' => strtoupper($pesanan->pembayaran->metode_bayar ?? 'Online / Gateway'),
                'status_bayar' => $pesanan->pembayaran->status_bayar ?? 'pending',
                'snap_token' => $pesanan->pembayaran->snap_token ?? '-',
                'waktu_bayar' => $pesanan->pembayaran->waktu_bayar ?? '-',
            ],
            'pengiriman' => [
                'kurir' => $pesanan->pengiriman->kurir ?? 'Internal',
                'resi' => $pesanan->pengiriman->resi ?? '',
                'status_kirim' => $pesanan->pengiriman->status_kirim ?? 'pending',
            ],
            'items' => $pesanan->details->map(function ($d) {
                $qty = (int) ($d->qty ?? $d->jumlah ?? 1);
                return [
                    'nama_produk' => $d->produk->nama_produk ?? 'Produk Dihapus',
                    'foto' => $d->produk && $d->produk->foto ? asset('storage/' . $d->produk->foto) : null,
                    'jumlah' => $qty,
                    'harga_satuan' => 'Rp ' . number_format($d->harga_satuan, 0, ',', '.'),
                    'subtotal' => 'Rp ' . number_format($d->subtotal, 0, ',', '.'),
                ];
            }),
        ]);
    }

    public function updateStatus(Request $request, Pesanan $pesanan)
    {
        $validated = $request->validate([
            'status_pesanan' => ['required', 'in:baru,menunggu_verifikasi,diproses,dikirim,selesai,batal'],
            'kurir' => ['nullable', 'in:Internal,JNE,Ojol'],
            'resi' => ['nullable', 'string', 'max:100'],
            'status_bayar' => ['nullable', 'in:pending,paid,cancel'],
        ]);

        $statusPesanan = $validated['status_pesanan'];

        // 1. Update Status Pembayaran (Jika QRIS sudah PAID, status pembayaran TERKUNCI & tidak boleh diubah)
        $pembayaranExisting = $pesanan->pembayaran;
        $isQrisPaid = $pembayaranExisting 
            && stripos($pembayaranExisting->metode_bayar ?? '', 'qris') !== false 
            && in_array(strtolower($pembayaranExisting->status_bayar ?? ''), ['paid', 'dibayar']);

        if (! $isQrisPaid && $request->filled('status_bayar')) {
            $statusBayar = $request->status_bayar;
            $pembayaran = Pembayaran::firstOrNew(['id_pesanan' => $pesanan->id_pesanan]);
            $pembayaran->status_bayar = $statusBayar;
            if ($statusBayar === 'paid') {
                if (empty($pembayaran->waktu_bayar)) {
                    $pembayaran->waktu_bayar = now();
                }
                // Jika paid diupdate manual lewat admin, beri label metode MANUAL
                $pembayaran->metode_bayar = 'MANUAL';
            } elseif (in_array(strtolower($statusBayar), ['cancel', 'cancelled', 'failed', 'gagal'])) {
                // Jika pembayaran FAILED / CANCEL, otomatis status pesanan menjadi BATAL!
                $statusPesanan = 'batal';
            }
            if (empty($pembayaran->jumlah_bayar)) {
                $pembayaran->jumlah_bayar = $pesanan->total;
            }
            $pembayaran->save();
        }

        $pesanan->update(['status_pesanan' => $statusPesanan]);

        // 2. Jika status diubah menjadi 'dikirim', pastikan record pengiriman ada
        if ($validated['status_pesanan'] === 'dikirim') {
            $existing = Pengiriman::where('id_pesanan', $pesanan->id_pesanan)->first();
            $kurir = $request->input('kurir', $existing?->kurir ?? 'Internal');
            $resi = $request->input('resi', $existing?->resi);
            
            // Generate resi otomatis jika belum ada sama sekali
            if (empty($resi)) {
                $randomDigits = mt_rand(100000, 999999);
                $resi = match ($kurir) {
                    'JNE' => 'JNE' . date('ymd') . $randomDigits,
                    'Ojol' => 'GRAB-' . date('Hi') . '-' . $randomDigits,
                    default => 'RERE-INT-' . date('ymd') . '-' . $pesanan->id_pesanan,
                };
            }

            Pengiriman::updateOrCreate(
                ['id_pesanan' => $pesanan->id_pesanan],
                [
                    'kurir' => $kurir,
                    'resi' => $resi,
                    'status_kirim' => 'dikirim',
                    'tanggal_kirim' => $existing?->tanggal_kirim ?? now(),
                ]
            );
        }

        return back()->with('success', 'Status pesanan dan pembayaran berhasil diperbarui!');
    }

    public function updatePengiriman(Request $request, Pesanan $pesanan)
    {
        $validated = $request->validate([
            'kurir' => ['required', 'in:Internal,JNE,Ojol'],
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

        if ($validated['status_kirim'] === 'dikirim' && $pesanan->status_pesanan !== 'dikirim') {
            $pesanan->update(['status_pesanan' => 'dikirim']);
        } elseif ($validated['status_kirim'] === 'terkirim' && $pesanan->status_pesanan !== 'selesai') {
            $pesanan->update(['status_pesanan' => 'selesai']);
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
