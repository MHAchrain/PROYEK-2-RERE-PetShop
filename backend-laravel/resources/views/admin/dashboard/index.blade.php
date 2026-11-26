@extends('admin.layouts.app')

@section('title', 'Dashboard')
@section('page_title', 'Dashboard Ringkasan Toko')

@section('content')
<div class="space-y-8">

    <!-- BARIS 1: 4 KARTU STATISTIK UTAMA -->
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
        <!-- Total Pendapatan Hari Ini -->
        <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm flex items-center justify-between relative overflow-hidden group">
            <div>
                <div class="flex items-center gap-1.5 mb-1">
                    <p class="text-xs font-bold text-slate-400 uppercase tracking-wider">Total Pendapatan Hari Ini</p>
                    <a href="{{ route('admin.dashboard.invoice-pdf') }}" title="Download Invoice Hari Ini (PDF)" 
                       class="w-6 h-6 rounded-lg bg-brand-50 hover:bg-brand-600 hover:text-white text-brand-600 flex items-center justify-center transition border border-brand-200 text-xs shadow-xs"
                       download>
                        <i class="fa-solid fa-file-pdf"></i>
                    </a>
                </div>
                <h3 class="text-xl font-extrabold text-slate-900">Rp {{ number_format($totalPendapatanHariIni, 0, ',', '.') }}</h3>
                <span class="text-[11px] font-semibold text-emerald-600 mt-1 inline-flex items-center gap-1">
                    <i class="fa-solid fa-circle-check"></i> Pesanan Lunas Hari Ini
                </span>
            </div>
            <div class="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center text-lg font-bold shrink-0">
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

    <!-- BARIS 3: PESANAN SIAP KIRIM (HANYA STATUS DIPROSES) -->
    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-6 border-b border-slate-200 flex items-center justify-between">
            <div>
                <h3 class="text-base font-bold text-slate-900 flex items-center gap-2">
                    <i class="fa-solid fa-boxes-packing text-brand-600"></i>
                    <span>Pesanan Siap Kirim (Diproses)</span>
                </h3>
                <p class="text-xs text-slate-400">Daftar transaksi yang sedang diproses dan perlu input kurir & resi</p>
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
                        <th class="py-3 px-6 text-right">Kirim Paket</th>
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
                            <td class="py-3.5 px-6 text-right">
                                <!-- Tombol Pop-up Pengiriman Instan di Dashboard -->
                                <button type="button" onclick="openDashKirimModal('{{ $pesanan->id_pesanan }}', '{{ $pesanan->kode_pesanan }}', '{{ $pesanan->pelanggan->nama ?? 'Customer' }}', '{{ $pesanan->pengiriman->kurir ?? 'Internal' }}', '{{ $pesanan->pengiriman->resi ?? '' }}')" class="px-3.5 py-1.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white text-xs font-bold shadow-sm shadow-brand-600/20 transition inline-flex items-center gap-1.5">
                                    <i class="fa-solid fa-truck-fast text-[11px]"></i>
                                    <span>Input Resi & Kirim</span>
                                </button>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="6" class="text-center py-8 text-slate-400 text-sm">
                                Tidak ada antrean pesanan yang sedang diproses saat ini.
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>

</div>

<!-- ======================================================== -->
<!-- MODAL POP-UP KHUSUS INPUT RESI & PENGIRIMAN DI DASHBOARD -->
<!-- ======================================================== -->
<div id="dashKirimModal" class="hidden fixed inset-0 bg-slate-900/50 backdrop-blur-xs z-50 flex items-center justify-center p-4">
    <div class="bg-white rounded-2xl border border-slate-200 shadow-xl max-w-md w-full p-6 space-y-4">
        <div class="flex items-center justify-between pb-3 border-b border-slate-100">
            <div class="flex items-center gap-2.5">
                <div class="w-8 h-8 rounded-lg bg-brand-50 text-brand-600 flex items-center justify-center font-bold text-xs">
                    <i class="fa-solid fa-truck"></i>
                </div>
                <div>
                    <h3 class="text-sm font-bold text-slate-900" id="dashModalKode">Input Resi Pengiriman</h3>
                    <p class="text-[11px] text-slate-400" id="dashModalPelanggan">-</p>
                </div>
            </div>
            <button onclick="closeDashKirimModal()" class="w-7 h-7 rounded-lg flex items-center justify-center text-slate-400 hover:text-slate-700 hover:bg-slate-100 transition">
                <i class="fa-solid fa-xmark text-xs"></i>
            </button>
        </div>

        <form id="dashKirimForm" method="POST" class="space-y-4 text-xs">
            @csrf
            @method('PATCH')
            <input type="hidden" name="status_pesanan" value="dikirim">
            <input type="hidden" name="status_bayar" value="paid">

            <div>
                <label class="block text-[10px] font-bold text-slate-500 uppercase mb-1">Pilihan Kurir (3 Opsi)</label>
                <select name="kurir" id="dashModalKurir" onchange="autoDashResi()" class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs font-semibold bg-white text-slate-800">
                    <option value="Internal">Internal (Kurir Toko ReRe)</option>
                    <option value="JNE">JNE Ekspedisi</option>
                    <option value="Ojol">Ojol (Gojek / Grab Express)</option>
                </select>
            </div>

            <div>
                <div class="flex items-center justify-between mb-1">
                    <label class="text-[10px] font-bold text-slate-500 uppercase">Nomor Resi / Keterangan</label>
                    <button type="button" onclick="generateDashResi()" class="text-brand-600 hover:text-brand-800 font-bold text-[10px] inline-flex items-center gap-1">
                        <i class="fa-solid fa-arrows-rotate"></i>
                        <span>Buat Otomatis</span>
                    </button>
                </div>
                <input type="text" name="resi" id="dashModalResi" placeholder="Contoh: JNE12345 / Klik Buat Otomatis" class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs font-mono bg-white">
            </div>

            <p class="text-[11px] text-slate-400 bg-slate-50 p-2.5 rounded-lg border border-slate-100">
                Saat disimpan, status pesanan otomatis berubah menjadi <strong>Dikirim</strong> dan langsung masuk ke menu Pengiriman.
            </p>

            <div class="pt-2 flex items-center justify-end gap-2 border-t border-slate-100">
                <button type="button" onclick="closeDashKirimModal()" class="px-4 py-2 rounded-xl text-xs font-bold text-slate-500 hover:bg-slate-100 transition">
                    Batal
                </button>
                <button type="submit" class="px-5 py-2 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-bold text-xs shadow-md shadow-brand-600/20 transition">
                    Kirim Pesanan
                </button>
            </div>
        </form>
    </div>
</div>
@endsection

@push('scripts')
<script>
    let activeDashPesananId = null;

    function openDashKirimModal(idPesanan, kodePesanan, namaPelanggan, kurir, resi) {
        activeDashPesananId = idPesanan;
        const modal = document.getElementById('dashKirimModal');
        const form = document.getElementById('dashKirimForm');
        form.action = `/admin/pesanan/${idPesanan}/status`;

        document.getElementById('dashModalKode').innerText = 'Kirim Pesanan: ' + kodePesanan;
        document.getElementById('dashModalPelanggan').innerText = 'Penerima: ' + namaPelanggan;
        document.getElementById('dashModalKurir').value = kurir || 'Internal';
        document.getElementById('dashModalResi').value = resi || '';

        if (!resi) {
            generateDashResi();
        }

        modal.classList.remove('hidden');
    }

    function closeDashKirimModal() {
        document.getElementById('dashKirimModal').classList.add('hidden');
    }

    function generateDashResi() {
        const kurir = document.getElementById('dashModalKurir').value;
        const now = new Date();
        const dateStr = now.getFullYear().toString().substr(-2) + 
                        String(now.getMonth() + 1).padStart(2, '0') + 
                        String(now.getDate()).padStart(2, '0');
        const rand = Math.floor(100000 + Math.random() * 900000);

        let generatedResi = '';
        if (kurir === 'JNE') {
            generatedResi = 'JNE' + dateStr + rand;
        } else if (kurir === 'Ojol') {
            generatedResi = 'OJOL-' + dateStr + '-' + rand;
        } else {
            generatedResi = 'RERE-INT-' + dateStr + '-' + (activeDashPesananId || rand);
        }

        document.getElementById('dashModalResi').value = generatedResi;
    }

    function autoDashResi() {
        generateDashResi();
    }
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
