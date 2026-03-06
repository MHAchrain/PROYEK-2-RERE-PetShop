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
                Select::make('id_pelanggan')
                    ->label('Pelanggan')
                    ->relationship('pelanggan', 'nama')
                    ->searchable()
                    ->required(),

                DateTimePicker::make('tanggal_pesanan')
                    ->required(),

                Textarea::make('alamat_kirim')
                    ->required()
                    ->columnSpanFull(),

                TextInput::make('total')
                    ->numeric()
                    ->required()
                    ->default(0),

                Select::make('status_pesanan')
                    ->options([
                        'baru' => 'Baru',
                        'diproses' => 'Diproses',
                        'dikirim' => 'Dikirim',
                        'selesai' => 'Selesai',
                        'dibatalkan' => 'Dibatalkan',
                    ])
                    ->required(),
            ]);
    }
}