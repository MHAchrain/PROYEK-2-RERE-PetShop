<?php

namespace App\Filament\Widgets;

use App\Models\Pesanan;
use App\Models\Produk;
// Jika kamu punya model khusus Klik, tambahkan di sini: use App\Models\Click;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class StatsOverview extends BaseWidget
{
    protected ?string $pollingInterval = '10s';
    protected static ?int $sort = 1; // Biar paling atas
    protected function getStats(): array
    {
        // 1. Menghitung total transaksi (sebagai pengganti klik beli)
        $totalKlik = Pesanan::count(); 

        // 2. Menghitung stok yang mau habis
        $stokMenipis = Produk::where('stok', '<', 10)->count();

        return [
            Stat::make('Total Pelanggan', \App\Models\Pelanggan::count())
                ->description('User yang terdaftar')
                ->descriptionIcon('heroicon-m-users')
                ->color('info'),

            Stat::make('Produk Aktif', Produk::count())
                ->description('Total produk di etalase')
                ->descriptionIcon('heroicon-m-shopping-bag')
                ->color('success'),

            Stat::make('Stok Menipis', $stokMenipis)
                ->description('Perlu segera restock')
                ->descriptionIcon('heroicon-m-exclamation-triangle')
                ->color($stokMenipis > 0 ? 'danger' : 'success'),

            Stat::make('Total Produk Dilihat', \App\Models\Produk::sum('views') . ' Views')
            ->description('Kepopuleran produk di website')
            ->descriptionIcon('heroicon-m-eye')
            ->color('gray')
            ->chart([1, 5, 2, 10, 3, 15, 4, 18]), // Grafik estetika saja   
            
            
        ];
    }
}