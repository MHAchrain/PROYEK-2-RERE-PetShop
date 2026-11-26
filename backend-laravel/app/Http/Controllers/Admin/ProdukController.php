<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Kategori;
use App\Models\Produk;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Spatie\SimpleExcel\SimpleExcelReader;
use Spatie\SimpleExcel\SimpleExcelWriter;

class ProdukController extends Controller
{
    public function index(Request $request)
    {
        $query = Produk::with('kategori');

        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function ($q) use ($search) {
                $q->where('nama_produk', 'like', "%{$search}%")
                  ->orWhere('deskripsi', 'like', "%{$search}%");
            });
        }

        if ($request->filled('id_kategori')) {
            $query->where('id_kategori', $request->id_kategori);
        }

        $produks = $query->latest('id_produk')->paginate(12)->withQueryString();
        $kategoris = Kategori::orderBy('nama_kategori')->get();

        return view('admin.produk.index', compact('produks', 'kategoris'));
    }

    public function create()
    {
        $kategoris = Kategori::orderBy('nama_kategori')->get();
        return view('admin.produk.create', compact('kategoris'));
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'nama_produk' => ['required', 'string', 'max:255'],
            'id_kategori' => ['required', 'exists:kategori,id_kategori'],
            'harga' => ['required', 'numeric', 'min:0'],
            'stok' => ['required', 'integer', 'min:0'],
            'deskripsi' => ['nullable', 'string'],
            'foto' => ['nullable', 'image', 'mimes:jpeg,png,jpg,webp', 'max:4096'],
        ]);

        if ($request->hasFile('foto')) {
            $path = $request->file('foto')->store('produk', 'public');
            $validated['foto'] = $path;
        }

        Produk::create($validated);

        return redirect()->route('admin.produk.index')
            ->with('success', 'Produk baru berhasil ditambahkan!');
    }

    public function edit(Produk $produk)
    {
        $kategoris = Kategori::orderBy('nama_kategori')->get();
        return view('admin.produk.edit', compact('produk', 'kategoris'));
    }

    public function update(Request $request, Produk $produk)
    {
        $validated = $request->validate([
            'nama_produk' => ['required', 'string', 'max:255'],
            'id_kategori' => ['required', 'exists:kategori,id_kategori'],
            'harga' => ['required', 'numeric', 'min:0'],
            'stok' => ['required', 'integer', 'min:0'],
            'deskripsi' => ['nullable', 'string'],
            'foto' => ['nullable', 'image', 'mimes:jpeg,png,jpg,webp', 'max:4096'],
        ]);

        if ($request->hasFile('foto')) {
            if ($produk->foto && Storage::disk('public')->exists($produk->foto)) {
                Storage::disk('public')->delete($produk->foto);
            }
            $path = $request->file('foto')->store('produk', 'public');
            $validated['foto'] = $path;
        }

        $produk->update($validated);

        return redirect()->route('admin.produk.index')
            ->with('success', 'Data produk berhasil diperbarui!');
    }

    public function destroy(Produk $produk)
    {
        if ($produk->foto && Storage::disk('public')->exists($produk->foto)) {
            Storage::disk('public')->delete($produk->foto);
        }

        $produk->delete();

        return redirect()->route('admin.produk.index')
            ->with('success', 'Produk berhasil dihapus!');
    }

    /**
     * Export daftar produk ke format Excel (.xlsx)
     */
    public function export()
    {
        $fileName = 'katalog_produk_' . date('Y-m-d_His') . '.xlsx';
        $filePath = storage_path('app/temp_' . $fileName);

        $writer = SimpleExcelWriter::create($filePath);

        Produk::with('kategori')->chunk(200, function ($produks) use ($writer) {
            foreach ($produks as $p) {
                $writer->addRow([
                    'ID Produk' => $p->id_produk,
                    'Nama Produk' => $p->nama_produk,
                    'Kategori' => $p->kategori->nama_kategori ?? '-',
                    'Harga (Rp)' => (float) $p->harga,
                    'Stok' => (int) $p->stok,
                    'Deskripsi' => (string) $p->deskripsi,
                    'Path Foto' => (string) $p->foto,
                ]);
            }
        });

        return response()->download($filePath, $fileName)->deleteFileAfterSend(true);
    }

    /**
     * Import produk dari file Excel (.xlsx / .csv)
     */
    public function import(Request $request)
    {
        $request->validate([
            'file' => ['required', 'file', 'mimes:xlsx,csv,xls', 'max:10240'],
        ], [
            'file.required' => 'Pilih file Excel yang ingin diunggah.',
            'file.mimes' => 'Format file harus berupa .xlsx atau .csv.',
        ]);

        $path = $request->file('file')->getRealPath();

        try {
            $rows = SimpleExcelReader::create($path)->getRows();
            $count = 0;

            foreach ($rows as $row) {
                $namaProduk = trim($row['Nama Produk'] ?? $row['nama_produk'] ?? '');
                if (!$namaProduk) {
                    continue;
                }

                $kategoriNama = trim($row['Kategori'] ?? $row['kategori'] ?? '');
                $kategori = null;
                if ($kategoriNama) {
                    $kategori = Kategori::firstOrCreate(['nama_kategori' => $kategoriNama]);
                }

                $harga = (float) ($row['Harga (Rp)'] ?? $row['harga'] ?? 0);
                $stok = (int) ($row['Stok'] ?? $row['stok'] ?? 0);
                $deskripsi = trim($row['Deskripsi'] ?? $row['deskripsi'] ?? '');

                Produk::updateOrCreate(
                    ['nama_produk' => $namaProduk],
                    [
                        'id_kategori' => $kategori?->id_kategori ?? Kategori::first()?->id_kategori ?? 1,
                        'harga' => $harga,
                        'stok' => $stok,
                        'deskripsi' => $deskripsi,
                    ]
                );

                $count++;
            }

            return redirect()->route('admin.produk.index')
                ->with('success', "Berhasil mengimpor/memperbarui {$count} produk dari file Excel!");
        } catch (\Throwable $e) {
            return redirect()->route('admin.produk.index')
                ->with('error', 'Gagal memproses file Excel: ' . $e->getMessage());
        }
    }
}
