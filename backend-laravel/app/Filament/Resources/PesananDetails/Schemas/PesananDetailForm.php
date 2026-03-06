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
                    ->label('Pesanan')
                    ->relationship('pesanan', 'id_pesanan')
                    ->searchable()
                    ->required(),

                Select::make('id_produk')
                    ->label('Produk')
                    ->relationship('produk', 'nama_produk')
                    ->searchable()
                    ->required(),

                TextInput::make('qty')
                    ->label('Jumlah')
                    ->numeric()
                    ->required()
                    ->default(1),

                TextInput::make('harga')
                    ->label('Harga')
                    ->numeric()
                    ->required()
                    ->default(0),
            ]);
    }
}