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
                Select::make('id_pesanan')
                    ->label('Pesanan')
                    ->options(
                        \App\Models\Pesanan::query()
                            ->orderBy('id_pesanan', 'desc')
                            ->get()
                            ->mapWithKeys(fn ($item) => [
                                $item->id_pesanan => 'ORD-' . str_pad($item->id_pesanan, 4, '0', STR_PAD_LEFT),
                            ])
                            ->toArray()
                    )
                    ->required(),

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