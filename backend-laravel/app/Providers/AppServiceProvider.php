<?php

namespace App\Providers;

use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        // =========================================================================
        // PRODUCTION: Paksa HTTPS (Aktifkan baris bawah jika deploy production)
        // =========================================================================
        // URL::forceScheme('https');

        // =========================================================================
        // LOKAL: Hanya paksa HTTPS jika APP_ENV=production di file .env
        // (Di lokal php artisan serve otomatis pakai HTTP agar CSS & JS tidak error)
        // =========================================================================
        if (config('app.env') === 'production') {
            URL::forceScheme('https');
        }
    }
}
