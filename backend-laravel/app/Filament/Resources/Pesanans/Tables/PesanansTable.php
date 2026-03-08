<?php

namespace App\Filament\Resources\Pesanans\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Actions\ViewAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class PesanansTable
{
    public static function configure(Table $table): Table
    {
        return $table
        ->columns([

            TextColumn::make('id_pesanan')
                ->label('ID Pesanan')
                ->formatStateUsing(fn ($state) => 'ORD-' . str_pad($state, 4, '0', STR_PAD_LEFT))
                ->sortable(),

            TextColumn::make('tanggal_pesanan')
                ->dateTime()
                ->sortable(),

            TextColumn::make('total')
                ->label('Total')
                ->formatStateUsing(fn ($state) => number_format($state, 0, ',', '.'))
                ->sortable(),
                
                TextColumn::make('alamat_kirim')
                ->label('Alamat Kirim')
                ->sortable(),

                 TextColumn::make('no_telp')
                ->label('Nomor Telepon')
                ->searchable(),

            TextColumn::make('status_pesanan')
                ->badge(),

        ])
        ->filters([
            //
        ])
        ->recordActions([
            ViewAction::make(),
            EditAction::make(),
        ])
        ->toolbarActions([
            BulkActionGroup::make([
                DeleteBulkAction::make(),
            ]),
        ]);
    }
}