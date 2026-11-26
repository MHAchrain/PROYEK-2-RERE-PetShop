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
<!-- MODAL POP-UP DETAIL PESANAN CEPAT & SIMPLE               -->
<!-- ======================================================== -->
<div id="detailPesananModal" class="hidden fixed inset-0 bg-slate-900/50 backdrop-blur-xs z-50 flex items-center justify-center p-3 sm:p-4">
    <div class="bg-white rounded-2xl border border-slate-200 shadow-xl max-w-lg w-full max-h-[88vh] flex flex-col overflow-hidden">
        
        <!-- Header Modal Sederhana -->
        <div class="px-5 py-3.5 border-b border-slate-200 flex items-center justify-between bg-white">
            <div class="flex items-center gap-2.5">
                <div class="w-8 h-8 rounded-lg bg-brand-50 text-brand-600 flex items-center justify-center font-bold text-xs">
                    <i class="fa-solid fa-receipt"></i>
                </div>
                <div>
                    <h3 class="text-sm font-bold text-slate-900" id="modalKodePesanan">Pesanan</h3>
                    <p class="text-[11px] text-slate-400" id="modalTanggalPesanan">-</p>
                </div>
            </div>
            <button onclick="closeDetailModal()" class="w-7 h-7 rounded-lg flex items-center justify-center text-slate-400 hover:text-slate-700 hover:bg-slate-100 transition">
                <i class="fa-solid fa-xmark text-xs"></i>
            </button>
        </div>

        <!-- Body Modal Ringkas & Padat -->
        <div class="p-5 overflow-y-auto space-y-4 text-xs text-slate-600 flex-1">
            <!-- Info Pembeli Ringkas -->
            <div class="bg-slate-50 p-3 rounded-xl border border-slate-200/80 space-y-1 text-xs">
                <div class="flex items-center justify-between">
                    <span class="font-bold text-slate-900" id="modalNamaPelanggan">-</span>
                    <span class="font-mono text-slate-500 text-[11px]" id="modalTelpPelanggan">-</span>
                </div>
                <p class="text-slate-600 text-[11px] line-clamp-2" id="modalAlamatKirim">-</p>
            </div>

            <!-- Rincian Produk -->
            <div>
                <span class="text-slate-400 font-bold uppercase text-[10px] tracking-wider block mb-1.5">Produk Dipesan</span>
                <div class="divide-y divide-slate-100 border border-slate-200 rounded-xl overflow-hidden max-h-44 overflow-y-auto" id="modalItemsContainer">
                    <!-- Dynamic Items -->
                </div>
            </div>

            <!-- Total Ringkas -->
            <div class="flex items-center justify-between px-3.5 py-2.5 bg-brand-50 rounded-xl border border-brand-100">
                <span class="text-brand-700 font-bold text-xs" id="modalMetodeBayar">Total Tagihan</span>
                <span class="text-base font-extrabold text-brand-700" id="modalTotalFormatted">Rp 0</span>
            </div>

            <!-- Form Aksi Cepat Sederhana -->
            <form id="modalUpdateForm" method="POST" class="p-3.5 bg-slate-50 rounded-xl border border-slate-200/80 space-y-3">
                @csrf
                @method('PATCH')
                
                <div class="grid grid-cols-2 gap-2.5">
                    <div>
                        <label class="block text-[10px] font-bold text-slate-500 uppercase mb-1">Status Pesanan</label>
                        <select name="status_pesanan" id="modalSelectStatus" onchange="toggleKurirInputs()" class="w-full px-2.5 py-1.5 rounded-lg border border-slate-200 text-xs font-semibold bg-white">
                            <option value="baru">Baru</option>
                            <option value="menunggu_verifikasi">Menunggu Verifikasi</option>
                            <option value="diproses">Diproses</option>
                            <option value="dikirim">Dikirim</option>
                            <option value="selesai">Selesai</option>
                            <option value="batal">Batal</option>
                        </select>
                    </div>

                    <div>
                        <label class="block text-[10px] font-bold text-slate-500 uppercase mb-1">Status Pembayaran</label>
                        <select name="status_bayar" id="modalSelectBayar" class="w-full px-2.5 py-1.5 rounded-lg border border-slate-200 text-xs font-bold bg-white text-slate-800">
                            <option value="pending">PENDING</option>
                            <option value="paid">DIBAYAR / PAID</option>
                            <option value="cancel">CANCEL</option>
                        </select>
                    </div>
                </div>

                <div class="grid grid-cols-2 gap-2.5 pt-2 border-t border-slate-200/60" id="kurirSection">
                    <div>
                        <label class="block text-[10px] font-bold text-slate-500 uppercase mb-1">Kurir (3 Pilihan)</label>
                        <select name="kurir" id="modalSelectKurir" onchange="autoUpdateResiPrefix()" class="w-full px-2.5 py-1.5 rounded-lg border border-slate-200 text-xs font-semibold bg-white">
                            <option value="Internal">Internal (Toko ReRe)</option>
                            <option value="JNE">JNE</option>
                            <option value="Ojol">Ojol</option>
                        </select>
                    </div>

                    <div>
                        <div class="flex items-center justify-between mb-1">
                            <label class="text-[10px] font-bold text-slate-500 uppercase">Resi</label>
                            <button type="button" onclick="generateResiOtomatis()" class="text-brand-600 hover:text-brand-800 font-bold text-[10px]">
                                Generate
                            </button>
                        </div>
                        <input type="text" name="resi" id="modalInputResi" placeholder="Nomor resi..." class="w-full px-2.5 py-1.5 rounded-lg border border-slate-200 text-xs font-mono bg-white">
                    </div>
                </div>

                <div class="pt-1 flex items-center justify-end gap-2">
                    <button type="button" onclick="closeDetailModal()" class="px-3 py-1.5 rounded-lg text-xs font-bold text-slate-500 hover:bg-slate-200">
                        Batal
                    </button>
                    <button type="submit" class="px-4 py-1.5 rounded-lg bg-brand-600 hover:bg-brand-700 text-white font-bold text-xs shadow-sm transition">
                        Simpan
                    </button>
                </div>
            </form>
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
