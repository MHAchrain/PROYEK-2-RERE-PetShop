@extends('admin.layouts.app')

@section('title', 'Data Pelanggan')
@section('page_title', 'Data Pelanggan Terdaftar')

@section('content')
<div class="space-y-6">

    <!-- CARI & EXPORT -->
    <div class="flex flex-col sm:flex-row items-stretch sm:items-center justify-between gap-4">
        <form method="GET" action="{{ route('admin.pelanggan.index') }}" class="flex flex-1 items-center gap-3">
            <div class="relative flex-1 max-w-md">
                <span class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
                    <i class="fa-solid fa-magnifying-glass text-xs"></i>
                </span>
                <input type="text" name="search" value="{{ request('search') }}" placeholder="Cari nama, email, nomor HP, kota..."
                    class="w-full pl-9 pr-3 py-2 rounded-xl border border-slate-200 text-xs text-slate-800 placeholder-slate-400 focus:outline-none focus:ring-2 focus:ring-brand-600 bg-white">
            </div>
            @if(request('search'))
                <a href="{{ route('admin.pelanggan.index') }}" class="text-xs text-slate-500 hover:text-brand-600 font-semibold px-2">Reset</a>
            @endif
        </form>

        <a href="{{ route('admin.pelanggan.export') }}" class="px-3.5 py-2 rounded-xl border border-emerald-200 bg-emerald-50 hover:bg-emerald-100 text-emerald-700 font-bold text-xs flex items-center gap-2 shadow-sm transition">
            <i class="fa-solid fa-file-excel text-emerald-600"></i>
            <span>Export Data Pelanggan</span>
        </a>
    </div>

    <!-- TABEL PELANGGAN -->
    <div class="bg-white rounded-2xl border border-slate-200 shadow-sm overflow-hidden">
        <div class="overflow-x-auto">
            <table class="w-full text-left text-sm text-slate-600">
                <thead class="bg-slate-50 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-200">
                    <tr>
                        <th class="py-3 px-6">ID</th>
                        <th class="py-3 px-6">Nama Lengkap</th>
                        <th class="py-3 px-6">Email</th>
                        <th class="py-3 px-6">No. Telepon / WA</th>
                        <th class="py-3 px-6">Alamat</th>
                        <th class="py-3 px-6 text-right w-24">Aksi</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100">
                    @forelse($pelanggans as $p)
                        <tr class="hover:bg-slate-50/80 transition">
                            <td class="py-3.5 px-6 font-mono text-xs text-slate-400">
                                {{ $p->kode_pelanggan }}
                            </td>
                            <td class="py-3.5 px-6 font-bold text-slate-900">
                                {{ $p->nama }}
                            </td>
                            <td class="py-3.5 px-6 text-xs text-slate-600">
                                {{ $p->email ?? '-' }}
                            </td>
                            <td class="py-3.5 px-6 text-xs font-mono text-slate-700">
                                {{ $p->no_hp ?? '-' }}
                            </td>
                            <td class="py-3.5 px-6 text-xs text-slate-500 max-w-xs truncate">
                                {{ $p->alamat ?? '-' }}
                            </td>
                            <td class="py-3.5 px-6 text-right">
                                <a href="{{ route('admin.pelanggan.show', $p->id_pelanggan) }}" class="px-3 py-1.5 rounded-lg border border-brand-200 text-brand-700 hover:bg-brand-50 text-xs font-bold transition inline-block">
                                    Detail
                                </a>
                            </td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="6" class="text-center py-10 text-slate-400 text-sm">
                                Tidak ada data pelanggan yang sesuai pencarian.
                            </td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>

        @if($pelanggans->hasPages())
            <div class="p-4 border-t border-slate-200 bg-slate-50">
                {{ $pelanggans->links() }}
            </div>
        @endif
    </div>

</div>
@endsection
