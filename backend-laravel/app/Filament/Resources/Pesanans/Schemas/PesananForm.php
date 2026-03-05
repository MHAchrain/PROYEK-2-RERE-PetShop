<?php

namespace App\Filament\Resources\Pesanans\Schemas;

use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Schemas\Schema;

class PesananForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('id_pelanggan')
                    ->required()
                    ->numeric(),
                DateTimePicker::make('tanggal_pesanan')
                    ->required(),
                Textarea::make('alamat_kirim')
                    ->default(null)
                    ->columnSpanFull(),
                TextInput::make('total')
                    ->required()
                    ->numeric()
                    ->default(0.0),
                Select::make('status_pesanan')
                    ->options([
            'baru' => 'Baru',
            'diproses' => 'Diproses',
            'dikirim' => 'Dikirim',
            'selesai' => 'Selesai',
            'batal' => 'Batal',
        ])
                    ->default('baru')
                    ->required(),
            ]);
    }
}
