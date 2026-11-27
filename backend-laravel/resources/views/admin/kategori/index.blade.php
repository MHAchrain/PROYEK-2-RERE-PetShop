@extends('admin.layouts.app')

@section('title', 'Kategori Produk')
@section('page_title', 'Manajemen Kategori Produk')

@section('content')
<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

    <!-- FORM TAMBAH KATEGORI (1 Col) -->
    <div class="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm h-fit">
        <h3 class="text-sm font-bold text-slate-900 mb-1">Tambah Kategori Baru</h3>
        <p class="text-xs text-slate-400 mb-4">Kelompokkan produk agar mudah ditemukan pembeli</p>

        <form action="{{ route('admin.kategori.store') }}" method="POST" class="space-y-4">
            @csrf
            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Nama Kategori</label>
                <input type="text" name="nama_kategori" value="{{ old('nama_kategori') }}" required placeholder="Contoh: Makanan Kucing, Shampo, dll"
                    class="w-full px-4 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-brand-600">
            </div>

            <button type="submit" class="w-full py-2.5 px-4 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-bold text-xs shadow-md shadow-brand-600/20 transition flex items-center justify-center gap-2">
                <i class="fa-solid fa-plus text-xs"></i>
                <span>Simpan Kategori</span>
            </button>
        </form>
    </div>

    <!-- TABEL LIST KATEGORI (2 Col) -->
    <div class="lg:col-span-2 bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-5 border-b border-slate-200 flex items-center justify-between">
            <h3 class="text-sm font-bold text-slate-900">Daftar Kategori</h3>
            <a href="{{ route('admin.kategori.export') }}" class="px-3 py-1.5 rounded-xl border border-emerald-200 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 font-bold text-xs flex items-center gap-2 transition">
                <i class="fa-solid fa-file-excel text-emerald-600"></i>
                <span>Export Excel</span>
            </a>
        </div>

        <div class="overflow-x-auto">
            <table class="w-full text-left text-sm text-slate-600">
                <thead class="bg-slate-50 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-200">
                    <tr>
                        <th class="py-3 px-6">Nama Kategori</th>
                        <th class="py-3 px-6">Jumlah Produk</th>
                        <th class="py-3 px-6 text-right w-28">Aksi</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    @forelse($kategoris as $k)
                        <tr class="hover:bg-slate-50/80 transition">
                            <td class="py-3.5 px-6 font-bold text-slate-900">
                                {{ $k->nama_kategori }}
                            </td>
                            <td class="py-3.5 px-6">
                                <span class="bg-slate-100 text-slate-700 px-2.5 py-1 rounded-full text-xs font-semibold">
                                    {{ $k->produks_count }} produk
                                </span>
                            </td>
                            <td class="py-3.5 px-6 text-right">
                                <form action="{{ route('admin.kategori.destroy', $k->id_kategori) }}" method="POST" class="inline-block" onsubmit="return confirm('Hapus kategori ini?')">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit" class="w-8 h-8 rounded-lg text-slate-400 hover:text-red-600 hover:bg-red-50 inline-flex items-center justify-center transition" title="Hapus Kategori">
                                        <i class="fa-solid fa-trash-can text-xs"></i>
                                    </button>
                                </form>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="3" class="text-center py-8 text-slate-400 text-sm">
                                Belum ada kategori yang dibuat.
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        @if($kategoris->hasPages())
            <div class="p-4 border-t border-slate-200 bg-slate-50">
                {{ $kategoris->links() }}
            </div>
        @endif
    </div>

</div>
@endsection
