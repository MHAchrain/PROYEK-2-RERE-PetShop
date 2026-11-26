@extends('admin.layouts.app')

@section('title', 'Edit Produk')
@section('page_title', 'Edit Produk: ' . $produk->nama_produk)

@section('content')
<div class="max-w-2xl mx-auto">
    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm p-8">
        <form action="{{ route('admin.produk.update', $produk->id_produk) }}" method="POST" enctype="multipart/form-data" class="space-y-5">
            @csrf
            @method('PUT')

            <!-- Nama Produk -->
            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Nama Produk <span class="text-red-500">*</span></label>
                <input type="text" name="nama_produk" value="{{ old('nama_produk', $produk->nama_produk) }}" required
                    class="w-full px-4 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-brand-600">
            </div>

            <!-- Kategori -->
            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Kategori <span class="text-red-500">*</span></label>
                <select name="id_kategori" required class="w-full px-4 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-brand-600">
                    @foreach($kategoris as $k)
                        <option value="{{ $k->id_kategori }}" {{ old('id_kategori', $produk->id_kategori) == $k->id_kategori ? 'selected' : '' }}>
                            {{ $k->nama_kategori }}
                        </option>
                    @endforeach
                </select>
            </div>

            <!-- Harga & Stok Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Harga (Rp) <span class="text-red-500">*</span></label>
                    <input type="number" name="harga" value="{{ old('harga', $produk->harga) }}" required min="0"
                        class="w-full px-4 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-brand-600">
                </div>
                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Stok Barang <span class="text-red-500">*</span></label>
                    <input type="number" name="stok" value="{{ old('stok', $produk->stok) }}" required min="0"
                        class="w-full px-4 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-brand-600">
                </div>
            </div>

            <!-- Deskripsi -->
            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Deskripsi Produk</label>
                <textarea name="deskripsi" rows="4"
                    class="w-full px-4 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-brand-600">{{ old('deskripsi', $produk->deskripsi) }}</textarea>
            </div>

            <!-- Foto Saat Ini & Upload Foto Baru -->
            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Foto Produk</label>
                @if($produk->foto)
                    <div class="mb-3 flex items-center gap-3">
                        <img src="{{ asset('storage/' . $produk->foto) }}" alt="Preview" class="w-16 h-16 object-cover rounded-xl border border-slate-200 shadow-sm" onerror="this.src='https://placehold.co/100x100?text=No+Foto'">
                        <span class="text-xs text-slate-400">Pilih file baru jika ingin mengganti foto yang ada.</span>
                    </div>
                @endif
                <input type="file" name="foto" accept="image/*"
                    class="w-full text-xs text-slate-500 file:mr-4 file:py-2.5 file:px-4 file:rounded-xl file:border-0 file:text-xs file:font-bold file:bg-brand-50 file:text-brand-700 hover:file:bg-brand-100 border border-slate-200 rounded-xl p-2 cursor-pointer">
            </div>

            <!-- Tombol Submit -->
            <div class="flex items-center justify-end gap-3 pt-4 border-t border-slate-100">
                <a href="{{ route('admin.produk.index') }}" class="px-5 py-2.5 rounded-xl text-xs font-bold text-slate-600 hover:bg-slate-100 transition">
                    Batal
                </a>
                <button type="submit" class="px-6 py-2.5 rounded-xl text-xs font-bold bg-brand-600 hover:bg-brand-700 text-white shadow-md shadow-brand-600/20 transition">
                    Perbarui Produk
                </button>
            </div>
        </form>
    </div>
</div>
@endsection
