<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\PesananDetail;
use Illuminate\Http\Request;
use Spatie\SimpleExcel\SimpleExcelWriter;

class PesananDetailController extends Controller
{
    public function index(Request $request)
    {
        $query = PesananDetail::with(['pesanan.pelanggan', 'produk']);

        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('id_pesanan', 'like', "%{$search}%")
                  ->orWhereHas('produk', function ($p) use ($search) {
                      $p->where('nama_produk', 'like', "%{$search}%");
                  })
                  ->orWhereHas('pesanan.pelanggan', function ($c) use ($search) {
                      $c->where('nama', 'like', "%{$search}%");
                  });
            });
        }

        $details = $query->latest('id_detail')->paginate(15)->withQueryString();

        return view('admin.pesanan-detail.index', compact('details'));
    }

    public function export()
    {
        $fileName = 'item_penjualan_detail_' . date('Y-m-d_His') . '.xlsx';
        $filePath = storage_path('app/temp_' . $fileName);

        $writer = SimpleExcelWriter::create($filePath);

        PesananDetail::with(['pesanan.pelanggan', 'produk'])->chunk(200, function ($details) use ($writer) {
            foreach ($details as $d) {
                $writer->addRow([
                    'ID Detail' => $d->id_detail,
                    'Kode Pesanan' => $d->pesanan ? $d->pesanan->kode_pesanan : '-',
                    'Pelanggan' => $d->pesanan->pelanggan->nama ?? '-',
                    'Produk' => $d->produk->nama_produk ?? '-',
                    'Jumlah (Qty)' => (int) $d->jumlah,
                    'Harga Satuan (Rp)' => (float) $d->harga_satuan,
                    'Subtotal (Rp)' => (float) $d->subtotal,
                ]);
            }
        });

        return response()->download($filePath, $fileName)->deleteFileAfterSend(true);
    }
}
