<?php

namespace App\Filament\Resources\GroomingBookings\Schemas;

use App\Models\GroomingService;
use App\Models\Pelanggan;
use Filament\Forms\Components\DatePicker;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Schema;

class GroomingBookingForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Select::make('id_pelanggan')
                    ->label('Pelanggan')
                    ->options(
                        Pelanggan::query()
                            ->orderBy('id_pelanggan', 'desc')
                            ->get()
                            ->mapWithKeys(fn ($item) => [
                                $item->id_pelanggan => 'PLG-' . str_pad($item->id_pelanggan, 4, '0', STR_PAD_LEFT) . ' - ' . ($item->nama ?? $item->email),
                            ])
                            ->toArray()
                    )
                    ->searchable()
                    ->required(),

                Select::make('grooming_service_id')
                    ->label('Layanan Grooming')
                    ->options(
                        GroomingService::pluck('name', 'id')
                    )
                    ->reactive()
                    ->afterStateUpdated(function ($state, callable $set) {
                        $service = GroomingService::find($state);
                        if ($service) {
                            $set('price', $service->price);
                        }
                    })
                    ->searchable()
                    ->required(),

                TextInput::make('price')
                    ->label('Harga Layanan')
                    ->numeric()
                    ->prefix('Rp')
                    ->required(),

                DatePicker::make('date')
                    ->label('Tanggal Grooming')
                    ->required(),

                Select::make('time')
                    ->label('Jam / Slot')
                    ->options([
                        '09:00' => '09:00',
                        '11:00' => '11:00',
                        '13:00' => '13:00',
                        '15:00' => '15:00',
                        '17:00' => '17:00',
                    ])
                    ->required(),

                Select::make('status')
                    ->label('Status Booking')
                    ->options([
                        'menunggu_pembayaran' => 'Menunggu Pembayaran',
                        'terjadwal'           => 'Terjadwal',
                        'dikonfirmasi'        => 'Terkonfirmasi',
                        'selesai'             => 'Selesai',
                        'dibatalkan'          => 'Dibatalkan',
                        'gagal'               => 'Gagal',
                    ])
                    ->required()
                    ->default('menunggu_pembayaran'),

                TextInput::make('pet_name')
                    ->label('Nama Hewan')
                    ->required()
                    ->placeholder('Contoh: Mochi')
                    ->maxLength(100),

                TextInput::make('pet_type')
                    ->label('Jenis Hewan')
                    ->required()
                    ->placeholder('Contoh: Kucing / Anjing')
                    ->maxLength(100),

                TextInput::make('pet_breed')
                    ->label('Ras')
                    ->required()
                    ->placeholder('Contoh: Persia')
                    ->maxLength(100),

                TextInput::make('pet_size')
                    ->label('Ukuran')
                    ->required()
                    ->placeholder('Contoh: Kecil / Sedang / Besar')
                    ->maxLength(50),

                Textarea::make('pet_note')
                    ->label('Catatan Tambahan')
                    ->placeholder('Informasi khusus yang perlu diketahui groomer')
                    ->columnSpanFull()
                    ->rows(3),
            ]);
    }
}
