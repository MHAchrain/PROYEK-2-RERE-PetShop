<?php

namespace App\Filament\Resources\Pembayarans\Schemas;

use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Schema;

class PembayaranForm
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

                TextInput::make('metode_pembayaran')
                    ->label('Metode Pembayaran')
                    ->required(),

                TextInput::make('jumlah_bayar')
                    ->label('Jumlah Bayar')
                    ->numeric()
                    ->required()
                    ->default(0),

                Select::make('status_pembayaran')
                    ->label('Status Pembayaran')
                    ->options([
                        'pending' => 'Pending',
                        'paid' => 'Paid',
                        'failed' => 'Failed',
                        'expired' => 'Expired',
                    ])
                    ->required(),

                DateTimePicker::make('tanggal_pembayaran')
                    ->label('Tanggal Pembayaran'),
            ]);
    }
}