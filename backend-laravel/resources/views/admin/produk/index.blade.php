@extends('admin.layouts.app')

@section('title', 'Katalog Produk')
@section('page_title', 'Manajemen Katalog Produk')

@section('content')
<div class="space-y-6">

    <!-- BARIS FILTER, CARI & TOMBOL AKSI -->
    <div class="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-4">
        <!-- Pencarian & Filter Kategori -->
        <form method="GET" action="{{ route('admin.produk.index') }}" class="flex flex-1 flex-wrap items-center gap-3">
            <div class="relative flex-1 min-w-[220px]">
                <span class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
                    <i class="fa-solid fa-magnifying-glass text-xs"></i>
                </span>
                <input type="text" name="search" value="{{ request('search') }}" placeholder="Cari nama produk / deskripsi..."
                    class="w-full pl-9 pr-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-brand-600 focus:border-brand-600 bg-white">
            </div>

            <select name="id_kategori" onchange="this.form.submit()" class="py-2 px-3 rounded-xl border border-slate-200 text-xs text-slate-700 bg-white focus:outline-none focus:ring-2 focus:ring-brand-600">
                <option value="">Semua Kategori</option>
                @foreach($kategoris as $k)
                    <option value="{{ $k->id_kategori }}" {{ request('id_kategori') == $k->id_kategori ? 'selected' : '' }}>
                        {{ $k->nama_kategori }}
                    </option>
                @endforeach
            </select>

            <!-- Sort Stok & Harga -->
            <select name="sort" onchange="this.form.submit()" class="py-2 px-3 rounded-xl border border-slate-200 text-xs font-semibold text-slate-700 bg-white focus:outline-none focus:ring-2 focus:ring-brand-600">
                <option value="">Urutkan: Standar</option>
                <option value="stok_desc" {{ request('sort') == 'stok_desc' ? 'selected' : '' }}>Stok: Terbanyak &rarr; Sedikit</option>
                <option value="stok_asc" {{ request('sort') == 'stok_asc' ? 'selected' : '' }}>Stok: Paling Sedikit &rarr; Banyak</option>
                <option value="harga_desc" {{ request('sort') == 'harga_desc' ? 'selected' : '' }}>Harga: Tertinggi &rarr; Termurah</option>
                <option value="harga_asc" {{ request('sort') == 'harga_asc' ? 'selected' : '' }}>Harga: Termurah &rarr; Tertinggi</option>
            </select>

            @if(request('search') || request('id_kategori') || request('sort'))
                <a href="{{ route('admin.produk.index') }}" class="text-xs text-slate-500 hover:text-brand-600 font-semibold px-2">Reset</a>
            @endif
        </form>

        <!-- Tombol Aksi: Import, Export, Tambah -->
        <div class="flex items-center gap-2">
            <!-- Modal Trigger: Import Excel -->
            <button onclick="document.getElementById('importModal').classList.remove('hidden')" class="px-3.5 py-2 rounded-xl border border-slate-200 bg-white hover:bg-slate-50 text-slate-700 font-bold text-xs flex items-center gap-2 shadow-sm transition">
                <i class="fa-solid fa-file-import text-slate-500"></i>
                <span>Import Excel</span>
            </button>

            <!-- Export Excel -->
            <a href="{{ route('admin.produk.export') }}" class="px-3.5 py-2 rounded-xl border border-emerald-200 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 font-bold text-xs flex items-center gap-2 shadow-sm transition">
                <i class="fa-solid fa-file-excel text-emerald-600"></i>
                <span>Export Excel</span>
            </a>

            <!-- Tambah Produk Baru -->
            <a href="{{ route('admin.produk.create') }}" class="px-4 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-bold text-xs flex items-center gap-2 shadow-md shadow-brand-600/20 transition">
                <i class="fa-solid fa-plus text-xs"></i>
                <span>Tambah Produk</span>
            </a>
        </div>
    </div>

    <!-- TABEL PRODUK -->
    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left text-sm text-slate-600">
                <thead class="bg-slate-50 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-200">
                    <tr>
                        <th class="py-3 px-6 w-16">Foto</th>
                        <th class="py-3 px-6">Nama Produk</th>
                        <th class="py-3 px-6">Kategori</th>
                        <th class="py-3 px-6">
                            <a href="{{ request()->fullUrlWithQuery(['sort' => request('sort') == 'harga_desc' ? 'harga_asc' : 'harga_desc']) }}" class="inline-flex items-center gap-1 hover:text-brand-600 transition">
                                <span>Harga</span>
                                <i class="fa-solid fa-sort text-[10px] text-slate-400"></i>
                            </a>
                        </th>
                        <th class="py-3 px-6">
                            <a href="{{ request()->fullUrlWithQuery(['sort' => request('sort') == 'stok_desc' ? 'stok_asc' : 'stok_desc']) }}" class="inline-flex items-center gap-1 hover:text-brand-600 transition">
                                <span>Stok</span>
                                <i class="fa-solid fa-sort text-[10px] text-slate-400"></i>
                            </a>
                        </th>
                        <th class="py-3 px-6 text-right w-32">Aksi</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    @forelse($produks as $p)
                        <tr class="hover:bg-slate-50/80 transition">
                            <td class="py-3 px-6">
                                <div class="w-12 h-12 rounded-xl border border-slate-200 overflow-hidden bg-slate-50 shrink-0 flex items-center justify-center">
                                    @if($p->foto)
                                        <img src="{{ asset('storage/' . $p->foto) }}" alt="{{ $p->nama_produk }}" class="w-full h-full object-cover" onerror="this.src='https://placehold.co/100x100?text=No+Foto'">
                                    @else
                                        <i class="fa-regular fa-image text-slate-300 text-lg"></i>
                                    @endif
                                </div>
                            </td>
                            <td class="py-3 px-6">
                                <p class="font-bold text-slate-900 leading-snug">{{ $p->nama_produk }}</p>
                                <p class="text-xs text-slate-400 line-clamp-1 mt-0.5">{{ $p->deskripsi ?? 'Tidak ada deskripsi' }}</p>
                            </td>
                            <td class="py-3 px-6 text-xs font-semibold text-slate-700">
                                <span class="bg-slate-100 px-2.5 py-1 rounded-lg border border-slate-200">
                                    {{ $p->kategori->nama_kategori ?? '-' }}
                                </span>
                            </td>
                            <td class="py-3 px-6 font-bold text-slate-900">
                                Rp {{ number_format($p->harga, 0, ',', '.') }}
                            </td>
                            <td class="py-3 px-6">
                                <span class="px-2.5 py-1 rounded-full text-xs font-bold {{ $p->stok <= 5 ? ($p->stok == 0 ? 'bg-red-100 text-red-700' : 'bg-amber-100 text-amber-700') : 'bg-emerald-50 text-emerald-700' }}">
                                    {{ $p->stok }} unit
                                </span>
                            </td>
                            <td class="py-3 px-6 text-right space-x-1">
                                <a href="{{ route('admin.produk.edit', $p->id_produk) }}" class="inline-flex items-center justify-center w-8 h-8 rounded-lg text-slate-600 hover:text-brand-600 hover:bg-brand-50 transition" title="Edit Produk">
                                    <i class="fa-solid fa-pen-to-square text-xs"></i>
                                </a>
                                <form action="{{ route('admin.produk.destroy', $p->id_produk) }}" method="POST" class="inline-block" onsubmit="return confirm('Yakin ingin menghapus produk ini?')">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit" class="inline-flex items-center justify-center w-8 h-8 rounded-lg text-slate-400 hover:text-red-600 hover:bg-red-50 transition" title="Hapus Produk">
                                        <i class="fa-solid fa-trash-can text-xs"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="6" class="text-center py-10 text-slate-400 text-sm">
                                Belum ada data produk yang ditemukan.
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        @if($produks->hasPages())
            <div class="p-4 border-t border-slate-200 bg-slate-50">
                {{ $produks->links() }}
            </div>
        @endif
    </div>

</div>

<!-- MODAL IMPORT EXCEL -->
<div id="importModal" class="hidden fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
    <div class="bg-white rounded-3xl border border-slate-200 shadow-2xl max-w-md w-full p-6 space-y-4">
        <div class="flex items-center justify-between pb-3 border-b border-slate-100">
            <h3 class="text-base font-bold text-slate-900 flex items-center gap-2">
                <i class="fa-solid fa-file-excel text-emerald-600"></i>
                <span>Import Produk dari Excel</span>
            </h3>
            <button onclick="document.getElementById('importModal').classList.add('hidden')" class="text-slate-400 hover:text-slate-600">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <form action="{{ route('admin.produk.import') }}" method="POST" enctype="multipart/form-data" class="space-y-4">
            @csrf
            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase mb-2">Pilih File (.xlsx / .csv)</label>
                <input type="file" name="file" required accept=".xlsx,.csv,.xls"
                    class="w-full text-xs text-slate-500 file:mr-3 file:py-2 file:px-4 file:rounded-xl file:border-0 file:text-xs file:font-bold file:bg-brand-50 file:text-brand-700 hover:file:bg-brand-100 border border-slate-200 rounded-xl p-2 cursor-pointer">
                <p class="text-[11px] text-slate-400 mt-2">
                    Kolom yang didukung: <strong>Nama Produk, Kategori, Harga (Rp), Stok, Deskripsi</strong>.
                </p>
            </div>

            <div class="flex items-center justify-end gap-2 pt-3 border-t border-slate-100">
                <button type="button" onclick="document.getElementById('importModal').classList.add('hidden')" class="px-4 py-2 rounded-xl text-xs font-bold text-slate-600 hover:bg-slate-100">
                    Batal
                </button>
                <button type="submit" class="px-4 py-2 rounded-xl text-xs font-bold bg-brand-600 hover:bg-brand-700 text-white shadow-md shadow-brand-600/20">
                    Upload & Proses
                </button>
            </div>
        </form>
    </div>
</div>
@endsection
