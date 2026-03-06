<?php

namespace App\Filament\Resources\Pengirimans\Schemas;

use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Schema;

class PengirimanForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('id_pesanan')
                    ->required()
                    ->numeric(),

                Select::make('status_kirim')
                    ->options([
                        'diproses' => 'Diproses',
                        'dikirim' => 'Dikirim',
                        'diterima' => 'Diterima',
                    ])
                    ->default('diproses')
                    ->required(),

                TextInput::make('kurir'),

                TextInput::make('resi'),

                DateTimePicker::make('tanggal_kirim'),
            ]);
    }
}