@extends('admin.layouts.app')

@section('title', 'Daftar Paket Grooming')
@section('page_title', 'Manajemen Paket Layanan Grooming')

@section('content')
<div class="space-y-6">

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- FORM TAMBAH LAYANAN (1 Col) -->
        <div class="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm h-fit">
            <h3 class="text-sm font-bold text-slate-900 mb-1">Tambah Paket Baru</h3>
            <p class="text-xs text-slate-400 mb-4">Buat jenis perawatan atau paket grooming</p>

            <form action="{{ route('admin.grooming.service.store') }}" method="POST" class="space-y-4">
                @csrf
                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Nama Layanan</label>
                    <input type="text" name="name" required placeholder="Contoh: Basic Grooming, Anti Kutu"
                        class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-900 focus:ring-2 focus:ring-brand-600">
                </div>

                <div class="grid grid-cols-2 gap-3">
                    <div>
                        <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Harga (Rp)</label>
                        <input type="number" name="price" required min="0" placeholder="75000"
                            class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-900 focus:ring-2 focus:ring-brand-600">
                    </div>
                    <div>
                        <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Durasi (Menit)</label>
                        <input type="number" name="duration_minutes" required min="1" value="60"
                            class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-900 focus:ring-2 focus:ring-brand-600">
                    </div>
                </div>

                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Deskripsi Singkat</label>
                    <textarea name="description" rows="3" placeholder="Fasilitas yang didapat..."
                        class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-900 focus:ring-2 focus:ring-brand-600"></textarea>
                </div>

                <label class="flex items-center gap-2 cursor-pointer pt-1">
                    <input type="checkbox" name="is_active" value="1" checked class="w-4 h-4 rounded text-brand-600">
                    <span class="text-xs font-medium text-slate-700">Aktifkan Layanan</span>
                </label>

                <button type="submit" class="w-full py-2.5 px-4 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-bold text-xs shadow-md shadow-brand-600/20 transition flex items-center justify-center gap-2">
                    <i class="fa-solid fa-plus text-xs"></i>
                    <span>Simpan Paket Layanan</span>
                </button>
            </form>
        </div>

        <!-- LIST PAKET GROOMING (2 Col) -->
        <div class="lg:col-span-2 bg-white rounded-2xl border border-slate-200 shadow-sm p-6">
            <h3 class="text-sm font-bold text-slate-900 mb-4">Daftar Paket Grooming yang Terdaftar</h3>
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                @forelse($services as $s)
                    <div class="p-4 rounded-2xl border border-slate-200 hover:border-brand-300 transition bg-slate-50/50 flex flex-col justify-between shadow-xs">
                        <div>
                            <div class="flex items-center justify-between mb-1.5">
                                <h4 class="font-bold text-sm text-slate-900">{{ $s->name }}</h4>
                                
                                <!-- Tombol Toggle Aktif / Nonaktif Cepat -->
                                <form action="{{ route('admin.grooming.service.toggle', $s->id) }}" method="POST" class="inline-block">
                                    @csrf
                                    @method('PATCH')
                                    <button type="submit" title="Klik untuk ubah status aktif" class="px-2.5 py-0.5 rounded-full text-[10px] font-bold transition flex items-center gap-1 {{ $s->is_active ? 'bg-emerald-100 text-emerald-800 hover:bg-emerald-200' : 'bg-slate-200 text-slate-600 hover:bg-slate-300' }}">
                                        <span class="w-1.5 h-1.5 rounded-full {{ $s->is_active ? 'bg-emerald-500' : 'bg-slate-400' }}"></span>
                                        <span>{{ $s->is_active ? 'Aktif' : 'Nonaktif' }}</span>
                                    </button>
                                </form>
                            </div>
                            <p class="text-xs text-slate-400 line-clamp-2 mt-1">{{ $s->description ?? 'Tidak ada keterangan khusus.' }}</p>
                        </div>

                        <div class="mt-4 pt-3 border-t border-slate-200/80 flex items-center justify-between text-xs">
                            <div>
                                <span class="text-slate-400 block text-[11px]"><i class="fa-regular fa-clock"></i> {{ $s->duration_minutes }} menit</span>
                                <span class="font-extrabold text-brand-600 text-sm">Rp {{ number_format($s->price, 0, ',', '.') }}</span>
                            </div>

                            <!-- Tombol Edit & Hapus -->
                            <div class="flex items-center gap-1">
                                <button type="button" onclick="openEditServiceModal('{{ $s->id }}', '{{ addslashes($s->name) }}', '{{ $s->price }}', '{{ $s->duration_minutes }}', '{{ addslashes($s->description ?? '') }}', {{ $s->is_active ? 'true' : 'false' }})" class="w-7 h-7 rounded-lg text-slate-500 hover:text-brand-600 hover:bg-brand-50 flex items-center justify-center transition" title="Edit Paket">
                                    <i class="fa-solid fa-pen-to-square text-xs"></i>
                                </button>

                                <form action="{{ route('admin.grooming.service.destroy', $s->id) }}" method="POST" onsubmit="return confirm('Hapus paket layanan {{ $s->name }}?')" class="inline-block">
                                    @csrf
                                    @method('DELETE')
                                    <button type="submit" class="w-7 h-7 rounded-lg text-slate-400 hover:text-red-600 hover:bg-red-50 flex items-center justify-center transition" title="Hapus Paket">
                                        <i class="fa-solid fa-trash-can text-xs"></i>
                                    </button>
                                </form>
                            </div>
                        </div>
                    </div>
                @empty
                    <p class="text-xs text-slate-400 col-span-2 text-center py-6">Belum ada paket grooming yang dibuat.</p>
                @endforelse
            </div>
        </div>
    </div>

</div>

<!-- MODAL EDIT PAKET LAYANAN GROOMING -->
<div id="editServiceModal" class="hidden fixed inset-0 bg-slate-900/60 backdrop-blur-xs z-50 flex items-center justify-center p-4">
    <div class="bg-white rounded-3xl border border-slate-200 shadow-2xl max-w-md w-full p-6 space-y-4">
        <div class="flex items-center justify-between pb-3 border-b border-slate-100">
            <h3 class="text-sm font-bold text-slate-900">Edit Paket Layanan Grooming</h3>
            <button onclick="document.getElementById('editServiceModal').classList.add('hidden')" class="text-slate-400 hover:text-slate-600">
                <i class="fa-solid fa-xmark"></i>
            </button>
        </div>

        <form id="editServiceForm" method="POST" class="space-y-4 text-xs">
            @csrf
            @method('PUT')

            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Nama Layanan</label>
                <input type="text" name="name" id="editServiceName" required class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-900">
            </div>

            <div class="grid grid-cols-2 gap-3">
                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Harga (Rp)</label>
                    <input type="number" name="price" id="editServicePrice" required min="0" class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-900">
                </div>
                <div>
                    <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Durasi (Menit)</label>
                    <input type="number" name="duration_minutes" id="editServiceDuration" required min="1" class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-900">
                </div>
            </div>

            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase mb-1">Deskripsi Singkat</label>
                <textarea name="description" id="editServiceDesc" rows="3" class="w-full px-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-900"></textarea>
            </div>

            <label class="flex items-center gap-2 cursor-pointer pt-1">
                <input type="checkbox" name="is_active" id="editServiceActive" value="1" class="w-4 h-4 rounded text-brand-600">
                <span class="text-xs font-medium text-slate-700">Aktifkan Layanan (Tampil di Aplikasi)</span>
            </label>

            <div class="flex items-center justify-end gap-2 pt-3 border-t border-slate-100">
                <button type="button" onclick="document.getElementById('editServiceModal').classList.add('hidden')" class="px-4 py-2 rounded-xl text-xs font-bold text-slate-500 hover:bg-slate-100">
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
    function openEditServiceModal(id, name, price, duration, desc, isActive) {
        const modal = document.getElementById('editServiceModal');
        const form = document.getElementById('editServiceForm');
        form.action = `/admin/grooming/service/${id}`;

        document.getElementById('editServiceName').value = name;
        document.getElementById('editServicePrice').value = Math.floor(price);
        document.getElementById('editServiceDuration').value = duration;
        document.getElementById('editServiceDesc').value = desc;
        document.getElementById('editServiceActive').checked = isActive;

        modal.classList.remove('hidden');
    }
</script>
@endpush
