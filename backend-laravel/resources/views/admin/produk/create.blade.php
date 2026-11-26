@extends('admin.layouts.app')

@section('title', 'Tambah Produk Baru')
@section('page_title', 'Tambah Produk Baru')

@section('content')
<div class="max-w-2xl mx-auto">
    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm p-8">
        <form action="{{ route('admin.produk.store') }}" method="POST" enctype="multipart/form-data" class="space-y-5">
            @csrf

            <!-- Nama Produk -->
            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Nama Produk <span class="text-red-500">*</span></label>
                <input type="text" name="nama_produk" value="{{ old('nama_produk') }}" required placeholder="Contoh: Whiskas Tuna 1.2kg"
                    class="w-full px-4 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-brand-600 focus:border-brand-600">
            </div>

            <!-- Kategori -->
            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Kategori <span class="text-red-500">*</span></label>
                <select name="id_kategori" required class="w-full px-4 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-brand-600">
                    <option value="">Pilih Kategori Produk</option>
                    @foreach($kategoris as $k)
                        <option value="{{ $k->id_kategori }}" {{ old('id_kategori') == $k->id_kategori ? 'selected' : '' }}>
                            {{ $k->nama_kategori }}
                        </option>
                    @endforeach
                </select>
            </div>

            <!-- Harga & Stok Grid -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Harga (Rp) <span class="text-red-500">*</span></label>
                    <input type="number" name="harga" value="{{ old('harga') }}" required min="0" placeholder="50000"
                        class="w-full px-4 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-brand-600">
                </div>
                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Stok Barang <span class="text-red-500">*</span></label>
                    <input type="number" name="stok" value="{{ old('stok', 10) }}" required min="0" placeholder="10"
                        class="w-full px-4 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-brand-600">
                </div>
            </div>

            <!-- Deskripsi -->
            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Deskripsi Produk</label>
                <textarea name="deskripsi" rows="4" placeholder="Tuliskan spesifikasi, nutrisi, atau kegunaan produk..."
                    class="w-full px-4 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-brand-600">{{ old('deskripsi') }}</textarea>
            </div>

            <!-- Upload Foto -->
            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Foto Produk</label>
                <input type="file" name="foto" accept="image/*"
                    class="w-full text-xs text-slate-500 file:mr-4 file:py-2.5 file:px-4 file:rounded-xl file:border-0 file:text-xs file:font-bold file:bg-brand-50 file:text-brand-700 hover:file:bg-brand-100 border border-slate-200 rounded-xl p-2 cursor-pointer">
                <p class="text-[11px] text-slate-400 mt-1">Format: JPG, PNG, WEBP. Maks 4MB.</p>
            </div>

            <!-- Tombol Submit -->
            <div class="flex items-center justify-end gap-3 pt-4 border-t border-slate-100">
                <a href="{{ route('admin.produk.index') }}" class="px-5 py-2.5 rounded-xl text-xs font-bold text-slate-600 hover:bg-slate-100 transition">
                    Batal
                </a>
                <button type="submit" class="px-6 py-2.5 rounded-xl text-xs font-bold bg-brand-600 hover:bg-brand-700 text-white shadow-md shadow-brand-600/20 transition">
                    Simpan Produk
                </button>
            </div>
        </form>
    </div>
</div>
@endsection
