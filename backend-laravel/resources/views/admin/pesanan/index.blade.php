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
                        <th class="py-3 px-6 text-right w-36">Aksi Cepat</th>
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
                                @php
                                    $bayarStatus = strtolower($p->pembayaran->status_bayar ?? 'pending');
                                    $bayarColor = match($bayarStatus) {
                                        'paid', 'dibayar' => 'text-emerald-600 bg-emerald-50 border-emerald-200',
                                        'cancel', 'cancelled', 'dibatalkan' => 'text-red-600 bg-red-50 border-red-200',
                                        default => 'text-amber-600 bg-amber-50 border-amber-200'
                                    };
                                @endphp
                                <span class="inline-block mt-0.5 px-2 py-0.5 rounded text-[10px] font-bold border {{ $bayarColor }}">
                                    {{ strtoupper($bayarStatus) }}
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
                                <!-- Tombol Pop-up Detail Cepat -->
                                <button type="button" onclick="showDetailModal('{{ $p->id_pesanan }}')" class="px-3.5 py-1.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white text-xs font-bold shadow-sm shadow-brand-600/20 transition inline-flex items-center gap-1.5">
                                    <i class="fa-solid fa-eye text-[11px]"></i>
                                    <span>Detail</span>
                                </button>
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

<!-- ======================================================== -->
<!-- MODAL POP-UP DETAIL PESANAN CEPAT                        -->
<!-- ======================================================== -->
<div id="detailPesananModal" class="hidden fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
    <div class="bg-white rounded-3xl border border-slate-200 shadow-2xl max-w-2xl w-full max-h-[90vh] flex flex-col overflow-hidden">
        
        <!-- Header Modal -->
        <div class="px-6 py-4 border-b border-slate-200 flex items-center justify-between bg-slate-50">
            <div class="flex items-center gap-3">
                <div class="w-10 h-10 rounded-xl bg-brand-50 text-brand-600 flex items-center justify-center font-bold">
                    <i class="fa-solid fa-receipt"></i>
                </div>
                <div>
                    <h3 class="text-base font-extrabold text-slate-900" id="modalKodePesanan">Memuat...</h3>
                    <p class="text-xs text-slate-400" id="modalTanggalPesanan">-</p>
                </div>
            </div>
            <button onclick="closeDetailModal()" class="w-8 h-8 rounded-lg flex items-center justify-center text-slate-400 hover:text-slate-700 hover:bg-slate-200 transition">
                <i class="fa-solid fa-xmark text-sm"></i>
            </button>
        </div>

        <!-- Body Modal (Scrollable) -->
        <div class="p-6 overflow-y-auto space-y-5 text-xs text-slate-600 flex-1">
            <!-- Informasi Pelanggan & Alamat -->
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 bg-slate-50 p-4 rounded-2xl border border-slate-200/80">
                <div>
                    <span class="text-slate-400 font-bold uppercase text-[10px] tracking-wider block mb-1">Informasi Pemesan</span>
                    <p class="font-bold text-slate-900 text-sm" id="modalNamaPelanggan">-</p>
                    <p class="text-slate-500 mt-0.5" id="modalTelpPelanggan">-</p>
                    <p class="text-slate-500" id="modalEmailPelanggan">-</p>
                </div>
                <div>
                    <span class="text-slate-400 font-bold uppercase text-[10px] tracking-wider block mb-1">Alamat Tujuan Pengiriman</span>
                    <p class="text-slate-800 leading-relaxed" id="modalAlamatKirim">-</p>
                </div>
            </div>

            <!-- Daftar Item Produk yang Dibeli -->
            <div>
                <span class="text-slate-400 font-bold uppercase text-[10px] tracking-wider block mb-2">Item Produk yang Dipesan</span>
                <div class="divide-y divide-slate-100 border border-slate-200 rounded-2xl overflow-hidden" id="modalItemsContainer">
                    <!-- Dynamic Items via JS -->
                </div>
            </div>

            <!-- Total Pembayaran -->
            <div class="flex items-center justify-between p-4 bg-brand-50 rounded-2xl border border-brand-100">
                <div>
                    <span class="text-brand-700 font-bold block">Total Tagihan Belanja</span>
                    <span class="text-[11px] text-brand-600" id="modalMetodeBayar">-</span>
                </div>
                <div class="text-right">
                    <span class="text-lg font-extrabold text-brand-700" id="modalTotalFormatted">Rp 0</span>
                </div>
            </div>

            <!-- Form Ubah Status, Percobaan Pembayaran, & Kurir Langsung dari Pop-up -->
            <form id="modalUpdateForm" method="POST" class="p-5 bg-slate-50 rounded-2xl border border-slate-200/80 space-y-4">
                @csrf
                @method('PATCH')
                <div class="flex items-center justify-between border-b border-slate-200 pb-2">
                    <span class="text-slate-800 font-bold uppercase text-[11px] tracking-wider">Aksi Cepat Admin (Status, Pembayaran & Resi)</span>
                </div>
                
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    <!-- 1. Status Pesanan -->
                    <div>
                        <label class="block text-[10px] font-bold text-slate-500 uppercase mb-1">Status Pesanan</label>
                        <select name="status_pesanan" id="modalSelectStatus" onchange="toggleKurirInputs()" class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs font-semibold bg-white">
                            <option value="baru">Baru</option>
                            <option value="menunggu_verifikasi">Menunggu Verifikasi</option>
                            <option value="diproses">Diproses (Packing)</option>
                            <option value="dikirim">Dikirim</option>
                            <option value="selesai">Selesai</option>
                            <option value="batal">Batal</option>
                        </select>
                    </div>

                    <!-- 2. Status Pembayaran -->
                    <div>
                        <label class="block text-[10px] font-bold text-slate-500 uppercase mb-1">
                            Status Pembayaran
                        </label>
                        <select name="status_bayar" id="modalSelectBayar" class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs font-bold bg-white text-slate-800">
                            <option value="pending">PENDING (Belum Bayar)</option>
                            <option value="paid">DIBAYAR / PAID (Lunas)</option>
                            <option value="cancel">CANCEL (Dibatalkan)</option>
                        </select>
                    </div>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4 pt-1 border-t border-slate-200/60" id="kurirSection">
                    <!-- 3. Pilihan 3 Kurir Resmi -->
                    <div>
                        <label class="block text-[10px] font-bold text-slate-500 uppercase mb-1">Kurir Pengiriman</label>
                        <select name="kurir" id="modalSelectKurir" onchange="autoUpdateResiPrefix()" class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs font-semibold bg-white">
                            <option value="Internal">Internal (Kurir Toko ReRe)</option>
                            <option value="JNE">JNE Ekspedisi</option>
                            <option value="Ojol">Ojol (Gojek / Grab Express)</option>
                        </select>
                    </div>

                    <!-- 4. Nomor Resi & Tombol Auto-Generate -->
                    <div>
                        <label class="block text-[10px] font-bold text-slate-500 uppercase mb-1 flex items-center justify-between">
                            <span>Nomor Resi</span>
                            <button type="button" onclick="generateResiOtomatis()" class="text-brand-600 hover:text-brand-800 font-bold inline-flex items-center gap-1 text-[10px]">
                                <i class="fa-solid fa-arrows-rotate"></i>
                                <span>Generate Resi Otomatis</span>
                            </button>
                        </label>
                        <div class="relative">
                            <input type="text" name="resi" id="modalInputResi" placeholder="Contoh: JNE12345 / Klik Generate..." class="w-full pl-3 pr-20 py-2 rounded-xl border border-slate-200 text-xs font-mono bg-white">
                            <button type="button" onclick="generateResiOtomatis()" class="absolute right-1 top-1 bottom-1 px-2.5 bg-slate-100 hover:bg-slate-200 rounded-lg text-[10px] font-bold text-slate-700 transition">
                                Buat Otomatis
                            </button>
                        </div>
                    </div>
                </div>

                <div class="pt-2 text-right">
                    <button type="submit" class="px-5 py-2.5 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-bold text-xs shadow-md shadow-brand-600/20 transition">
                        Simpan Perubahan Pesanan
                    </button>
                </div>
            </form>
        </div>

        <!-- Footer Modal -->
        <div class="px-6 py-3 border-t border-slate-200 flex justify-end bg-white">
            <button type="button" onclick="closeDetailModal()" class="px-4 py-2 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-xs transition">
                Tutup Pop-up
            </button>
        </div>

    </div>
</div>
@endsection

@push('scripts')
<script>
    let currentPesananId = null;

    function showDetailModal(idPesanan) {
        currentPesananId = idPesanan;
        const modal = document.getElementById('detailPesananModal');
        modal.classList.remove('hidden');

        document.getElementById('modalKodePesanan').innerText = 'Memuat data #' + idPesanan + '...';
        document.getElementById('modalItemsContainer').innerHTML = '<div class="p-4 text-center text-slate-400">Mengambil data dari server...</div>';

        fetch(`/admin/pesanan/${idPesanan}`, {
            headers: {
                'Accept': 'application/json',
                'X-Requested-With': 'XMLHttpRequest'
            }
        })
        .then(res => res.json())
        .then(data => {
            document.getElementById('modalKodePesanan').innerText = data.kode_pesanan;
            document.getElementById('modalTanggalPesanan').innerText = 'Dipesan pada: ' + data.tanggal;
            document.getElementById('modalNamaPelanggan').innerText = data.pelanggan.nama;
            document.getElementById('modalTelpPelanggan').innerText = 'Telp: ' + data.no_telp;
            document.getElementById('modalEmailPelanggan').innerText = 'Email: ' + data.pelanggan.email;
            document.getElementById('modalAlamatKirim').innerText = data.alamat_kirim || 'Alamat tidak dicantumkan.';
            document.getElementById('modalMetodeBayar').innerText = 'Metode: ' + data.pembayaran.metode_bayar;
            document.getElementById('modalTotalFormatted').innerText = data.total_formatted;

            // Form action & values
            document.getElementById('modalUpdateForm').action = `/admin/pesanan/${data.id_pesanan}/status`;
            document.getElementById('modalSelectStatus').value = data.status_pesanan;
            
            // Status Bayar (pending / paid / cancel)
            const rawBayar = (data.pembayaran.status_bayar || 'pending').toLowerCase();
            if (rawBayar === 'dibayar' || rawBayar === 'paid') {
                document.getElementById('modalSelectBayar').value = 'paid';
            } else if (rawBayar === 'cancel' || rawBayar === 'cancelled' || rawBayar === 'batal') {
                document.getElementById('modalSelectBayar').value = 'cancel';
            } else {
                document.getElementById('modalSelectBayar').value = 'pending';
            }

            document.getElementById('modalSelectKurir').value = data.pengiriman.kurir || 'Internal';
            document.getElementById('modalInputResi').value = data.pengiriman.resi || '';

            // Render Items
            let itemsHtml = '';
            data.items.forEach(item => {
                const fotoHtml = item.foto 
                    ? `<img src="${item.foto}" class="w-10 h-10 object-cover rounded-lg border border-slate-200">`
                    : `<div class="w-10 h-10 rounded-lg bg-slate-100 flex items-center justify-center text-slate-300"><i class="fa-regular fa-image"></i></div>`;

                itemsHtml += `
                    <div class="p-3 flex items-center justify-between hover:bg-slate-50 transition">
                        <div class="flex items-center gap-3">
                            ${fotoHtml}
                            <div>
                                <p class="font-bold text-slate-900">${item.nama_produk}</p>
                                <span class="text-slate-400 text-[11px]">${item.jumlah} pcs &times; ${item.harga_satuan}</span>
                            </div>
                        </div>
                        <span class="font-extrabold text-slate-900">${item.subtotal}</span>
                    </div>
                `;
            });

            document.getElementById('modalItemsContainer').innerHTML = itemsHtml || '<div class="p-4 text-center text-slate-400">Tidak ada item.</div>';
            toggleKurirInputs();
        })
        .catch(err => {
            document.getElementById('modalKodePesanan').innerText = 'Gagal memuat';
            document.getElementById('modalItemsContainer').innerHTML = '<div class="p-4 text-center text-red-500">Terjadi kesalahan koneksi server.</div>';
        });
    }

    // Tombol Generate Resi Otomatis
    function generateResiOtomatis() {
        const kurir = document.getElementById('modalSelectKurir').value;
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
            generatedResi = 'RERE-INT-' + dateStr + '-' + (currentPesananId || rand);
        }

        document.getElementById('modalInputResi').value = generatedResi;
    }

    function autoUpdateResiPrefix() {
        if (!document.getElementById('modalInputResi').value) {
            generateResiOtomatis();
        }
    }

    function toggleKurirInputs() {
        const status = document.getElementById('modalSelectStatus').value;
        const kurirSection = document.getElementById('kurirSection');

        if (status === 'dikirim' || status === 'selesai') {
            kurirSection.style.opacity = '1';
            if (!document.getElementById('modalInputResi').value) {
                generateResiOtomatis();
            }
        } else {
            kurirSection.style.opacity = '0.6';
        }
    }

    function closeDetailModal() {
        document.getElementById('detailPesananModal').classList.add('hidden');
    }
</script>
@endpush
