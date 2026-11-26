@extends('admin.layouts.app')

@section('title', 'Daftar Pesanan')
@section('page_title', 'Manajemen Transaksi & Pesanan')

@section('content')
<div class="space-y-6">

    <!-- FILTER & CARI -->
    <div class="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-4">
        <form method="GET" action="{{ route('admin.pesanan.index') }}" class="flex flex-1 flex-wrap items-center gap-3">
            <div class="relative flex-1 min-w-[220px]">
                <span class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
                    <i class="fa-solid fa-magnifying-glass text-xs"></i>
                </span>
                <input type="text" name="search" value="{{ request('search') }}" placeholder="Cari ID pesanan, nama pembeli, telp..."
                    class="w-full pl-9 pr-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-brand-600 bg-white">
            </div>

            <select name="status" onchange="this.form.submit()" class="py-2 px-3 rounded-xl border border-slate-200 text-xs text-slate-700 bg-white focus:outline-none focus:ring-2 focus:ring-brand-600">
                <option value="">Semua Status</option>
                <option value="baru" {{ request('status') == 'baru' ? 'selected' : '' }}>Baru</option>
                <option value="menunggu_verifikasi" {{ request('status') == 'menunggu_verifikasi' ? 'selected' : '' }}>Menunggu Verifikasi</option>
                <option value="diproses" {{ request('status') == 'diproses' ? 'selected' : '' }}>Diproses</option>
                <option value="dikirim" {{ request('status') == 'dikirim' ? 'selected' : '' }}>Dikirim</option>
                <option value="selesai" {{ request('status') == 'selesai' ? 'selected' : '' }}>Selesai</option>
                <option value="batal" {{ request('status') == 'batal' ? 'selected' : '' }}>Batal</option>
            </select>

            @if(request('search') || request('status'))
                <a href="{{ route('admin.pesanan.index') }}" class="text-xs text-slate-500 hover:text-brand-600 font-semibold px-2">Reset</a>
            @endif
        </form>

        <a href="{{ route('admin.pesanan.export') }}" class="px-3.5 py-2 rounded-xl border border-emerald-200 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 font-bold text-xs flex items-center gap-2 shadow-sm transition">
            <i class="fa-solid fa-file-excel text-emerald-600"></i>
            <span>Export Rekap Pesanan</span>
        </a>
    </div>

    <!-- TABEL PESANAN -->
    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left text-sm text-slate-600">
                <thead class="bg-slate-50 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-200">
                    <tr>
                        <th class="py-3 px-6">ID Pesanan</th>
                        <th class="py-3 px-6">Pelanggan</th>
                        <th class="py-3 px-6">Tanggal</th>
                        <th class="py-3 px-6">Total Tagihan</th>
                        <th class="py-3 px-6">Pembayaran</th>
                        <th class="py-3 px-6">Status Pesanan</th>
                        <th class="py-3 px-6 text-right w-24">Aksi</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    @forelse($pesanans as $p)
                        <tr class="hover:bg-slate-50/80 transition">
                            <td class="py-3.5 px-6 font-mono font-bold text-slate-900">
                                {{ $p->kode_pesanan }}
                            </td>
                            <td class="py-3.5 px-6">
                                <p class="font-bold text-slate-900">{{ $p->pelanggan->nama ?? 'Customer' }}</p>
                                <span class="text-xs text-slate-400">{{ $p->no_telp ?? $p->pelanggan->no_hp ?? '-' }}</span>
                            </td>
                            <td class="py-3.5 px-6 text-xs text-slate-500">
                                {{ $p->tanggal_pesanan ?? ($p->created_at ? $p->created_at->format('Y-m-d H:i') : '-') }}
                            </td>
                            <td class="py-3.5 px-6 font-bold text-slate-900">
                                Rp {{ number_format($p->total, 0, ',', '.') }}
                            </td>
                            <td class="py-3.5 px-6 text-xs">
                                <span class="font-semibold block text-slate-700">{{ strtoupper($p->pembayaran->metode_bayar ?? 'Midtrans') }}</span>
                                <span class="text-[11px] font-bold {{ ($p->pembayaran->status_bayar ?? '') === 'paid' ? 'text-emerald-600' : 'text-amber-600' }}">
                                    {{ strtoupper($p->pembayaran->status_bayar ?? 'Pending') }}
                                </span>
                            </td>
                            <td class="py-3.5 px-6">
                                @php
                                    $badge = match($p->status_pesanan) {
                                        'baru', 'menunggu_verifikasi' => 'bg-amber-100 text-amber-800',
                                        'diproses' => 'bg-blue-100 text-blue-800',
                                        'dikirim' => 'bg-indigo-100 text-indigo-800',
                                        'selesai' => 'bg-emerald-100 text-emerald-800',
                                        'batal' => 'bg-red-100 text-red-800',
                                        default => 'bg-slate-100 text-slate-700'
                                    };
                                @endphp
                                <span class="px-2.5 py-1 rounded-full text-xs font-bold {{ $badge }}">
                                    {{ ucfirst(str_replace('_', ' ', $p->status_pesanan)) }}
                                </span>
                            </td>
                            <td class="py-3.5 px-6 text-right">
                                <a href="{{ route('admin.pesanan.show', $p->id_pesanan) }}" class="px-3 py-1.5 rounded-lg border border-brand-200 text-brand-700 hover:bg-brand-50 text-xs font-bold transition inline-block">
                                    Detail
                                </a>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="7" class="text-center py-10 text-slate-400 text-sm">
                                Tidak ada transaksi pesanan yang sesuai filter.
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        @if($pesanans->hasPages())
            <div class="p-4 border-t border-slate-200 bg-slate-50">
                {{ $pesanans->links() }}
            </div>
        @endif
    </div>

</div>
@endsection
