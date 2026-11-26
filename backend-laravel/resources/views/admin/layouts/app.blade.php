<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title', 'Admin Panel') - ReRe Petshop</title>

    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brand: {
                            50: '#fef2f2',
                            100: '#fee2e2',
                            200: '#fecaca',
                            300: '#fca5a5',
                            400: '#f87171',
                            500: '#ef4444',
                            600: '#dc2626', // Primary Brand Red (ReRe Red)
                            700: '#b91c1c',
                            800: '#991b1b',
                            900: '#7f1d1d',
                        },
                        amberbrand: {
                            500: '#f59e0b',
                            600: '#d97706',
                        }
                    }
                }
            }
        }
    </script>

    <!-- Font & Icons -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        body {
            font-family: 'Plus Jakarta Sans', sans-serif;
            background-color: #F8FAFC;
        }
        /* Custom subtle scrollbar */
        ::-webkit-scrollbar {
            width: 6px;
            height: 6px;
        }
        ::-webkit-scrollbar-track {
            background: #F1F5F9;
        }
        ::-webkit-scrollbar-thumb {
            background: #CBD5E1;
            border-radius: 9999px;
        }
        ::-webkit-scrollbar-thumb:hover {
            background: #94A3B8;
        }
    </style>
    @stack('styles')
</head>
<body class="text-slate-800 antialiased min-h-screen flex flex-col">

    <div class="flex min-h-screen">
        <!-- SIDEBAR -->
        <aside class="w-64 bg-white border-r border-slate-200 flex flex-col shrink-0 select-none z-30">
            <!-- Brand Header -->
            <div class="h-16 flex items-center px-6 border-b border-slate-200 gap-3">
                <img src="{{ asset('images/logorere.png') }}" alt="Logo" class="w-9 h-9 object-contain rounded-lg shadow-sm" onerror="this.src='https://ui-avatars.com/api/?name=RR&background=dc2626&color=fff'">
                <div>
                    <h1 class="text-base font-extrabold text-slate-900 tracking-tight leading-tight">ReRe Petshop</h1>
                    <span class="text-[11px] font-bold text-brand-600 uppercase tracking-wider">Admin Panel</span>
                </div>
            </div>

            <!-- Navigation Links -->
            <nav class="flex-1 overflow-y-auto px-4 py-5 space-y-1">
                <!-- Group: Utama -->
                <div class="px-3 pb-2 text-[11px] font-bold text-slate-400 uppercase tracking-wider">Menu Utama</div>

                <a href="{{ route('admin.dashboard') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold transition {{ request()->routeIs('admin.dashboard') ? 'bg-brand-50 text-brand-700' : 'text-slate-600 hover:bg-slate-100 hover:text-slate-900' }}">
                    <i class="fa-solid fa-chart-pie w-5 text-center {{ request()->routeIs('admin.dashboard') ? 'text-brand-600' : 'text-slate-400' }}"></i>
                    <span>Dashboard</span>
                </a>

                <!-- Group: Katalog & Produk -->
                <div class="pt-5 px-3 pb-2 text-[11px] font-bold text-slate-400 uppercase tracking-wider">Katalog Produk</div>

                <a href="{{ route('admin.produk.index') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold transition {{ request()->routeIs('admin.produk.*') ? 'bg-brand-50 text-brand-700' : 'text-slate-600 hover:bg-slate-100 hover:text-slate-900' }}">
                    <i class="fa-solid fa-box-open w-5 text-center {{ request()->routeIs('admin.produk.*') ? 'text-brand-600' : 'text-slate-400' }}"></i>
                    <span>Produk</span>
                </a>

                <a href="{{ route('admin.kategori.index') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold transition {{ request()->routeIs('admin.kategori.*') ? 'bg-brand-50 text-brand-700' : 'text-slate-600 hover:bg-slate-100 hover:text-slate-900' }}">
                    <i class="fa-solid fa-tags w-5 text-center {{ request()->routeIs('admin.kategori.*') ? 'text-brand-600' : 'text-slate-400' }}"></i>
                    <span>Kategori</span>
                </a>

                <!-- Group: Transaksi & Pesanan -->
                <div class="pt-5 px-3 pb-2 text-[11px] font-bold text-slate-400 uppercase tracking-wider">Penjualan</div>

                <a href="{{ route('admin.pesanan.index') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold transition {{ request()->routeIs('admin.pesanan.*') ? 'bg-brand-50 text-brand-700' : 'text-slate-600 hover:bg-slate-100 hover:text-slate-900' }}">
                    <i class="fa-solid fa-receipt w-5 text-center {{ request()->routeIs('admin.pesanan.*') ? 'text-brand-600' : 'text-slate-400' }}"></i>
                    <span>Pesanan</span>
                </a>

                <!-- Group: Layanan & Customer -->
                <div class="pt-5 px-3 pb-2 text-[11px] font-bold text-slate-400 uppercase tracking-wider">Layanan & Pelanggan</div>

                <a href="{{ route('admin.grooming.index') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold transition {{ request()->routeIs('admin.grooming.*') ? 'bg-brand-50 text-brand-700' : 'text-slate-600 hover:bg-slate-100 hover:text-slate-900' }}">
                    <i class="fa-solid fa-shower w-5 text-center {{ request()->routeIs('admin.grooming.*') ? 'text-brand-600' : 'text-slate-400' }}"></i>
                    <span>Layanan Grooming</span>
                </a>

                <a href="{{ route('admin.pelanggan.index') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-sm font-semibold transition {{ request()->routeIs('admin.pelanggan.*') ? 'bg-brand-50 text-brand-700' : 'text-slate-600 hover:bg-slate-100 hover:text-slate-900' }}">
                    <i class="fa-solid fa-users w-5 text-center {{ request()->routeIs('admin.pelanggan.*') ? 'text-brand-600' : 'text-slate-400' }}"></i>
                    <span>Pelanggan</span>
                </a>
            </nav>

            <!-- User Footer Profile -->
            <div class="p-4 border-t border-slate-200">
                <div class="flex items-center justify-between">
                    <div class="flex items-center gap-3 min-w-0">
                        <div class="w-9 h-9 rounded-full bg-brand-100 text-brand-700 flex items-center justify-center font-bold text-sm shrink-0">
                            {{ strtoupper(substr(Auth::user()->name ?? 'A', 0, 1)) }}
                        </div>
                        <div class="min-w-0">
                            <p class="text-xs font-bold text-slate-900 truncate">{{ Auth::user()->name ?? 'Administrator' }}</p>
                            <span class="inline-block px-1.5 py-0.5 text-[10px] font-semibold bg-emerald-100 text-emerald-700 rounded">Admin</span>
                        </div>
                    </div>
                    <form action="{{ route('admin.logout') }}" method="POST">
                        @csrf
                        <button type="submit" title="Keluar" class="w-8 h-8 rounded-lg flex items-center justify-center text-slate-400 hover:text-brand-600 hover:bg-brand-50 transition">
                            <i class="fa-solid fa-right-from-bracket text-sm"></i>
                        </button>
                    </form>
                </div>
            </div>
        </aside>

        <!-- MAIN CONTENT AREA -->
        <div class="flex-1 flex flex-col min-w-0">
            <!-- TOP NAVBAR -->
            <header class="h-16 bg-white border-b border-slate-200 flex items-center justify-between px-8 sticky top-0 z-20">
                <div class="flex items-center gap-3">
                    <h2 class="text-lg font-bold text-slate-800">@yield('page_title', 'Dashboard')</h2>
                </div>

                <div class="flex items-center gap-4">
                    <!-- Link ke Frontend Vercel -->
                    <a href="https://rerepetshop.biz.id" target="_blank" class="hidden sm:inline-flex items-center gap-2 text-xs font-semibold px-3 py-1.5 rounded-lg border border-slate-200 text-slate-600 hover:bg-slate-50 hover:text-slate-900 transition">
                        <i class="fa-solid fa-arrow-up-right-from-square text-slate-400"></i>
                        <span>Lihat Web Toko</span>
                    </a>

                    <!-- Status TiDB Cloud Indicator -->
                    <div class="flex items-center gap-2 px-3 py-1.5 rounded-lg bg-emerald-50 border border-emerald-200 text-emerald-700 text-xs font-semibold">
                        <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
                        <span class="font-mono">TiDB Cloud Connected</span>
                    </div>
                </div>
            </header>

            <!-- FLASH ALERTS -->
            <main class="flex-1 p-8">
                @if(session('success'))
                    <div class="mb-6 flex items-center gap-3 bg-emerald-50 border border-emerald-200 text-emerald-800 px-4 py-3 rounded-xl text-sm font-medium shadow-sm">
                        <i class="fa-solid fa-circle-check text-emerald-600 text-base"></i>
                        <span class="flex-1">{{ session('success') }}</span>
                    </div>
                @endif

                @if(session('error'))
                    <div class="mb-6 flex items-center gap-3 bg-red-50 border border-red-200 text-red-800 px-4 py-3 rounded-xl text-sm font-medium shadow-sm">
                        <i class="fa-solid fa-circle-exclamation text-red-600 text-base"></i>
                        <span class="flex-1">{{ session('error') }}</span>
                    </div>
                @endif

                @if($errors->any())
                    <div class="mb-6 bg-red-50 border border-red-200 text-red-800 px-4 py-3 rounded-xl text-sm font-medium shadow-sm">
                        <div class="flex items-center gap-2 mb-1 text-red-700 font-bold">
                            <i class="fa-solid fa-triangle-exclamation"></i>
                            <span>Terdapat beberapa kesalahan:</span>
                        </div>
                        <ul class="list-disc list-inside space-y-1 text-xs">
                            @foreach($errors->all() as $error)
                                <li>{{ $error }}</li>
                            @endforeach
                        </ul>
                    </div>
                @endif

                @yield('content')
            </main>

            <!-- FOOTER -->
            <footer class="h-12 bg-white border-t border-slate-200 flex items-center justify-between px-8 text-xs text-slate-400">
                <p>&copy; {{ date('Y') }} <strong>ReRe Petshop</strong>. Seluruh hak cipta dilindungi.</p>
                <p>Designed with Clean Red Elegance</p>
            </footer>
        </div>
    </div>

    @stack('scripts')
</body>
</html>
