@extends('admin.layouts.app')

@section('title', 'Detail Pelanggan ' . $pelanggan->nama)
@section('page_title', 'Profil Pelanggan: ' . $pelanggan->nama)

@section('content')
<div class="space-y-6">

    <div class="flex items-center justify-between">
        <a href="{{ route('admin.pelanggan.index') }}" class="inline-flex items-center gap-2 text-xs font-bold text-slate-500 hover:text-slate-800">
            <i class="fa-solid fa-arrow-left"></i>
            <span>Kembali ke Daftar Pelanggan</span>
        </a>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- KARTU PROFIL (1 Col) -->
        <div class="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm space-y-4">
            <div class="flex items-center gap-4">
                <div class="w-16 h-16 rounded-2xl bg-brand-50 text-brand-600 flex items-center justify-center text-2xl font-black">
                    {{ strtoupper(substr($pelanggan->nama, 0, 1)) }}
                </div>
                <div>
                    <h3 class="text-base font-bold text-slate-900">{{ $pelanggan->nama }}</h3>
                    <span class="text-xs font-mono text-slate-400 font-semibold">{{ $pelanggan->kode_pelanggan }}</span>
                </div>
            </div>

            <div class="border-t border-slate-100 pt-4 space-y-3 text-xs">
                <div>
                    <span class="text-slate-400 block mb-0.5">Alamat Email</span>
                    <span class="font-semibold text-slate-800">{{ $pelanggan->email ?? '-' }}</span>
                </div>
                <div>
                    <span class="text-slate-400 block mb-0.5">Nomor Telepon / WhatsApp</span>
                    <span class="font-semibold text-slate-800 font-mono">{{ $pelanggan->no_hp ?? '-' }}</span>
                </div>
                <div>
                    <span class="text-slate-400 block mb-0.5">Alamat Lengkap</span>
                    <p class="text-slate-700 bg-slate-50 p-3 rounded-xl border border-slate-100 leading-relaxed">
                        {{ $pelanggan->alamat ?? 'Belum mengisi alamat' }}
                    </p>
                </div>
                <div>
                    <span class="text-slate-400 block mb-0.5">Tanggal Bergabung</span>
                    <span class="text-slate-600">{{ $pelanggan->created_at ? $pelanggan->created_at->translatedFormat('d F Y, H:i') : '-' }}</span>
                </div>
            </div>
        </div>

        <!-- RIWAYAT BOOKING GROOMING (2 Col) -->
        <div class="lg:col-span-2 bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
            <div class="p-5 border-b border-slate-200">
                <h3 class="text-sm font-bold text-slate-900">Riwayat Booking Grooming</h3>
            </div>
            <div class="overflow-x-auto">
                <table class="w-full text-left text-sm text-slate-600">
                    <thead class="bg-slate-50 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-200">
                        <tr>
                            <th class="py-3 px-5">Kode</th>
                            <th class="py-3 px-5">Hewan</th>
                            <th class="py-3 px-5">Layanan</th>
                            <th class="py-3 px-5">Tanggal & Waktu</th>
                            <th class="py-3 px-5">Status</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100">
                        @forelse($pelanggan->groomingBookings as $b)
                            <tr class="hover:bg-slate-50/80 transition text-xs">
                                <td class="py-3 px-5 font-mono font-bold text-slate-800">{{ $b->kode_booking }}</td>
                                <td class="py-3 px-5">
                                    <p class="font-bold text-slate-900">{{ $b->pet_name }}</p>
                                    <span class="text-[11px] text-slate-400">{{ $b->pet_type }} ({{ $b->pet_breed ?? '-' }})</span>
                                </td>
                                <td class="py-3 px-5 font-medium text-slate-700">{{ $b->service->name ?? '-' }}</td>
                                <td class="py-3 px-5">
                                    {{ $b->date ? $b->date->format('d/m/Y') : '-' }} {{ substr($b->time, 0, 5) }}
                                </td>
                                <td class="py-3 px-5">
                                    <span class="px-2 py-0.5 rounded-full text-[11px] font-bold {{ $b->status == 'selesai' ? 'bg-emerald-100 text-emerald-800' : 'bg-slate-100 text-slate-700' }}">
                                        {{ ucfirst($b->status) }}
                                    </span>
                                </td>
                            </tr>
                        @empty
                            <tr>
                                <td colspan="5" class="text-center py-8 text-slate-400 text-xs">
                                    Belum ada riwayat booking grooming untuk pelanggan ini.
                                </td>
                            </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>
@endsection
