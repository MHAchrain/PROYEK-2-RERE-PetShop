<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Masuk Admin - ReRe Petshop</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        brand: {
                            50: '#fef2f2',
                            100: '#fee2e2',
                            600: '#dc2626',
                            700: '#b91c1c',
                            800: '#991b1b',
                        }
                    }
                }
            }
        }
    </script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
    </style>
</head>
<body class="bg-slate-100 min-h-screen flex items-center justify-center p-4">

    <div class="max-w-md w-full">
        <!-- Logo & Title Header -->
        <div class="text-center mb-8">
            <div class="inline-flex items-center justify-center w-16 h-16 rounded-2xl bg-white shadow-md border border-slate-200 mb-4 p-2">
                <img src="{{ asset('images/logorere.png') }}" alt="Logo" class="w-full h-full object-contain" onerror="this.src='https://ui-avatars.com/api/?name=RR&background=dc2626&color=fff'">
            </div>
            <h1 class="text-2xl font-extrabold text-slate-900 tracking-tight">ReRe Petshop</h1>
            <p class="text-sm font-medium text-slate-500 mt-1">Admin Control Panel</p>
        </div>

        <!-- Form Card -->
        <div class="bg-white rounded-3xl border border-slate-200 shadow-xl p-8">
            <h2 class="text-lg font-bold text-slate-900 mb-1">Masuk ke Akun Anda</h2>
            <p class="text-xs text-slate-500 mb-6">Gunakan kredensial akun administrator yang telah terdaftar.</p>

            @if(session('error'))
                <div class="mb-5 flex items-center gap-2 bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-xl text-xs font-semibold">
                    <i class="fa-solid fa-circle-exclamation shrink-0"></i>
                    <span>{{ session('error') }}</span>
                </div>
            @endif

            @if(session('success'))
                <div class="mb-5 flex items-center gap-2 bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-xl text-xs font-semibold">
                    <i class="fa-solid fa-circle-check shrink-0"></i>
                    <span>{{ session('success') }}</span>
                </div>
            @endif

            <form action="{{ route('admin.login.submit') }}" method="POST" class="space-y-4">
                @csrf

                <!-- Input Email -->
                <div>
                    <label for="email" class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Alamat Email</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
                            <i class="fa-solid fa-envelope text-sm"></i>
                        </div>
                        <input type="email" name="email" id="email" value="{{ old('email') }}" required autofocus
                            placeholder="admin@rerepetshop.com"
                            class="w-full pl-10 pr-4 py-2.5 rounded-xl border {{ $errors->has('email') ? 'border-red-500' : 'border-slate-300' }} text-slate-900 placeholder-slate-400 text-sm focus:outline-none focus:ring-2 focus:ring-brand-600 focus:border-brand-600 transition">
                    </div>
                    @error('email')
                        <p class="text-xs text-red-600 mt-1.5 font-medium">{{ $message }}</p>
                    @enderror
                </div>

                <!-- Input Password -->
                <div>
                    <label for="password" class="block text-xs font-bold text-slate-700 uppercase tracking-wider mb-2">Kata Sandi</label>
                    <div class="relative">
                        <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
                            <i class="fa-solid fa-lock text-sm"></i>
                        </div>
                        <input type="password" name="password" id="password" required
                            placeholder="••••••••"
                            class="w-full pl-10 pr-4 py-2.5 rounded-xl border {{ $errors->has('password') ? 'border-red-500' : 'border-slate-300' }} text-slate-900 placeholder-slate-400 text-sm focus:outline-none focus:ring-2 focus:ring-brand-600 focus:border-brand-600 transition">
                    </div>
                    @error('password')
                        <p class="text-xs text-red-600 mt-1.5 font-medium">{{ $message }}</p>
                    @enderror
                </div>

                <!-- Remember Me -->
                <div class="flex items-center justify-between pt-1">
                    <label class="flex items-center gap-2 cursor-pointer select-none">
                        <input type="checkbox" name="remember" class="w-4 h-4 rounded text-brand-600 focus:ring-brand-600 border-slate-300">
                        <span class="text-xs font-medium text-slate-600">Ingat sesi saya</span>
                    </label>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="w-full py-3 px-4 rounded-xl bg-brand-600 hover:bg-brand-700 active:bg-brand-800 text-white font-bold text-sm tracking-wide shadow-lg shadow-brand-600/30 transition duration-150 flex items-center justify-center gap-2">
                    <span>Masuk ke Panel</span>
                    <i class="fa-solid fa-arrow-right text-xs"></i>
                </button>
            </form>
        </div>

        <!-- Footer Info -->
        <p class="text-center text-xs text-slate-400 mt-6">
            &copy; {{ date('Y') }} ReRe Petshop. Akses terbatas khusus staf/administrator.
        </p>
    </div>

</body>
</html>
