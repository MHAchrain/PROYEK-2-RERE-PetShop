@extends('admin.layouts.app')

@section('title', 'Data Pengiriman & Ekspedisi')
@section('page_title', 'Manajemen Pengiriman & Ekspedisi')

@section('content')
<div class="space-y-6">

    <div class="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-4">
        <form method="GET" action="{{ route('admin.pengiriman.index') }}" class="flex flex-1 flex-wrap items-center gap-3">
            <div class="relative flex-1 min-w-[220px]">
                <span class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
                    <i class="fa-solid fa-magnifying-glass text-xs"></i>
                </span>
                <input type="text" name="search" value="{{ request('search') }}" placeholder="Cari kurir, no resi, pembeli..."
                    class="w-full pl-9 pr-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-brand-600 bg-white">
            </div>

            <select name="status_kirim" onchange="this.form.submit()" class="py-2 px-3 rounded-xl border border-slate-200 text-xs text-slate-700 bg-white">
                <option value="">Semua Status Pengiriman</option>
                <option value="pending" {{ request('status_kirim') == 'pending' ? 'selected' : '' }}>Pending / Siap Kirim</option>
                <option value="dikirim" {{ request('status_kirim') == 'dikirim' ? 'selected' : '' }}>Dalam Perjalanan</option>
                <option value="terkirim" {{ request('status_kirim') == 'terkirim' ? 'selected' : '' }}>Terkirim</option>
            </select>

            @if(request('search') || request('status_kirim'))
                <a href="{{ route('admin.pengiriman.index') }}" class="text-xs text-slate-500 hover:text-brand-600 font-semibold px-2">Reset</a>
            @endif
        </form>

        <a href="{{ route('admin.pengiriman.export') }}" class="px-3.5 py-2 rounded-xl border border-emerald-200 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 font-bold text-xs flex items-center gap-2 shadow-sm transition">
            <i class="fa-solid fa-file-excel text-emerald-600"></i>
            <span>Export Data Pengiriman</span>
        </a>
    </div>

    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left text-sm text-slate-600">
                <thead class="bg-slate-50 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-200">
                    <tr>
                        <th class="py-3 px-6">ID / Pesanan</th>
                        <th class="py-3 px-6">Penerima & Alamat</th>
                        <th class="py-3 px-6">Kurir Ekspedisi</th>
                        <th class="py-3 px-6">Nomor Resi</th>
                        <th class="py-3 px-6">Status Kirim</th>
                        <th class="py-3 px-6 text-right w-28">Update</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    @forelse($pengirimans as $p)
                        <tr class="hover:bg-slate-50/80 transition text-xs">
                            <td class="py-3.5 px-6 font-mono font-bold text-slate-900">
                                <a href="{{ route('admin.pesanan.show', $p->id_pesanan) }}" class="text-brand-600 hover:underline">
                                    {{ $p->pesanan ? $p->pesanan->kode_pesanan : '#' . $p->id_pesanan }}
                                </a>
                            </td>
                            <td class="py-3.5 px-6 max-w-xs">
                                <p class="font-bold text-slate-900">{{ $p->pesanan->pelanggan->nama ?? 'Customer' }}</p>
                                <span class="text-slate-400 text-[11px] truncate block">{{ $p->pesanan->alamat_kirim ?? '-' }}</span>
                            </td>
                            <td class="py-3.5 px-6 font-semibold text-slate-800">
                                {{ $p->kurir ?? 'JNE / J&T / SiCepat' }}
                            </td>
                            <td class="py-3.5 px-6 font-mono font-bold text-slate-800">
                                {{ $p->resi ?? 'Belum ada resi' }}
                            </td>
                            <td class="py-3.5 px-6">
                                <span class="px-2.5 py-1 rounded-full text-[11px] font-bold {{ $p->status_kirim == 'terkirim' ? 'bg-emerald-100 text-emerald-800' : ($p->status_kirim == 'dikirim' ? 'bg-indigo-100 text-indigo-800' : 'bg-amber-100 text-amber-800') }}">
                                    {{ ucfirst($p->status_kirim) }}
                                </span>
                            </td>
                            <td class="py-3.5 px-6 text-right">
                                <button onclick="openModalEdit('{{ $p->id_pengiriman }}', '{{ $p->kurir }}', '{{ $p->resi }}', '{{ $p->status_kirim }}')" class="px-3 py-1.5 rounded-lg border border-slate-200 hover:bg-slate-50 text-slate-700 font-bold transition inline-block">
                                    Edit Resi
                                </button>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="6" class="text-center py-10 text-slate-400 text-sm">
                                Tidak ada data pengiriman yang ditemukan.
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        @if($pengirimans->hasPages())
            <div class="p-4 border-t border-slate-200 bg-slate-50">
                {{ $pengirimans->links() }}
            </div>
        @endif
    </div>

</div>

<!-- MODAL EDIT PENGIRIMAN -->
<div id="editPengirimanModal" class="hidden fixed inset-0 bg-slate-900/50 backdrop-blur-sm z-50 flex items-center justify-center p-4">
    <div class="bg-white rounded-3xl border border-slate-200 shadow-2xl max-w-md w-full p-6 space-y-4">
        <div class="flex items-center justify-between pb-3 border-b border-slate-100">
            <h3 class="text-base font-bold text-slate-900">Perbarui Ekspedisi & Resi</h3>
            <button onclick="document.getElementById('editPengirimanModal').classList.add('hidden')" class="text-slate-400 hover:text-slate-600">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <form id="editPengirimanForm" method="POST" class="space-y-4">
            @csrf
            @method('PATCH')
            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Kurir</label>
                <input type="text" name="kurir" id="modalKurir" required class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs">
            </div>
            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Nomor Resi</label>
                <input type="text" name="resi" id="modalResi" placeholder="Masukkan nomor resi..." class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs font-mono">
            </div>
            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Status Pengiriman</label>
                <select name="status_kirim" id="modalStatus" class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs">
                    <option value="pending">Pending</option>
                    <option value="dikirim">Dikirim</option>
                    <option value="terkirim">Terkirim</option>
                </select>
            </div>
            <div class="flex items-center justify-end gap-2 pt-3 border-t border-slate-100">
                <button type="button" onclick="document.getElementById('editPengirimanModal').classList.add('hidden')" class="px-4 py-2 rounded-xl text-xs font-bold text-slate-600 hover:bg-slate-100">
                    Batal
                </button>
                <button type="submit" class="px-4 py-2 rounded-xl text-xs font-bold bg-brand-600 hover:bg-brand-700 text-white shadow-md shadow-brand-600/20">
                    Simpan Perubahan
                </button>
            </div>
        </form>
    </div>
</div>
@endsection

@push('scripts')
<script>
    function openModalEdit(id, kurir, resi, status) {
        const modal = document.getElementById('editPengirimanModal');
        const form = document.getElementById('editPengirimanForm');
        form.action = `/admin/pengiriman/${id}`;
        document.getElementById('modalKurir').value = kurir;
        document.getElementById('modalResi').value = resi;
        document.getElementById('modalStatus').value = status;
        modal.classList.remove('hidden');
    }
</script>
@endpush
