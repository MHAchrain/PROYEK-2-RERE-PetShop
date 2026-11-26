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
                            600: '#dc2626',
                            700: '#b91c1c',
                            800: '#991b1b',
                            900: '#7f1d1d',
                            950: '#450a0a',
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
        /* Custom scrollbar for dark red sidebar */
        .sidebar-scroll::-webkit-scrollbar {
            width: 4px;
        }
        .sidebar-scroll::-webkit-scrollbar-track {
            background: transparent;
        }
        .sidebar-scroll::-webkit-scrollbar-thumb {
            background: rgba(255, 255, 255, 0.2);
            border-radius: 9999px;
        }
        .sidebar-scroll::-webkit-scrollbar-thumb:hover {
            background: rgba(255, 255, 255, 0.4);
        }
    </style>
    @stack('styles')
</head>
<body class="text-slate-800 antialiased min-h-screen flex flex-col">

    <div class="flex min-h-screen">
        <!-- ========================================== -->
        <!-- SIDEBAR FULL MERAH RERE ELEGAN             -->
        <!-- ========================================== -->
        <aside class="w-64 bg-gradient-to-b from-brand-800 via-brand-800 to-brand-900 text-white flex flex-col shrink-0 select-none z-30 shadow-xl border-r border-brand-950/20">
            <!-- Brand Header -->
            <div class="h-16 flex items-center px-6 border-b border-white/10 gap-3 bg-brand-900/30">
                <img src="{{ asset('images/logorere.png') }}" alt="Logo" class="w-9 h-9 object-contain rounded-lg shadow-sm bg-white/10 p-0.5" onerror="this.src='https://ui-avatars.com/api/?name=RR&background=fff&color=b91c1c'">
                <div>
                    <h1 class="text-base font-extrabold text-white tracking-tight leading-tight">ReRe Petshop</h1>
                    <span class="text-[10px] font-extrabold text-amber-300 uppercase tracking-widest">Admin Panel</span>
                </div>
            </div>

            <!-- Navigation Links -->
            <nav class="flex-1 overflow-y-auto px-3.5 py-4 space-y-1 sidebar-scroll">
                <!-- Group: Menu Utama -->
                <div class="px-3 pt-1 pb-1.5 text-[10px] font-extrabold text-red-200/60 uppercase tracking-widest">Menu Utama</div>

                <a href="{{ route('admin.dashboard') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-bold transition {{ request()->routeIs('admin.dashboard') ? 'bg-white text-brand-800 shadow-md' : 'text-white/80 hover:bg-white/10 hover:text-white' }}">
                    <i class="fa-solid fa-chart-pie w-4 text-center {{ request()->routeIs('admin.dashboard') ? 'text-brand-700' : 'text-red-200/80' }}"></i>
                    <span>Dashboard</span>
                </a>

                <!-- Group: Katalog & Produk -->
                <div class="pt-4 px-3 pb-1.5 text-[10px] font-extrabold text-red-200/60 uppercase tracking-widest">Katalog Produk</div>

                <a href="{{ route('admin.produk.index') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-bold transition {{ request()->routeIs('admin.produk.*') ? 'bg-white text-brand-800 shadow-md' : 'text-white/80 hover:bg-white/10 hover:text-white' }}">
                    <i class="fa-solid fa-box-open w-4 text-center {{ request()->routeIs('admin.produk.*') ? 'text-brand-700' : 'text-red-200/80' }}"></i>
                    <span>Katalog Produk</span>
                </a>

                <a href="{{ route('admin.kategori.index') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-bold transition {{ request()->routeIs('admin.kategori.*') ? 'bg-white text-brand-800 shadow-md' : 'text-white/80 hover:bg-white/10 hover:text-white' }}">
                    <i class="fa-solid fa-tags w-4 text-center {{ request()->routeIs('admin.kategori.*') ? 'text-brand-700' : 'text-red-200/80' }}"></i>
                    <span>Kategori Produk</span>
                </a>

                <!-- Group: Transaksi & Pesanan -->
                <div class="pt-4 px-3 pb-1.5 text-[10px] font-extrabold text-red-200/60 uppercase tracking-widest">Penjualan & Pengiriman</div>

                <!-- 1. Pesanan -->
                <a href="{{ route('admin.pesanan.index') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-bold transition {{ request()->routeIs('admin.pesanan.index') || request()->routeIs('admin.pesanan.show') ? 'bg-white text-brand-800 shadow-md' : 'text-white/80 hover:bg-white/10 hover:text-white' }}">
                    <i class="fa-solid fa-receipt w-4 text-center {{ request()->routeIs('admin.pesanan.*') ? 'text-brand-700' : 'text-red-200/80' }}"></i>
                    <span>Pesanan Toko</span>
                </a>

                <!-- 2. Detail Pesanan -->
                <a href="{{ route('admin.pesanan-detail.index') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-bold transition {{ request()->routeIs('admin.pesanan-detail.*') ? 'bg-white text-brand-800 shadow-md' : 'text-white/80 hover:bg-white/10 hover:text-white' }}">
                    <i class="fa-solid fa-list-check w-4 text-center {{ request()->routeIs('admin.pesanan-detail.*') ? 'text-brand-700' : 'text-red-200/80' }}"></i>
                    <span>Detail Pesanan Item</span>
                </a>

                <!-- 3. Pengiriman -->
                <a href="{{ route('admin.pengiriman.index') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-bold transition {{ request()->routeIs('admin.pengiriman.*') ? 'bg-white text-brand-800 shadow-md' : 'text-white/80 hover:bg-white/10 hover:text-white' }}">
                    <i class="fa-solid fa-truck-fast w-4 text-center {{ request()->routeIs('admin.pengiriman.*') ? 'text-brand-700' : 'text-red-200/80' }}"></i>
                    <span>Pengiriman Ekspedisi</span>
                </a>

                <!-- Group: Grooming -->
                <div class="pt-4 px-3 pb-1.5 text-[10px] font-extrabold text-red-200/60 uppercase tracking-widest">Layanan Grooming</div>

                <!-- 1. Layanan Grooming (Paket & Tarif) -->
                <a href="{{ route('admin.grooming.services') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-bold transition {{ request()->routeIs('admin.grooming.services') ? 'bg-white text-brand-800 shadow-md' : 'text-white/80 hover:bg-white/10 hover:text-white' }}">
                    <i class="fa-solid fa-scissors w-4 text-center {{ request()->routeIs('admin.grooming.services') ? 'text-brand-700' : 'text-red-200/80' }}"></i>
                    <span>Layanan Grooming</span>
                </a>

                <!-- 2. Pesanan Grooming (Booking Antrean) -->
                <a href="{{ route('admin.grooming.bookings') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-bold transition {{ request()->routeIs('admin.grooming.bookings') ? 'bg-white text-brand-800 shadow-md' : 'text-white/80 hover:bg-white/10 hover:text-white' }}">
                    <i class="fa-solid fa-calendar-check w-4 text-center {{ request()->routeIs('admin.grooming.bookings') ? 'text-brand-700' : 'text-red-200/80' }}"></i>
                    <span>Pesanan Grooming</span>
                </a>

                <!-- Group: Pelanggan -->
                <div class="pt-4 px-3 pb-1.5 text-[10px] font-extrabold text-red-200/60 uppercase tracking-widest">Pelanggan</div>

                <a href="{{ route('admin.pelanggan.index') }}" class="flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-bold transition {{ request()->routeIs('admin.pelanggan.*') ? 'bg-white text-brand-800 shadow-md' : 'text-white/80 hover:bg-white/10 hover:text-white' }}">
                    <i class="fa-solid fa-users w-4 text-center {{ request()->routeIs('admin.pelanggan.*') ? 'text-brand-700' : 'text-red-200/80' }}"></i>
                    <span>Data Pelanggan</span>
                </a>

                <!-- Group: Logout (Tepat di bawah Pelanggan) -->
                <div class="pt-4 px-3 pb-1.5 text-[10px] font-extrabold text-red-200/60 uppercase tracking-widest">Sesi Admin</div>

                <form action="{{ route('admin.logout') }}" method="POST">
                    @csrf
                    <button type="submit" class="w-full flex items-center gap-3 px-3 py-2.5 rounded-xl text-xs font-bold text-red-100 hover:bg-white/10 hover:text-white transition">
                        <i class="fa-solid fa-right-from-bracket w-4 text-center text-red-200"></i>
                        <span>Logout Admin</span>
                    </button>
                </form>
            </nav>
        </aside>

        <!-- MAIN CONTENT AREA -->
        <div class="flex-1 flex flex-col min-w-0">
            <!-- TOP NAVBAR -->
            <header class="h-16 bg-white border-b border-slate-200 flex items-center justify-between px-8 sticky top-0 z-20 shadow-sm">
                <div class="flex items-center gap-3">
                    <h2 class="text-lg font-extrabold text-slate-800">@yield('page_title', 'Dashboard')</h2>
                </div>

                <div class="flex items-center gap-4">
                    <!-- Status TiDB Cloud Indicator -->
                    <div class="flex items-center gap-2 px-3 py-1.5 rounded-lg bg-emerald-50 border border-emerald-200 text-emerald-700 text-xs font-bold">
                        <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
                        <span class="font-mono">TiDB Cloud Connected</span>
                    </div>

                    <!-- Link ke Frontend Vercel -->
                    <a href="https://rerepetshop.biz.id" target="_blank" class="hidden sm:inline-flex items-center gap-2 text-xs font-bold px-3 py-1.5 rounded-lg border border-slate-200 text-slate-600 hover:bg-slate-50 hover:text-slate-900 transition">
                        <i class="fa-solid fa-arrow-up-right-from-square text-slate-400"></i>
                        <span>Web Toko</span>
                    </a>

                    <!-- Admin Profile di Top Navbar -->
                    <div class="flex items-center gap-2.5 pl-3 border-l border-slate-200">
                        <div class="w-8 h-8 rounded-full bg-brand-800 text-white flex items-center justify-center font-extrabold text-xs shrink-0 shadow-sm">
                            {{ strtoupper(substr(Auth::user()->name ?? 'A', 0, 1)) }}
                        </div>
                        <div class="hidden md:block">
                            <p class="text-xs font-bold text-slate-800 leading-tight">{{ Auth::user()->name ?? 'Administrator' }}</p>
                            <span class="text-[10px] text-slate-400 font-semibold">Admin ReRe</span>
                        </div>
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

                @if(isset($errors) && $errors->any())
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
                <p class="font-semibold text-brand-600">ReRe Red Elegant Theme</p>
            </footer>
        </div>
    </div>

    @stack('scripts')
</body>
</html>
