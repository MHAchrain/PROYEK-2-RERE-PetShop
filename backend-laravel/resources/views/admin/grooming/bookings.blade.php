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
                                        'terjadwal' => 'bg-slate-100 text-slate-700',
                                        'dikonfirmasi' => 'bg-blue-100 text-blue-800',
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
                                <div class="inline-flex items-center gap-2 justify-end">
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
                                    @php
                                        $payStatus = strtoupper($b->payment_status ?? (in_array($b->status, ['terjadwal', 'dikonfirmasi', 'selesai']) ? 'PAID' : ($b->status === 'dibatalkan' ? 'CANCEL' : 'PENDING')));
                                        $payMethod = strtoupper($b->midtrans_payment_method ?? $b->payment_method ?? ($b->midtrans_order_id ? 'MIDTRANS' : 'MANUAL'));
                                        $detailPayload = [
                                            'kode' => $b->kode_booking,
                                            'tanggal' => $b->created_at ? $b->created_at->format('d/m/Y H:i') : '-',
                                            'jadwal' => ($b->date ? $b->date->format('d/m/Y') : '-') . ' ' . substr($b->time, 0, 5) . ' WIB',
                                            'pelanggan' => $b->pelanggan->nama ?? 'Customer',
                                            'layanan' => $b->service->name ?? '-',
                                            'total' => 'Rp ' . number_format((float)($b->total_price ?? $b->service->price ?? 0), 0, ',', '.'),
                                            'status_bayar' => $payStatus,
                                            'metode' => $payMethod,
                                            'midtrans_id' => $b->midtrans_order_id ?? '-',
                                        ];
                                    @endphp
                                    <button type="button"
                                        onclick='openGroomingDetail(@json($detailPayload))'
                                        class="inline-flex items-center gap-1 bg-red-600 hover:bg-red-700 text-white px-2.5 py-1.5 rounded-lg text-[11px] font-bold transition shadow-sm">
                                        <i class="fa-solid fa-eye text-[10px]"></i> Detail
                                    </button>
                                </div>
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

<!-- Modal Detail Pembayaran Grooming -->
<div id="groomingDetailModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-slate-900/50 backdrop-blur-sm p-4">
    <div class="bg-white rounded-2xl shadow-xl w-full max-w-md overflow-hidden border border-slate-200">
        <div class="px-5 py-4 border-b border-slate-100 flex items-center justify-between bg-slate-50">
            <div>
                <h4 class="text-sm font-bold text-slate-900">Detail Pembayaran Grooming</h4>
                <p id="gdKode" class="text-xs font-mono text-slate-500 mt-0.5">-</p>
            </div>
            <button type="button" onclick="closeGroomingDetail()" class="text-slate-400 hover:text-slate-600 text-lg">&times;</button>
        </div>
        <div class="p-5 space-y-3 text-xs">
            <div class="flex justify-between py-1.5 border-b border-slate-100">
                <span class="text-slate-500">Pelanggan</span>
                <span id="gdPelanggan" class="font-bold text-slate-800">-</span>
            </div>
            <div class="flex justify-between py-1.5 border-b border-slate-100">
                <span class="text-slate-500">Layanan</span>
                <span id="gdLayanan" class="font-semibold text-slate-800">-</span>
            </div>
            <div class="flex justify-between py-1.5 border-b border-slate-100">
                <span class="text-slate-500">Tanggal Transaksi</span>
                <span id="gdTanggal" class="font-semibold text-slate-800">-</span>
            </div>
            <div class="flex justify-between py-1.5 border-b border-slate-100">
                <span class="text-slate-500">Jadwal Kedatangan</span>
                <span id="gdJadwal" class="font-semibold text-slate-800">-</span>
            </div>
            <div class="flex justify-between py-1.5 border-b border-slate-100">
                <span class="text-slate-500">Metode Pembayaran</span>
                <span id="gdMetode" class="font-bold text-slate-900">-</span>
            </div>
            <div class="flex justify-between py-1.5 border-b border-slate-100">
                <span class="text-slate-500">Status Pembayaran</span>
                <span id="gdStatusBayar" class="px-2 py-0.5 rounded-full font-bold text-[11px]">-</span>
            </div>
            <div class="flex justify-between py-1.5 border-b border-slate-100">
                <span class="text-slate-500">Ref. Midtrans</span>
                <span id="gdMidtransId" class="font-mono text-[11px] text-slate-600">-</span>
            </div>
            <div class="flex justify-between pt-2 text-sm">
                <span class="font-bold text-slate-700">Total Tagihan</span>
                <span id="gdTotal" class="font-extrabold text-red-600">-</span>
            </div>
        </div>
        <div class="px-5 py-3 bg-slate-50 border-t border-slate-100 text-right">
            <button type="button" onclick="closeGroomingDetail()" class="px-4 py-2 rounded-lg bg-slate-800 text-white text-xs font-bold hover:bg-slate-900 transition">Tutup</button>
        </div>
    </div>
</div>

<script>
function openGroomingDetail(data) {
    document.getElementById('gdKode').textContent = data.kode || '-';
    document.getElementById('gdPelanggan').textContent = data.pelanggan || '-';
    document.getElementById('gdLayanan').textContent = data.layanan || '-';
    document.getElementById('gdTanggal').textContent = data.tanggal || '-';
    document.getElementById('gdJadwal').textContent = data.jadwal || '-';
    document.getElementById('gdMetode').textContent = data.metode || '-';
    document.getElementById('gdMidtransId').textContent = data.midtrans_id || '-';
    document.getElementById('gdTotal').textContent = data.total || '-';

    const badge = document.getElementById('gdStatusBayar');
    badge.textContent = data.status_bayar || 'PENDING';
    badge.className = 'px-2 py-0.5 rounded-full font-bold text-[11px] ' +
        (data.status_bayar === 'PAID'
            ? 'bg-emerald-100 text-emerald-700'
            : (data.status_bayar === 'CANCEL' ? 'bg-red-100 text-red-700' : 'bg-amber-100 text-amber-700'));

    const modal = document.getElementById('groomingDetailModal');
    modal.classList.remove('hidden');
    modal.classList.add('flex');
}

function closeGroomingDetail() {
    const modal = document.getElementById('groomingDetailModal');
    modal.classList.add('hidden');
    modal.classList.remove('flex');
}
</script>
@endsection
