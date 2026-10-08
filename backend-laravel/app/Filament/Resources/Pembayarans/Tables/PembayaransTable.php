<?php

namespace App\Filament\Resources\Pembayarans\Tables;

use Filament\Actions\Action;
use Filament\Actions\EditAction;
use Filament\Actions\DeleteAction;
use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\ViewAction;
use Filament\Forms\Components\Select;
use Filament\Schemas\Components\View;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class PembayaransTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('id_pembayaran')
                    ->label('ID Pembayaran')
                    ->formatStateUsing(function ($state) {
                        $last3 = substr(str_pad((string) $state, 3, '0', STR_PAD_LEFT), -3);
                        return 'PAY-' . $last3;
                    })
                    ->sortable(),

                TextColumn::make('id_pesanan')
                    ->label('ID Pesanan')
                    ->formatStateUsing(function ($state) {
                        $last3 = substr(str_pad((string) $state, 3, '0', STR_PAD_LEFT), 0);
                        return 'ORD-' . $last3;
                    })
                    ->sortable()
                    ->searchable(),

                // ✅ NAMA PELANGGAN (via relasi pesanan)
                TextColumn::make('pesanan.pelanggan.nama')
                    ->label('Pelanggan')
                    ->searchable()
                    ->sortable(),

                TextColumn::make('status_bayar')
                    ->label('Status Bayar')
                    ->badge()
                    ->color(fn (string $state): string => match ($state) {
                        'pending' => 'warning',
                        'paid'    => 'success',
                        'failed'  => 'danger',
                        default   => 'gray',
                    })
                    ->action(
                        Action::make('updateStatus')
                            ->form([
                                Select::make('status_bayar')
                                    ->label('Ganti Status Pembayaran')
                                    ->options([
                                        'pending' => 'ditunda',
                                        'paid'    => 'sudah bayar',
                                        'failed'  => 'gagal bayar',
                                    ])
                                    ->required(),
                            ])
                            ->action(function ($record, array $data): void {
                                $record->update($data);
                            })
                    ),

                TextColumn::make('metode_bayar')
                    ->label('Metode')
                    ->searchable(),

                TextColumn::make('jumlah_bayar')
                    ->label('Jumlah Bayar')
                    ->formatStateUsing(fn ($state) => 'Rp ' . number_format($state, 0, ',', '.'))
                    ->sortable(),

                TextColumn::make('waktu_bayar')
                    ->label('Tanggal Pembayaran')
                    ->dateTime('d M Y H:i')
                    ->sortable(),
            ])
            ->defaultSort('id_pembayaran', 'desc')
            ->paginationPageOptions([50])
            ->filters([])
            ->recordActions([
                ViewAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}