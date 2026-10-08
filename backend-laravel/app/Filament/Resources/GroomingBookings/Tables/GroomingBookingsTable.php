<?php

namespace App\Filament\Resources\GroomingBookings\Tables;

use Filament\Actions\Action;
use Filament\Actions\BulkAction;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Actions\ViewAction;
use Filament\Forms\Components\Select;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Collection;

class GroomingBookingsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                // ✅ NOMOR URUT (1, 2, 3, 4, 5, ...)
                TextColumn::make('row_index')
                    ->label('#')
                    ->rowIndex(),

                // ✅ ID BOOKING (3 DIGIT TERAKHIR)
                TextColumn::make('kode_booking')
                    ->label('ID Booking')
                    ->weight('bold')
                    ->formatStateUsing(function ($state, $record) {
                        $last3 = substr(str_pad((string) $record->id, 3, '0', STR_PAD_LEFT), 0);
                        return 'GR-' . $last3;
                    })
                    ->searchable(query: function ($query, string $search) {
                        $clean = preg_replace('/[^0-9]/', '', $search);
                        if (! empty($clean)) {
                            return $query->where('id', (int) $clean);
                        }
                        return $query;
                    }),

                TextColumn::make('pelanggan.nama')
                    ->label('Pelanggan')
                    ->searchable()
                    ->sortable()
                    ->default(fn ($record) => $record->pelanggan?->email ?? '-'),

                TextColumn::make('service.name')
                    ->label('Layanan')
                    ->sortable()
                    ->searchable(),

                TextColumn::make('pet_name')
                    ->label('Hewan')
                    ->description(fn ($record) => "{$record->pet_type} · {$record->pet_breed} ({$record->pet_size})")
                    ->searchable(),

                TextColumn::make('date')
                    ->label('Jadwal')
                    ->date('d M Y')
                    ->description(fn ($record) => 'Pukul ' . $record->time)
                    ->sortable(),

                TextColumn::make('price')
                    ->label('Harga')
                    ->formatStateUsing(fn ($state) => 'Rp ' . number_format($state, 0, ',', '.'))
                    ->sortable(),

                TextColumn::make('status')
                    ->label('Status')
                    ->badge()
                    ->color(fn ($state) => match ($state) {
                        'menunggu_pembayaran' => 'warning',
                        'terjadwal', 'dikonfirmasi' => 'info',
                        'selesai'             => 'success',
                        'dibatalkan'          => 'danger',
                        'gagal'               => 'gray',
                        default               => 'gray',
                    })
                    ->formatStateUsing(fn (string $state): string => match ($state) {
                        'menunggu_pembayaran' => 'Menunggu Pembayaran',
                        'terjadwal'           => 'Terjadwal',
                        'dikonfirmasi'        => 'Terkonfirmasi',
                        'selesai'             => 'Selesai',
                        'dibatalkan'          => 'Dibatalkan',
                        'gagal'               => 'Gagal',
                        default               => $state,
                    })
                    ->action(
                        Action::make('ubah_status')
                            ->label('Ubah Status')
                            ->form([
                                Select::make('status')
                                    ->label('Pilih Status Baru')
                                    ->options([
                                        'menunggu_pembayaran' => 'Menunggu Pembayaran',
                                        'terjadwal'           => 'Terjadwal',
                                        'dikonfirmasi'        => 'Terkonfirmasi',
                                        'selesai'             => 'Selesai',
                                        'dibatalkan'          => 'Dibatalkan',
                                        'gagal'               => 'Gagal',
                                    ])
                                    ->required(),
                            ])
                            ->action(function ($record, array $data) {
                                $record->update(['status' => $data['status']]);
                            })
                    ),
            ])
            ->defaultSort('id', 'desc')
            ->filters([
                SelectFilter::make('status')
                    ->label('Filter Status')
                    ->options([
                        'menunggu_pembayaran' => 'Menunggu Pembayaran',
                        'terjadwal'           => 'Terjadwal',
                        'dikonfirmasi'        => 'Terkonfirmasi',
                        'selesai'             => 'Selesai',
                        'dibatalkan'          => 'Dibatalkan',
                        'gagal'               => 'Gagal',
                    ]),
                SelectFilter::make('grooming_service_id')
                    ->label('Filter Layanan')
                    ->relationship('service', 'name'),
            ])
            ->recordActions([
                ViewAction::make(),
                EditAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    BulkAction::make('mark_as_selesai')
                        ->label('Tandai Selesai')
                        ->icon('heroicon-o-check-circle')
                        ->color('success')
                        ->action(fn (Collection $records) => $records->each->update(['status' => 'selesai'])),

                    BulkAction::make('mark_as_dibatalkan')
                        ->label('Batalkan Booking')
                        ->icon('heroicon-o-x-circle')
                        ->color('danger')
                        ->action(fn (Collection $records) => $records->each->update(['status' => 'dibatalkan'])),

                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}