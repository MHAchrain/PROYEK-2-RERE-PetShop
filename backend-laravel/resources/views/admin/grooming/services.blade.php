@extends('admin.layouts.app')

@section('title', 'Daftar Paket Grooming')
@section('page_title', 'Manajemen Paket Layanan Grooming')

@section('content')
<div class="space-y-6">

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- FORM TAMBAH LAYANAN (1 Col) -->
        <div class="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm h-fit">
            <h3 class="text-sm font-bold text-slate-900 mb-1">Tambah Paket Baru</h3>
            <p class="text-xs text-slate-400 mb-4">Buat jenis perawatan atau paket grooming</p>

            <form action="{{ route('admin.grooming.service.store') }}" method="POST" class="space-y-4">
                @csrf
                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Nama Layanan</label>
                    <input type="text" name="name" required placeholder="Contoh: Basic Grooming, Anti Kutu"
                        class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-900 focus:ring-2 focus:ring-brand-600">
                </div>

                <div class="grid grid-cols-2 gap-3">
                    <div>
                        <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Harga (Rp)</label>
                        <input type="number" name="price" required min="0" placeholder="75000"
                            class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-900 focus:ring-2 focus:ring-brand-600">
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Durasi (Menit)</label>
                        <input type="number" name="duration_minutes" required min="1" value="60"
                            class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-900 focus:ring-2 focus:ring-brand-600">
                    </div>
                </div>

                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Deskripsi Singkat</label>
                    <textarea name="description" rows="3" placeholder="Fasilitas yang didapat..."
                        class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-900 focus:ring-2 focus:ring-brand-600"></textarea>
                </div>

                <label class="flex items-center gap-2 cursor-pointer pt-1">
                    <input type="checkbox" name="is_active" value="1" checked class="w-4 h-4 rounded text-brand-600">
                    <span class="text-xs font-medium text-slate-700">Aktifkan Layanan</span>
                </label>

                <button type="submit" class="w-full py-2.5 px-4 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-bold text-xs shadow-md shadow-brand-600/20 transition flex items-center justify-center gap-2">
                    <i class="fa-solid fa-plus text-xs"></i>
                    <span>Simpan Paket Layanan</span>
                </button>
            </form>
        </div>

        <!-- LIST PAKET GROOMING (2 Col) -->
        <div class="lg:col-span-2 bg-white rounded-2xl border border-slate-200 shadow-sm p-6">
            <h3 class="text-sm font-bold text-slate-900 mb-4">Daftar Paket Grooming yang Terdaftar</h3>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                @forelse($services as $s)
                    <div class="p-4 rounded-xl border border-slate-200 hover:border-brand-200 transition bg-slate-50/50 flex flex-col justify-between">
                        <div>
                            <div class="flex items-center justify-between mb-1">
                                <h4 class="font-bold text-sm text-slate-900">{{ $s->name }}</h4>
                                <span class="px-2 py-0.5 rounded text-[10px] font-bold {{ $s->is_active ? 'bg-emerald-100 text-emerald-700' : 'bg-slate-200 text-slate-600' }}">
                                    {{ $s->is_active ? 'Aktif' : 'Nonaktif' }}
                                </span>
                            </div>
                            <p class="text-xs text-slate-400 line-clamp-2 mt-1">{{ $s->description ?? 'Tidak ada keterangan khusus.' }}</p>
                        </div>
                        <div class="mt-4 pt-3 border-t border-slate-200/80 flex items-center justify-between text-xs">
                            <span class="text-slate-400"><i class="fa-regular fa-clock"></i> {{ $s->duration_minutes }} menit</span>
                            <span class="font-bold text-brand-600 text-sm">Rp {{ number_format($s->price, 0, ',', '.') }}</span>
                        </div>
                    </div>
                @empty
                    <p class="text-xs text-slate-400 col-span-2 text-center py-6">Belum ada paket grooming yang dibuat.</p>
                @endforelse
            </div>
        </div>
    </div>

</div>
@endsection
