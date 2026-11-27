@extends('admin.layouts.app')

@section('title', 'Layanan Grooming')
@section('page_title', 'Manajemen Layanan & Booking Grooming')

@section('content')
<div class="space-y-8">

    <!-- BAGIAN 1: DAFTAR LAYANAN GROOMING & FORM TAMBAH -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- FORM TAMBAH LAYANAN (1 Col) -->
        <div class="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm h-fit">
            <h3 class="text-sm font-bold text-slate-900 mb-1">Tambah Paket Layanan</h3>
            <p class="text-xs text-slate-400 mb-4">Buat jenis perawatan atau grooming baru</p>

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
                    <span>Simpan Layanan</span>
                </button>
            </form>
        </div>

        <!-- LIST LAYANAN AKTIF (2 Col) -->
        <div class="lg:col-span-2 bg-white rounded-2xl border border-slate-200 shadow-sm p-6">
            <h3 class="text-sm font-bold text-slate-900 mb-4">Daftar Paket Grooming Tersedia</h3>
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

    <!-- BAGIAN 2: JADWAL & ANTREAN BOOKING GROOMING -->
    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-5 border-b border-slate-200 flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-4">
            <div>
                <h3 class="text-base font-bold text-slate-900">Antrean Booking Grooming Pelanggan</h3>
                <p class="text-xs text-slate-400">Jadwal kedatangan hewan peliharaan</p>
            </div>

            <div class="flex items-center gap-3">
                <form method="GET" action="{{ route('admin.grooming.index') }}" class="flex items-center gap-2">
                    <input type="date" name="date" value="{{ request('date') }}" onchange="this.form.submit()"
                        class="px-3 py-1.5 rounded-xl border border-slate-200 text-xs text-slate-700">
                    @if(request('date'))
                        <a href="{{ route('admin.grooming.index') }}" class="text-xs text-slate-400 hover:text-brand-600">Reset</a>
                    @endif
                </form>

                <a href="{{ route('admin.grooming.export') }}" class="px-3 py-1.5 rounded-xl border border-emerald-200 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 font-bold text-xs flex items-center gap-2 transition">
                    <i class="fa-solid fa-file-excel text-emerald-600"></i>
                    <span>Export Excel</span>
                </a>
            </div>
        </div>

        <div class="overflow-x-auto">
            <table class="w-full text-left text-sm text-slate-600">
                <thead class="bg-slate-50 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-200">
                    <tr>
                        <th class="py-3 px-6">Kode</th>
                        <th class="py-3 px-6">Pelanggan</th>
                        <th class="py-3 px-6">Hewan Peliharaan</th>
                        <th class="py-3 px-6">Layanan</th>
                        <th class="py-3 px-6">Jadwal Datang</th>
                        <th class="py-3 px-6">Status Booking</th>
                        <th class="py-3 px-6 text-right">Aksi</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    @forelse($bookings as $b)
                        <tr class="hover:bg-slate-50/80 transition text-xs">
                            <td class="py-3.5 px-6 font-mono font-bold text-slate-900">{{ $b->kode_booking }}</td>
                            <td class="py-3.5 px-6">
                                <p class="font-bold text-slate-800">{{ $b->pelanggan->nama ?? 'Customer' }}</p>
                                <span class="text-slate-400 text-[11px]">{{ $b->pelanggan->no_hp ?? '-' }}</span>
                            </td>
                            <td class="py-3.5 px-6">
                                <p class="font-bold text-slate-800">{{ $b->pet_name }}</p>
                                <span class="text-slate-400 text-[11px]">{{ $b->pet_type }} ({{ $b->pet_breed ?? '-' }})</span>
                            </td>
                            <td class="py-3.5 px-6 font-semibold text-slate-800">
                                {{ $b->service->name ?? '-' }}
                            </td>
                            <td class="py-3.5 px-6">
                                <span class="block font-semibold text-slate-800">{{ $b->date ? $b->date->format('d/m/Y') : '-' }}</span>
                                <span class="font-mono text-brand-600 font-bold">{{ substr($b->time, 0, 5) }} WIB</span>
                            </td>
                            <td class="py-3.5 px-6">
                                @php
                                    $badge = match($b->status) {
                                        'menunggu' => 'bg-amber-100 text-amber-800',
                                        'dikonfirmasi' => 'bg-blue-100 text-blue-800',
                                        'selesai' => 'bg-emerald-100 text-emerald-800',
                                        'dibatalkan' => 'bg-red-100 text-red-800',
                                        default => 'bg-slate-100 text-slate-700'
                                    };
                                @endphp
                                <span class="px-2.5 py-1 rounded-full text-[11px] font-bold {{ $badge }}">
                                    {{ ucfirst($b->status) }}
                                </span>
                            </td>
                            <td class="py-3.5 px-6 text-right">
                                <form action="{{ route('admin.grooming.booking.status', $b->id) }}" method="POST" class="inline-flex items-center gap-1">
                                    @csrf
                                    @method('PATCH')
                                    <select name="status" onchange="this.form.submit()" class="text-[11px] font-semibold py-1 px-2 rounded-lg border border-slate-200 bg-white">
                                        <option value="menunggu" {{ $b->status == 'menunggu' ? 'selected' : '' }}>Menunggu</option>
                                        <option value="dikonfirmasi" {{ $b->status == 'dikonfirmasi' ? 'selected' : '' }}>Dikonfirmasi</option>
                                        <option value="selesai" {{ $b->status == 'selesai' ? 'selected' : '' }}>Selesai</option>
                                        <option value="dibatalkan" {{ $b->status == 'dibatalkan' ? 'selected' : '' }}>Batalkan</option>
                                    </select>
                                </form>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="7" class="text-center py-10 text-slate-400 text-sm">
                                Tidak ada antrean booking grooming.
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        @if($bookings->hasPages())
            <div class="p-4 border-t border-slate-200 bg-slate-50">
                {{ $bookings->links() }}
            </div>
        @endif
    </div>

</div>
@endsection
