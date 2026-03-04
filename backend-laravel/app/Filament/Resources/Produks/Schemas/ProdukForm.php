<?php

namespace App\Filament\Resources\Produks\Schemas;

use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Textarea;
use Filament\Schemas\Schema;

class ProdukForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('id_kategori')
                    ->required()
                    ->numeric(),
                TextInput::make('nama_produk')
                    ->required(),
                TextInput::make('harga')
                    ->required()
                    ->numeric()
                    ->default(0.0),
                TextInput::make('stok')
                    ->required()
                    ->numeric()
                    ->default(0),
                Textarea::make('deskripsi')
                    ->default(null)
                    ->columnSpanFull(),
                TextInput::make('foto')
                    ->default(null),
            ]);
    }
}
