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
                ->sortable(),

            TextColumn::make('id_pelanggan')
                ->label('Pelanggan')
                ->sortable(),

            TextColumn::make('tanggal_pesanan')
                ->dateTime()
                ->sortable(),

            TextColumn::make('total')
                ->sortable(),

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
