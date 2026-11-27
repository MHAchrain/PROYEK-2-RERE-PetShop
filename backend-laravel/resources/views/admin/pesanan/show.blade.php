@extends('admin.layouts.app')

@section('title', 'Detail Pesanan ' . $pesanan->kode_pesanan)
@section('page_title', 'Detail Pesanan: ' . $pesanan->kode_pesanan)

@section('content')
<div class="space-y-6">

    <div class="flex items-center justify-between">
        <a href="{{ route('admin.pesanan.index') }}" class="inline-flex items-center gap-2 text-xs font-bold text-slate-500 hover:text-slate-800">
            <i class="fa-solid fa-arrow-left"></i>
            <span>Kembali ke Daftar Pesanan</span>
        </a>

        <div class="flex items-center gap-2">
            <span class="text-xs text-slate-400">Status Saat Ini:</span>
            <span class="px-3 py-1 rounded-full text-xs font-bold bg-slate-900 text-white">
                {{ strtoupper(str_replace('_', ' ', $pesanan->status_pesanan)) }}
            </span>
        </div>
    </div>

    <!-- 2 KOLOM: RINCIAN PRODUK & KONTROL STATUS/PENGIRIMAN -->
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

        <!-- KIRI: ITEM PESANAN & PEMBAYARAN (2 Col) -->
        <div class="lg:col-span-2 space-y-6">
            <!-- TABEL ITEM PRODUK -->
            <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
                <div class="p-5 border-b border-slate-200">
                    <h3 class="text-sm font-bold text-slate-900">Rincian Produk yang Dibeli</h3>
                </div>
                <div class="divide-y divide-slate-100">
                    @forelse($pesanan->details as $item)
                        <div class="p-5 flex items-center justify-between gap-4">
                            <div class="flex items-center gap-4">
                                <div class="w-14 h-14 rounded-xl border border-slate-200 bg-slate-50 overflow-hidden shrink-0 flex items-center justify-center">
                                    @if($item->produk && $item->produk->foto)
                                        <img src="{{ asset('storage/' . $item->produk->foto) }}" alt="" class="w-full h-full object-cover">
                                    @else
                                        <i class="fa-regular fa-image text-slate-300"></i>
                                    @endif
                                </div>
                                <div>
                                    <h4 class="text-sm font-bold text-slate-900">{{ $item->produk->nama_produk ?? 'Produk Dihapus' }}</h4>
                                    <p class="text-xs text-slate-400 mt-0.5">
                                        {{ $item->jumlah }} item &times; Rp {{ number_format($item->harga_satuan, 0, ',', '.') }}
                                    </p>
                                </div>
                            </div>
                            <div class="text-right">
                                <span class="text-sm font-bold text-slate-900">
                                    Rp {{ number_format($item->subtotal, 0, ',', '.') }}
                                </span>
                            </div>
                        </div>
                    @empty
                        <div class="p-6 text-center text-slate-400 text-sm">Tidak ada rincian item.</div>
                    @endforelse
                </div>

                <!-- TOTAL RINGKASAN -->
                <div class="p-5 bg-slate-50 border-t border-slate-200 flex items-center justify-between">
                    <span class="text-sm font-bold text-slate-700">Total Pembayaran</span>
                    <span class="text-xl font-extrabold text-brand-600">
                        Rp {{ number_format($pesanan->total, 0, ',', '.') }}
                    </span>
                </div>
            </div>

            <!-- DETAIL PEMBAYARAN MIDTRANS -->
            <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm space-y-3">
                <h3 class="text-sm font-bold text-slate-900">Informasi Pembayaran</h3>
                <div class="grid grid-cols-2 sm:grid-cols-4 gap-4 text-xs">
                    <div>
                        <span class="text-slate-400 block mb-0.5">Metode Bayar</span>
                        <span class="font-bold text-slate-800">{{ strtoupper($pesanan->pembayaran->metode_bayar ?? 'Online / Gateway') }}</span>
                    </div>
                    <div>
                        <span class="text-slate-400 block mb-0.5">Status Pembayaran</span>
                        <span class="font-bold text-emerald-600">{{ strtoupper($pesanan->pembayaran->status_bayar ?? 'Belum Lunas') }}</span>
                    </div>
                    <div>
                        <span class="text-slate-400 block mb-0.5">Waktu Transaksi</span>
                        <span class="font-medium text-slate-700">{{ $pesanan->pembayaran->waktu_bayar ?? '-' }}</span>
                    </div>
                    <div>
                        <span class="text-slate-400 block mb-0.5">Snap / Ref</span>
                        <span class="font-mono text-slate-600 text-[11px] truncate block">{{ $pesanan->pembayaran->snap_token ?? '-' }}</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- KANAN: PELANGGAN, UPDATE STATUS & RESI (1 Col) -->
        <div class="space-y-6">

            <!-- UPDATE STATUS PESANAN -->
            <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm space-y-4">
                <h3 class="text-sm font-bold text-slate-900">Ubah Status Pesanan</h3>
                <form action="{{ route('admin.pesanan.status', $pesanan->id_pesanan) }}" method="POST" class="space-y-3">
                    @csrf
                    @method('PATCH')
                    <select name="status_pesanan" class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs font-semibold text-slate-800 focus:ring-2 focus:ring-brand-600">
                        <option value="baru" {{ $pesanan->status_pesanan == 'baru' ? 'selected' : '' }}>Baru</option>
                        <option value="menunggu_verifikasi" {{ $pesanan->status_pesanan == 'menunggu_verifikasi' ? 'selected' : '' }}>Menunggu Verifikasi</option>
                        <option value="diproses" {{ $pesanan->status_pesanan == 'diproses' ? 'selected' : '' }}>Diproses (Sedang Dikemas)</option>
                        <option value="dikirim" {{ $pesanan->status_pesanan == 'dikirim' ? 'selected' : '' }}>Dikirim (Dalam Ekspedisi)</option>
                        <option value="selesai" {{ $pesanan->status_pesanan == 'selesai' ? 'selected' : '' }}>Selesai</option>
                        <option value="batal" {{ $pesanan->status_pesanan == 'batal' ? 'selected' : '' }}>Batal</option>
                    </select>
                    <button type="submit" class="w-full py-2 px-4 rounded-xl bg-slate-900 hover:bg-slate-800 text-white font-bold text-xs transition">
                        Update Status
                    </button>
                </form>
            </div>

            <!-- UPDATE INFORMASI PENGIRIMAN & RESI -->
            <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm space-y-4">
                <h3 class="text-sm font-bold text-slate-900">Kurir & Nomor Resi</h3>
                <form action="{{ route('admin.pesanan.pengiriman', $pesanan->id_pesanan) }}" method="POST" class="space-y-3">
                    @csrf
                    @method('PATCH')
                    <div>
                        <label class="block text-[11px] font-bold text-slate-400 uppercase mb-1">Kurir Ekspedisi</label>
                        <input type="text" name="kurir" value="{{ old('kurir', $pesanan->pengiriman->kurir ?? 'JNE / J&T / SiCepat') }}" required
                            class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-800 focus:ring-2 focus:ring-brand-600">
                    </div>
                    <div>
                        <label class="block text-[11px] font-bold text-slate-400 uppercase mb-1">Nomor Resi</label>
                        <input type="text" name="resi" value="{{ old('resi', $pesanan->pengiriman->resi ?? '') }}" placeholder="Contoh: JP123456789"
                            class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs font-mono text-slate-800 focus:ring-2 focus:ring-brand-600">
                    </div>
                    <div>
                        <label class="block text-[11px] font-bold text-slate-400 uppercase mb-1">Status Pengiriman</label>
                        <select name="status_kirim" class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-800 focus:ring-2 focus:ring-brand-600">
                            <option value="pending" {{ ($pesanan->pengiriman->status_kirim ?? '') == 'pending' ? 'selected' : '' }}>Menunggu Pickup</option>
                            <option value="dikirim" {{ ($pesanan->pengiriman->status_kirim ?? '') == 'dikirim' ? 'selected' : '' }}>Sedang Dikirim</option>
                            <option value="terkirim" {{ ($pesanan->pengiriman->status_kirim ?? '') == 'terkirim' ? 'selected' : '' }}>Telah Diterima</option>
                        </select>
                    </div>
                    <button type="submit" class="w-full py-2 px-4 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-bold text-xs shadow-md shadow-brand-600/20 transition">
                        Simpan Resi Pengiriman
                    </button>
                </form>
            </div>

            <!-- INFORMASI PELANGGAN & TUJUAN -->
            <div class="bg-white p-5 rounded-2xl border border-slate-200 shadow-sm space-y-3">
                <h3 class="text-sm font-bold text-slate-900">Tujuan Pengiriman</h3>
                <div class="text-xs space-y-2">
                    <div>
                        <span class="text-slate-400 block mb-0.5">Penerima</span>
                        <p class="font-bold text-slate-800">{{ $pesanan->pelanggan->nama ?? 'Customer' }}</p>
                    </div>
                    <div>
                        <span class="text-slate-400 block mb-0.5">Kontak / Telepon</span>
                        <p class="font-semibold text-slate-700">{{ $pesanan->no_telp ?? $pesanan->pelanggan->no_hp ?? '-' }}</p>
                    </div>
                    <div>
                        <span class="text-slate-400 block mb-0.5">Alamat Lengkap</span>
                        <p class="text-slate-700 bg-slate-50 p-3 rounded-xl border border-slate-100 leading-relaxed">
                            {{ $pesanan->alamat_kirim }}
                        </p>
                    </div>
                </div>
            </div>

        </div>

    </div>

</div>
@endsection
