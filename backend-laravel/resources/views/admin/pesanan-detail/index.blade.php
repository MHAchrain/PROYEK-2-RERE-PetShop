@extends('admin.layouts.app')

@section('title', 'Detail Item Pesanan')
@section('page_title', 'Rincian Item Penjualan')

@section('content')
<div class="space-y-6">

    <div class="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-4">
        <form method="GET" action="{{ route('admin.pesanan-detail.index') }}" class="flex flex-1 items-center gap-3">
            <div class="relative flex-1 max-w-md">
                <span class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
                    <i class="fa-solid fa-magnifying-glass text-xs"></i>
                </span>
                <input type="text" name="search" value="{{ request('search') }}" placeholder="Cari nama produk, nama pembeli, ID pesanan..."
                    class="w-full pl-9 pr-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-brand-600 bg-white">
            </div>
            @if(request('search'))
                <a href="{{ route('admin.pesanan-detail.index') }}" class="text-xs text-slate-500 hover:text-brand-600 font-semibold px-2">Reset</a>
            @endif
        </form>

        <a href="{{ route('admin.pesanan-detail.export') }}" class="px-3.5 py-2 rounded-xl border border-emerald-200 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 font-bold text-xs flex items-center gap-2 shadow-sm transition">
            <i class="fa-solid fa-file-excel text-emerald-600"></i>
            <span>Export Detail Item</span>
        </a>
    </div>

    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left text-sm text-slate-600">
                <thead class="bg-slate-50 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-200">
                    <tr>
                        <th class="py-3 px-6">ID Detail</th>
                        <th class="py-3 px-6">Pesanan</th>
                        <th class="py-3 px-6">Pembeli</th>
                        <th class="py-3 px-6">Nama Produk</th>
                        <th class="py-3 px-6">Qty</th>
                        <th class="py-3 px-6">Harga Satuan</th>
                        <th class="py-3 px-6 text-right">Subtotal</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    @forelse($details as $d)
                        <tr class="hover:bg-slate-50/80 transition text-xs">
                            <td class="py-3.5 px-6 font-mono text-slate-400">#{{ $d->id_detail }}</td>
                            <td class="py-3.5 px-6 font-mono font-bold text-slate-900">
                                <a href="{{ route('admin.pesanan.show', $d->id_pesanan) }}" class="text-brand-600 hover:underline">
                                    {{ $d->pesanan ? $d->pesanan->kode_pesanan : '#' . $d->id_pesanan }}
                                </a>
                            </td>
                            <td class="py-3.5 px-6 font-medium text-slate-800">
                                {{ $d->pesanan->pelanggan->nama ?? '-' }}
                            </td>
                            <td class="py-3.5 px-6 font-bold text-slate-900">
                                {{ $d->produk->nama_produk ?? 'Produk Dihapus' }}
                            </td>
                            <td class="py-3.5 px-6 font-bold text-slate-800">
                                {{ $d->qty ?? $d->jumlah ?? 1 }} pcs
                            </td>
                            <td class="py-3.5 px-6 font-medium text-slate-600">
                                Rp {{ number_format($d->harga_satuan, 0, ',', '.') }}
                            </td>
                            <td class="py-3.5 px-6 text-right font-extrabold text-slate-900">
                                Rp {{ number_format($d->subtotal, 0, ',', '.') }}
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="7" class="text-center py-10 text-slate-400 text-sm">
                                Tidak ada data rincian pesanan.
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        @if($details->hasPages())
            <div class="p-4 border-t border-slate-200 bg-slate-50">
                {{ $details->links() }}
            </div>
        @endif
    </div>

</div>
@endsection
