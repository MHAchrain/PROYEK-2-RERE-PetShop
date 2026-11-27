@extends('admin.layouts.app')

@section('title', 'Kategori Produk')
@section('page_title', 'Manajemen Kategori Produk')

@section('content')
@php
    $iconOptions = [
        'Wrench' => ['fa' => 'fa-solid fa-wrench', 'label' => 'Peralatan'],
        'Puzzle' => ['fa' => 'fa-solid fa-puzzle-piece', 'label' => 'Mainan'],
        'Pill' => ['fa' => 'fa-solid fa-capsules', 'label' => 'Obat'],
        'Fish' => ['fa' => 'fa-solid fa-fish', 'label' => 'Makanan'],
        'Bone' => ['fa' => 'fa-solid fa-bone', 'label' => 'Snack'],
        'Cat' => ['fa' => 'fa-solid fa-cat', 'label' => 'Kucing'],
        'Dog' => ['fa' => 'fa-solid fa-dog', 'label' => 'Anjing'],
        'Heart' => ['fa' => 'fa-solid fa-heart', 'label' => 'Perawatan'],
        'ShoppingBag' => ['fa' => 'fa-solid fa-bag-shopping', 'label' => 'Aksesoris'],
        'Box' => ['fa' => 'fa-solid fa-box', 'label' => 'Lainnya'],
    ];
    $defaultIconByName = [
        'Equipment' => 'Wrench',
        'Toys' => 'Puzzle',
        'Medicine' => 'Pill',
        'Food' => 'Fish',
    ];
@endphp
<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">

    <!-- FORM TAMBAH KATEGORI (1 Col) -->
    <div class="bg-white p-6 rounded-2xl border border-slate-200 shadow-sm h-fit">
        <h3 class="text-sm font-bold text-slate-900 mb-1">Tambah Kategori Baru</h3>
        <p class="text-xs text-slate-400 mb-4">Kelompokkan produk agar mudah ditemukan pembeli</p>

        <form action="{{ route('admin.kategori.store') }}" method="POST" class="space-y-4">
            @csrf
            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Nama Kategori</label>
                <input type="text" name="nama_kategori" value="{{ old('nama_kategori') }}" required placeholder="Contoh: Makanan Kucing, Shampo, dll"
                    class="w-full px-4 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-brand-600">
            </div>

            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Pilih Icon</label>
                <div class="grid grid-cols-5 gap-2">
                    @foreach($iconOptions as $iconKey => $opt)
                        <label class="cursor-pointer">
                            <input type="radio" name="icon" value="{{ $iconKey }}" class="peer sr-only" {{ old('icon', 'Box') === $iconKey ? 'checked' : '' }}>
                            <div class="flex items-center justify-center p-2.5 rounded-xl border border-slate-200 text-slate-500 peer-checked:border-brand-600 peer-checked:bg-brand-50 peer-checked:text-brand-600 hover:bg-slate-50 transition" title="{{ $opt['label'] }}">
                                <i class="{{ $opt['fa'] }} text-base"></i>
                            </div>
                        </label>
                    @endforeach
                </div>
            </div>

            <button type="submit" class="w-full py-2.5 px-4 rounded-xl bg-brand-600 hover:bg-brand-700 text-white font-bold text-xs shadow-md shadow-brand-600/20 transition flex items-center justify-center gap-2">
                <i class="fa-solid fa-plus text-xs"></i>
                <span>Simpan Kategori</span>
            </button>
        </form>
    </div>

    <!-- TABEL LIST KATEGORI (2 Col) -->
    <div class="lg:col-span-2 bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="p-5 border-b border-slate-200 flex items-center justify-between">
            <h3 class="text-sm font-bold text-slate-900">Daftar Kategori</h3>
            <a href="{{ route('admin.kategori.export') }}" class="px-3 py-1.5 rounded-xl border border-emerald-200 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 font-bold text-xs flex items-center gap-2 transition">
                <i class="fa-solid fa-file-excel text-emerald-600"></i>
                <span>Export Excel</span>
            </a>
        </div>

        <div class="overflow-x-auto">
            <table class="w-full text-left text-sm text-slate-600">
                <thead class="bg-slate-50 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-200">
                    <tr>
                        <th class="py-3 px-6">Nama Kategori</th>
                        <th class="py-3 px-6">Jumlah Produk</th>
                        <th class="py-3 px-6 text-right w-28">Aksi</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    @forelse($kategoris as $k)
                        @php
                            $resolvedIcon = $k->icon ?: ($defaultIconByName[$k->nama_kategori] ?? 'Box');
                            $faClass = $iconOptions[$resolvedIcon]['fa'] ?? 'fa-solid fa-box';
                        @endphp
                        <tr class="hover:bg-slate-50/80 transition">
                            <td class="py-3.5 px-6 font-bold text-slate-900">
                                <div class="flex items-center gap-3">
                                    <span class="w-8 h-8 rounded-lg bg-slate-100 text-slate-700 inline-flex items-center justify-center">
                                        <i class="{{ $faClass }} text-xs"></i>
                                    </span>
                                    <span>{{ $k->nama_kategori }}</span>
                                </div>
                            </td>
                            <td class="py-3.5 px-6">
                                <span class="bg-slate-100 text-slate-700 px-2.5 py-1 rounded-full text-xs font-semibold">
                                    {{ $k->produks_count }} produk
                                </span>
                            </td>
                            <td class="py-3.5 px-6 text-right">
                                <div class="inline-flex items-center gap-1 justify-end">
                                    <button type="button"
                                        onclick='openEditKategori(@json(["id" => $k->id_kategori, "nama" => $k->nama_kategori, "icon" => $resolvedIcon]))'
                                        class="w-8 h-8 rounded-lg text-slate-400 hover:text-blue-600 hover:bg-blue-50 inline-flex items-center justify-center transition" title="Edit Kategori">
                                        <i class="fa-solid fa-pen-to-square text-xs"></i>
                                    </button>
                                    <form action="{{ route('admin.kategori.destroy', $k->id_kategori) }}" method="POST" class="inline-block" onsubmit="return confirm('Hapus kategori ini?')">
                                        @csrf
                                        @method('DELETE')
                                        <button type="submit" class="w-8 h-8 rounded-lg text-slate-400 hover:text-red-600 hover:bg-red-50 inline-flex items-center justify-center transition" title="Hapus Kategori">
                                            <i class="fa-solid fa-trash-can text-xs"></i>
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="3" class="text-center py-8 text-slate-400 text-sm">
                                Belum ada kategori yang dibuat.
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        @if($kategoris->hasPages())
            <div class="p-4 border-t border-slate-200 bg-slate-50">
                {{ $kategoris->links() }}
            </div>
        @endif
    </div>

</div>

<!-- MODAL EDIT KATEGORI -->
<div id="editKategoriModal" class="fixed inset-0 z-50 hidden items-center justify-center bg-slate-900/50 backdrop-blur-sm p-4">
    <div class="bg-white rounded-2xl shadow-xl w-full max-w-md overflow-hidden border border-slate-200">
        <div class="px-5 py-4 border-b border-slate-100 flex items-center justify-between bg-slate-50">
            <h4 class="text-sm font-bold text-slate-900">Edit Kategori</h4>
            <button type="button" onclick="closeEditKategori()" class="text-slate-400 hover:text-slate-600 text-lg">&times;</button>
        </div>
        <form id="editKategoriForm" method="POST" class="p-5 space-y-4">
            @csrf
            @method('PUT')
            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Nama Kategori</label>
                <input type="text" id="editNamaKategori" name="nama_kategori" required
                    class="w-full px-4 py-2.5 rounded-xl border border-slate-200 text-sm text-slate-900 focus:outline-none focus:ring-2 focus:ring-brand-600">
            </div>
            <div>
                <label class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Pilih Icon</label>
                <div class="grid grid-cols-5 gap-2">
                    @foreach($iconOptions as $iconKey => $opt)
                        <label class="cursor-pointer">
                            <input type="radio" name="icon" value="{{ $iconKey }}" class="peer sr-only edit-icon-radio">
                            <div class="flex items-center justify-center p-2.5 rounded-xl border border-slate-200 text-slate-500 peer-checked:border-brand-600 peer-checked:bg-brand-50 peer-checked:text-brand-600 hover:bg-slate-50 transition" title="{{ $opt['label'] }}">
                                <i class="{{ $opt['fa'] }} text-base"></i>
                            </div>
                        </label>
                    @endforeach
                </div>
            </div>
            <div class="flex justify-end gap-2 pt-2">
                <button type="button" onclick="closeEditKategori()" class="px-4 py-2 rounded-lg border border-slate-200 text-xs font-bold text-slate-600 hover:bg-slate-50">Batal</button>
                <button type="submit" class="px-4 py-2 rounded-lg bg-brand-600 hover:bg-brand-700 text-white text-xs font-bold">Simpan Perubahan</button>
            </div>
        </form>
    </div>
</div>

<script>
function openEditKategori(data) {
    document.getElementById('editKategoriForm').action = "{{ url('/admin/kategori') }}/" + data.id;
    document.getElementById('editNamaKategori').value = data.nama || '';
    document.querySelectorAll('.edit-icon-radio').forEach(el => {
        el.checked = (el.value === (data.icon || 'Box'));
    });
    const modal = document.getElementById('editKategoriModal');
    modal.classList.remove('hidden');
    modal.classList.add('flex');
}

function closeEditKategori() {
    const modal = document.getElementById('editKategoriModal');
    modal.classList.add('hidden');
    modal.classList.remove('flex');
}
</script>
@endsection
