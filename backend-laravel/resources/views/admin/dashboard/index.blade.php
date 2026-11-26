@extends('admin.layouts.app')

@section('title', 'Dashboard')
@section('page_title', 'Dashboard Ringkasan Toko')

@section('content')
<div class="space-y-8">

    <!-- BARIS 1: 4 KARTU STATISTIK UTAMA -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
        <!-- Pendapatan -->
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
            <div>
                <p class="text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Total Pendapatan</p>
                <h3 class="text-xl font-extrabold text-slate-900">Rp {{ number_format($totalPendapatan, 0, ',', '.') }}</h3>
                <span class="text-[11px] font-semibold text-emerald-600 mt-1 inline-flex items-center gap-1">
                    <i class="fa-solid fa-arrow-trend-up"></i> Dari Pesanan Berhasil
                </span>
            </div>
            <div class="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center text-lg font-bold">
                <i class="fa-solid fa-rupiah-sign"></i>
            </div>
        </div>

        <!-- Total Pesanan -->
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
            <div>
                <p class="text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Total Pesanan</p>
                <h3 class="text-2xl font-extrabold text-slate-900">{{ number_format($totalPesanan) }}</h3>
                <span class="text-[11px] font-semibold text-slate-500 mt-1 inline-block">Transaksi Pelanggan</span>
            </div>
            <div class="w-12 h-12 rounded-2xl bg-brand-50 text-brand-600 flex items-center justify-center text-lg font-bold">
                <i class="fa-solid fa-receipt"></i>
            </div>
        </div>

        <!-- Total Produk -->
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
            <div>
                <p class="text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Katalog Produk</p>
                <h3 class="text-2xl font-extrabold text-slate-900">{{ number_format($totalProduk) }}</h3>
                <span class="text-[11px] font-semibold text-slate-500 mt-1 inline-block">Item Aktif Terdaftar</span>
            </div>
            <div class="w-12 h-12 rounded-2xl bg-blue-50 text-blue-600 flex items-center justify-center text-lg font-bold">
                <i class="fa-solid fa-box-open"></i>
            </div>
        </div>

        <!-- Total Pelanggan -->
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between">
            <div>
                <p class="text-xs font-bold text-slate-400 uppercase tracking-wider mb-1">Pelanggan</p>
                <h3 class="text-2xl font-extrabold text-slate-900">{{ number_format($totalPelanggan) }}</h3>
                <span class="text-[11px] font-semibold text-purple-600 mt-1 inline-block">Akun Terdaftar</span>
            </div>
            <div class="w-12 h-12 rounded-2xl bg-purple-50 text-purple-600 flex items-center justify-center text-lg font-bold">
                <i class="fa-solid fa-users"></i>
            </div>
        </div>
    </div>

    <!-- BARIS 2: GRAFIK PENJUALAN & JADWAL GROOMING -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Grafik Penjualan (2 Col) -->
        <div class="lg:col-span-2 bg-white p-6 rounded-2xl border border-slate-200 shadow-sm">
            <div class="flex items-center justify-between mb-4">
                <div>
                    <h3 class="text-base font-bold text-slate-900">Grafik Penjualan 7 Hari Terakhir</h3>
                    <p class="text-xs text-slate-400">Total nominal omzet pesanan berhasil</p>
                </div>
                <span class="px-2.5 py-1 text-xs font-semibold rounded-lg bg-slate-100 text-slate-600">Minggu Ini</span>
            </div>
            <div class="h-64">
                <canvas id="salesChart"></canvas>
            </div>
        </div>

        <!-- Peringatan Stok Menipis & Jadwal Grooming Hari Ini (1 Col) -->
        <div class="space-y-6">
            <!-- Stok Menipis -->
            <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
                <div class="flex items-center justify-between mb-3">
                    <h4 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                        <i class="fa-solid fa-triangle-exclamation text-amber-500"></i>
                        <span>Stok Menipis (<= 5)</span>
                    </h4>
                    <a href="{{ route('admin.produk.index') }}" class="text-xs text-brand-600 hover:underline font-semibold">Semua</a>
                </div>
                @forelse($stokMenipis as $item)
                    <div class="flex items-center justify-between py-2 border-b border-slate-100 last:border-0 text-xs">
                        <div class="min-w-0 pr-2">
                            <p class="font-semibold text-slate-800 truncate">{{ $item->nama_produk }}</p>
                            <span class="text-slate-400 text-[11px]">{{ $item->kategori->nama_kategori ?? '-' }}</span>
                        </div>
                        <span class="px-2 py-0.5 rounded-full text-[11px] font-bold {{ $item->stok == 0 ? 'bg-red-100 text-red-700' : 'bg-amber-100 text-amber-700' }}">
                            {{ $item->stok }} tersisa
                        </span>
                    </div>
                @empty
                    <p class="text-xs text-slate-400 py-4 text-center">Semua stok produk mencukupi.</p>
                @endforelse
            </div>

            <!-- Grooming Hari Ini -->
            <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm">
                <div class="flex items-center justify-between mb-3">
                    <h4 class="text-sm font-bold text-slate-900 flex items-center gap-2">
                        <i class="fa-solid fa-calendar-day text-brand-600"></i>
                        <span>Grooming Hari Ini</span>
                    </h4>
                    <a href="{{ route('admin.grooming.bookings') }}" class="text-xs text-brand-600 hover:underline font-semibold">Jadwal</a>
                </div>
                @forelse($groomingHariIni as $booking)
                    <div class="flex items-center justify-between py-2 border-b border-slate-100 last:border-0 text-xs">
                        <div>
                            <p class="font-semibold text-slate-800">{{ $booking->pet_name }} ({{ $booking->pet_type }})</p>
                            <span class="text-slate-400 text-[11px]">{{ $booking->service->name ?? 'Layanan' }}</span>
                        </div>
                        <span class="font-mono text-xs font-bold text-brand-700 bg-brand-50 px-2 py-0.5 rounded">
                            {{ substr($booking->time, 0, 5) }}
                        </span>
                    </div>
                @empty
                    <p class="text-xs text-slate-400 py-3 text-center">Tidak ada jadwal grooming untuk hari ini.</p>
                @endforelse
            </div>
        </div>
    </div>

    <!-- BARIS 3: PESANAN SIAP KIRIM (SUDAH BAYAR) -->
    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-6 border-b border-slate-200 flex items-center justify-between">
            <div>
                <h3 class="text-base font-bold text-slate-900 flex items-center gap-2">
                    <i class="fa-solid fa-boxes-packing text-brand-600"></i>
                    <span>Pesanan Siap Kirim (Sudah Bayar)</span>
                </h3>
                <p class="text-xs text-slate-400">Daftar transaksi yang sudah terverifikasi bayar dan siap dikemas/dikirim</p>
            </div>
            <a href="{{ route('admin.pesanan.index') }}" class="text-xs font-bold text-brand-600 hover:text-brand-700 inline-flex items-center gap-1">
                <span>Kelola Semua Pesanan</span>
                <i class="fa-solid fa-chevron-right text-[10px]"></i>
            </a>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full text-left text-sm text-slate-600">
                <thead class="bg-slate-50 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-200">
                    <tr>
                        <th class="py-3 px-6">ID Pesanan</th>
                        <th class="py-3 px-6">Pelanggan</th>
                        <th class="py-3 px-6">Waktu Pesan</th>
                        <th class="py-3 px-6">Total Tagihan</th>
                        <th class="py-3 px-6">Status Bayar</th>
                        <th class="py-3 px-6">Status Pesanan</th>
                        <th class="py-3 px-6 text-right">Aksi</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    @forelse($pesananSiapKirim as $pesanan)
                        <tr class="hover:bg-slate-50/80 transition">
                            <td class="py-3.5 px-6 font-mono font-bold text-slate-800">
                                {{ $pesanan->kode_pesanan }}
                            </td>
                            <td class="py-3.5 px-6">
                                <p class="font-semibold text-slate-800">{{ $pesanan->pelanggan->nama ?? 'Umum' }}</p>
                                <span class="text-xs text-slate-400">{{ $pesanan->no_telp ?? $pesanan->pelanggan->no_hp ?? '-' }}</span>
                            </td>
                            <td class="py-3.5 px-6 text-xs text-slate-500">
                                {{ $pesanan->tanggal_pesanan ?? ($pesanan->created_at ? $pesanan->created_at->format('Y-m-d H:i') : '-') }}
                            </td>
                            <td class="py-3.5 px-6 font-bold text-slate-900">
                                Rp {{ number_format($pesanan->total, 0, ',', '.') }}
                            </td>
                            <td class="py-3.5 px-6">
                                <span class="px-2.5 py-1 rounded-full text-[11px] font-bold bg-emerald-100 text-emerald-800 border border-emerald-200">
                                    {{ strtoupper($pesanan->pembayaran->status_bayar ?? 'PAID') }}
                                </span>
                            </td>
                            <td class="py-3.5 px-6">
                                @php
                                    $badgeClass = match($pesanan->status_pesanan) {
                                        'baru', 'menunggu_verifikasi' => 'bg-amber-100 text-amber-800',
                                        'diproses' => 'bg-blue-100 text-blue-800',
                                        'dikirim' => 'bg-indigo-100 text-indigo-800',
                                        'selesai' => 'bg-emerald-100 text-emerald-800',
                                        'batal' => 'bg-red-100 text-red-800',
                                        default => 'bg-slate-100 text-slate-800'
                                    };
                                @endphp
                                <span class="px-2.5 py-1 rounded-full text-xs font-semibold {{ $badgeClass }}">
                                    {{ ucfirst(str_replace('_', ' ', $pesanan->status_pesanan)) }}
                                </span>
                            </td>
                            <td class="py-3.5 px-6 text-right">
                                <a href="{{ route('admin.pesanan.index') }}" class="text-xs font-bold text-brand-600 hover:bg-brand-50 px-3 py-1.5 rounded-lg border border-brand-200 transition">
                                    Proses Kirim
                                </a>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="7" class="text-center py-8 text-slate-400 text-sm">
                                Tidak ada antrean pesanan yang menunggu dikirim saat ini.
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>

</div>
@endsection

@push('scripts')
<script>
    const ctx = document.getElementById('salesChart').getContext('2d');
    const salesChart = new Chart(ctx, {
        type: 'line',
        data: {
            labels: {!! json_encode($chartDates) !!},
            datasets: [{
                label: 'Penjualan (Rp)',
                data: {!! json_encode($chartTotals) !!},
                borderColor: '#dc2626',
                backgroundColor: 'rgba(220, 38, 38, 0.08)',
                fill: true,
                tension: 0.35,
                borderWidth: 2.5,
                pointBackgroundColor: '#dc2626',
                pointBorderColor: '#ffffff',
                pointBorderWidth: 2,
                pointRadius: 4,
                pointHoverRadius: 6,
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
                legend: { display: false }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: {
                        callback: function(value) {
                            return 'Rp ' + (value / 1000).toLocaleString('id-ID') + 'k';
                        },
                        font: { size: 11, family: 'Plus Jakarta Sans' },
                        color: '#94a3b8'
                    },
                    grid: { color: '#f1f5f9' }
                },
                x: {
                    ticks: {
                        font: { size: 11, family: 'Plus Jakarta Sans' },
                        color: '#94a3b8'
                    },
                    grid: { display: false }
                }
            }
        }
    });
</script>
@endpush
