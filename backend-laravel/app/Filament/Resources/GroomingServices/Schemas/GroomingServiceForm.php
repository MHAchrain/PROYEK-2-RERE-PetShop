<?php

namespace App\Filament\Resources\GroomingServices\Schemas;

use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Schema;

class GroomingServiceForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                TextInput::make('name')
                    ->label('Nama Layanan')
                    ->required()
                    ->maxLength(150),

                TextInput::make('price')
                    ->label('Harga (Rp)')
                    ->numeric()
                    ->prefix('Rp')
                    ->required()
                    ->default(0),

                TextInput::make('duration_minutes')
                    ->label('Durasi Estimasi (Menit)')
                    ->numeric()
                    ->default(60)
                    ->required(),

                Toggle::make('is_active')
                    ->label('Status Aktif')
                    ->default(true)
                    ->required(),

                Textarea::make('description')
                    ->label('Deskripsi Layanan')
                    ->columnSpanFull()
                    ->rows(3),
            ]);
    }
}
