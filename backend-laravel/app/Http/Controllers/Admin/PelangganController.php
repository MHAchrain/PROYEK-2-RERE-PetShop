<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Pelanggan;
use Illuminate\Http\Request;
use Spatie\SimpleExcel\SimpleExcelWriter;

class PelangganController extends Controller
{
    public function index(Request $request)
    {
        $query = Pelanggan::query();

        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('nama', 'like', "%{$search}%")
                  ->orWhere('email', 'like', "%{$search}%")
                  ->orWhere('no_hp', 'like', "%{$search}%")
                  ->orWhere('alamat', 'like', "%{$search}%");
            });
        }

        $pelanggans = $query->latest('id_pelanggan')->paginate(15)->withQueryString();

        return view('admin.pelanggan.index', compact('pelanggans'));
    }

    public function show(Pelanggan $pelanggan)
    {
        $pelanggan->load(['groomingBookings.service']);
        return view('admin.pelanggan.show', compact('pelanggan'));
    }

    public function export()
    {
        $fileName = 'data_pelanggan_' . date('Y-m-d_His') . '.xlsx';
        $filePath = storage_path('app/temp_' . $fileName);

        $writer = SimpleExcelWriter::create($filePath);

        Pelanggan::chunk(200, function ($pelanggans) use ($writer) {
            foreach ($pelanggans as $p) {
                $writer->addRow([
                    'Kode Pelanggan' => $p->kode_pelanggan,
                    'Nama' => $p->nama,
                    'Email' => $p->email,
                    'No HP / WA' => $p->no_hp,
                    'Alamat' => $p->alamat,
                    'Terdaftar Pada' => (string) $p->created_at,
                ]);
            }
        });

        return response()->download($filePath, $fileName)->deleteFileAfterSend(true);
    }
}
