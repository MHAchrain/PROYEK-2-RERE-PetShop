<?php

namespace App\Filament\Resources\Pembayarans\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
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
                    ->formatStateUsing(fn ($state) => 'PAY-' . str_pad($state, 4, '0', STR_PAD_LEFT))
                    ->sortable(),

                TextColumn::make('id_pesanan')
                    ->label('ID Pesanan')
                    ->formatStateUsing(fn ($state) => 'ORD-' . str_pad($state, 4, '0', STR_PAD_LEFT))
                    ->sortable(),

                TextColumn::make('metode_bayar')
                    ->label('Metode')
                    ->searchable(),

                TextColumn::make('jumlah_bayar')
                    ->label('Jumlah Bayar')
                    ->formatStateUsing(fn ($state) => 'Rp ' . number_format($state, 0, ',', '.'))
                    ->sortable(),

                TextColumn::make('ref_gateway')
                    ->label('Ref Gateway'),

                TextColumn::make('status_bayar')
                    ->label('Status')
                    ->badge(),

                TextColumn::make('waktu_bayar')
                    ->label('Tanggal Pembayaran')
                    ->dateTime()
                    ->sortable(),

            ])
            ->filters([
                //
            ])
            ->recordActions([
                EditAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}