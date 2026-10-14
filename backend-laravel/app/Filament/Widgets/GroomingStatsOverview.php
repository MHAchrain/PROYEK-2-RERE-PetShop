<?php

namespace App\Filament\Widgets;

use App\Models\GroomingBooking;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class GroomingStatsOverview extends BaseWidget
{
    protected int | string | array $columnSpan = 'full';
    protected static ?int $sort = 2;

    protected function getStats(): array
    {
        return [
            Stat::make('Total Booking Grooming', GroomingBooking::count())
                ->description('Semua riwayat booking')
                ->descriptionIcon('heroicon-m-calendar-days')
                ->color('info'),

            Stat::make('Menunggu Konfirmasi/Bayar', GroomingBooking::where('status', 'menunggu_pembayaran')->count())
                ->description('Perlu tindak lanjut')
                ->descriptionIcon('heroicon-m-clock')
                ->color('warning'),

            Stat::make('Jadwal Terkonfirmasi', GroomingBooking::whereIn('status', ['terjadwal', 'dikonfirmasi'])->count())
                ->description('Siap dilayani di toko')
                ->descriptionIcon('heroicon-m-check-badge')
                ->color('primary'),

            Stat::make('Grooming Selesai', GroomingBooking::where('status', 'selesai')->count())
                ->description('Layanan sukses diselesaikan')
                ->descriptionIcon('heroicon-m-sparkles')
                ->color('success'),
        ];
    }
}
