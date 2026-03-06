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
                    ->label('ID')
                    ->sortable(),

                TextColumn::make('id_pesanan')
                    ->label('ID Pesanan')
                    ->sortable(),

                TextColumn::make('metode_pembayaran')
                    ->label('Metode')
                    ->searchable(),

                TextColumn::make('jumlah_bayar')
                    ->label('Jumlah Bayar')
                    ->sortable(),

                TextColumn::make('status_pembayaran')
                    ->label('Status')
                    ->badge(),

                TextColumn::make('tanggal_pembayaran')
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