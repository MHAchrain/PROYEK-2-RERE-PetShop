<?php

namespace App\Filament\Resources\PesananDetails\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class PesananDetailsTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('id_pesanan')
                    ->label('ID Pesanan')
                    ->formatStateUsing(function ($state) {
                        $last3 = substr(str_pad((string) $state, 3, '0', STR_PAD_LEFT), 0);
                        return 'ORD-' . $last3;
                    })
                    ->sortable(),

                TextColumn::make('produk.nama_produk')
                    ->label('Nama Produk')
                    ->searchable()
                    ->sortable(),

                TextColumn::make('qty')
                    ->label('Qty')
                    ->numeric()
                    ->sortable(),

                TextColumn::make('harga_satuan')
                    ->label('Harga Satuan')
                    ->formatStateUsing(fn ($state) => 'Rp ' . number_format($state, 0, ',', '.'))
                    ->sortable(),

                TextColumn::make('subtotal')
                    ->label('Subtotal')
                    ->formatStateUsing(fn ($state) => 'Rp ' . number_format($state, 0, ',', '.'))
                    ->sortable(),
            ])
            ->defaultSort('id_detail', 'desc')   // ← Terbaru di atas
            ->paginationPageOptions([100])
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