<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Kategori;
use Illuminate\Http\Request;
use Spatie\SimpleExcel\SimpleExcelWriter;

class KategoriController extends Controller
{
    public function index()
    {
        $kategoris = Kategori::withCount('produks')->orderBy('nama_kategori')->paginate(15);
        return view('admin.kategori.index', compact('kategoris'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'nama_kategori' => ['required', 'string', 'max:100', 'unique:kategori,nama_kategori'],
        ], [
            'nama_kategori.required' => 'Nama kategori wajib diisi.',
            'nama_kategori.unique' => 'Kategori dengan nama tersebut sudah ada.',
        ]);

        Kategori::create($validated);

        return redirect()->route('admin.kategori.index')
            ->with('success', 'Kategori baru berhasil ditambahkan!');
    }

    public function update(Request $request, Kategori $kategori)
    {
        $validated = $request->validate([
            'nama_kategori' => ['required', 'string', 'max:100', 'unique:kategori,nama_kategori,' . $kategori->id_kategori . ',id_kategori'],
        ]);

        $kategori->update($validated);

        return redirect()->route('admin.kategori.index')
            ->with('success', 'Kategori berhasil diperbarui!');
    }

    public function destroy(Kategori $kategori)
    {
        if ($kategori->produks()->count() > 0) {
            return redirect()->route('admin.kategori.index')
                ->with('error', 'Tidak dapat menghapus kategori yang masih memiliki produk terkait.');
        }

        $kategori->delete();

        return redirect()->route('admin.kategori.index')
            ->with('success', 'Kategori berhasil dihapus!');
    }

    public function export()
    {
        $fileName = 'kategori_produk_' . date('Y-m-d_His') . '.xlsx';
        $filePath = storage_path('app/temp_' . $fileName);

        $writer = SimpleExcelWriter::create($filePath);

        $kategoris = Kategori::withCount('produks')->get();
        foreach ($kategoris as $k) {
            $writer->addRow([
                'ID Kategori' => $k->id_kategori,
                'Nama Kategori' => $k->nama_kategori,
                'Jumlah Produk' => $k->produks_count,
            ]);
        }

        return response()->download($filePath, $fileName)->deleteFileAfterSend(true);
    }
}
