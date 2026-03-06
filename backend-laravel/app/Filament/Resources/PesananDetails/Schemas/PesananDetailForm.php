<?php

namespace App\Filament\Resources\PesananDetails\Schemas;

use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Schema;

class PesananDetailForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Select::make('id_pesanan')
                    ->label('id_Pesanan')
                      ->options(\App\Models\Pesanan::pluck('id_pesanan', 'id_pesanan'))
                    ->searchable()
                    ->required(),

                Select::make('id_produk')
                    ->label('Produk')
                    ->options(\App\Models\Produk::pluck('nama_produk', 'id_produk'))
                    ->searchable()
                    ->required(),

                TextInput::make('qty')
                    ->label('Jumlah')
                    ->numeric()
                    ->required()
                    ->default(1),

                TextInput::make('harga_satuan')
    ->label('Harga Satuan')
    ->numeric()
    ->required()
    ->default(0),

TextInput::make('subtotal')
    ->label('Subtotal')
    ->numeric()
    ->required()
    ->default(0),
            ]);
    }
}