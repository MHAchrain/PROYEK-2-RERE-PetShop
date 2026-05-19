<?php

namespace App\Filament\Resources\Pesanans\Schemas;

use Filament\Infolists\Components\TextEntry;
use Filament\Schemas\Schema;

class PesananInfolist
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextEntry::make('id_pelanggan')
                    ->numeric(),
                TextEntry::make('tanggal_pesanan')
                    ->dateTime(),
                TextEntry::make('total')
                    ->numeric(),
                TextEntry::make('status_pesanan')
                    ->formatStateUsing(fn (string $state): string => match ($state) {
                        'baru' => 'Baru',
                        'diproses' => 'Diproses',
                        'dikirim' => 'Dikirim',
                        'selesai' => 'Selesai',
                        'batal' => 'Dibatalkan',
                        default => $state,
                    }),
                TextEntry::make('created_at')
                    ->dateTime(),
                TextEntry::make('updated_at')
                    ->dateTime(),
            ]);
    }
}
