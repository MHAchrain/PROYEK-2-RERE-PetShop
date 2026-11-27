@extends('admin.layouts.app')

@section('title', 'Antrean Pesanan Grooming')
@section('page_title', 'Pesanan & Booking Grooming')

@section('content')
<div class="space-y-6">

    <div class="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-4">
        <form method="GET" action="{{ route('admin.grooming.bookings') }}" class="flex flex-1 flex-wrap items-center gap-3">
            <input type="date" name="date" value="{{ request('date') }}" onchange="this.form.submit()"
                class="px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-700 bg-white">

            <select name="status" onchange="this.form.submit()" class="py-2 px-3 rounded-xl border border-slate-200 text-xs text-slate-700 bg-white">
                <option value="">Semua Status Booking</option>
                <option value="menunggu_pembayaran" {{ request('status') == 'menunggu_pembayaran' ? 'selected' : '' }}>Menunggu Pembayaran</option>
                <option value="terjadwal" {{ request('status') == 'terjadwal' ? 'selected' : '' }}>Terjadwal</option>
                <option value="dikonfirmasi" {{ request('status') == 'dikonfirmasi' ? 'selected' : '' }}>Dikonfirmasi</option>
                <option value="selesai" {{ request('status') == 'selesai' ? 'selected' : '' }}>Selesai</option>
                <option value="dibatalkan" {{ request('status') == 'dibatalkan' ? 'selected' : '' }}>Dibatalkan</option>
            </select>

            @if(request('date') || request('status'))
                <a href="{{ route('admin.grooming.bookings') }}" class="text-xs text-slate-500 hover:text-brand-600 font-semibold px-2">Reset</a>
            @endif
        </form>

        <a href="{{ route('admin.grooming.export') }}" class="px-3.5 py-2 rounded-xl border border-emerald-200 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 font-bold text-xs flex items-center gap-2 shadow-sm transition">
            <i class="fa-solid fa-file-excel text-emerald-600"></i>
            <span>Export Rekap Grooming</span>
        </a>
    </div>

    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left text-sm text-slate-600">
                <thead class="bg-slate-50 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-200">
                    <tr>
                        <th class="py-3 px-6">Kode Booking</th>
                        <th class="py-3 px-6">Pelanggan</th>
                        <th class="py-3 px-6">Hewan Peliharaan</th>
                        <th class="py-3 px-6">Layanan</th>
                        <th class="py-3 px-6">Jadwal Kedatangan</th>
                        <th class="py-3 px-6">Status Booking</th>
                        <th class="py-3 px-6 text-right">Ubah Status</th>
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
                                        'menunggu_pembayaran' => 'bg-amber-100 text-amber-800',
                                        'terjadwal', 'dikonfirmasi' => 'bg-blue-100 text-blue-800',
                                        'selesai' => 'bg-emerald-100 text-emerald-800',
                                        'dibatalkan', 'gagal' => 'bg-red-100 text-red-800',
                                        default => 'bg-slate-100 text-slate-700'
                                    };
                                @endphp
                                <span class="px-2.5 py-1 rounded-full text-[11px] font-bold {{ $badge }}">
                                    {{ ucfirst(str_replace('_', ' ', $b->status)) }}
                                </span>
                            </td>
                            <td class="py-3.5 px-6 text-right">
                                <form action="{{ route('admin.grooming.booking.status', $b->id) }}" method="POST" class="inline-flex items-center gap-1">
                                    @csrf
                                    @method('PATCH')
                                    <select name="status" onchange="this.form.submit()" class="text-[11px] font-semibold py-1 px-2 rounded-lg border border-slate-200 bg-white">
                                        <option value="menunggu_pembayaran" {{ $b->status == 'menunggu_pembayaran' ? 'selected' : '' }}>Menunggu Bayar</option>
                                        <option value="terjadwal" {{ $b->status == 'terjadwal' ? 'selected' : '' }}>Terjadwal</option>
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
                                Tidak ada antrean pesanan grooming yang ditemukan.
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
