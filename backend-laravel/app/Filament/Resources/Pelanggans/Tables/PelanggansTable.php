<?php

namespace App\Filament\Resources\Pelanggans\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\ViewAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class PelanggansTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('row_index')
                    ->label('#')
                    ->rowIndex(),

                TextColumn::make('id_pelanggan')
                    ->label('ID Pelanggan')
                    ->formatStateUsing(function ($state) {
                        // Ambil 3 digit terakhir
                        $last3 = substr(str_pad((string) $state, 3, '0', STR_PAD_LEFT), -3);
                        return 'PLG-' . $last3;
                    })
                    ->sortable(),

                TextColumn::make('nama')
                    ->searchable(),

                TextColumn::make('email')
                    ->label('Email address')
                    ->searchable(),

                TextColumn::make('no_hp')
                    ->searchable(),

                TextColumn::make('alamat')
                    ->label('Alamat')
                    ->searchable(),

                TextColumn::make('created_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),

                TextColumn::make('updated_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->defaultSort('id_pelanggan', 'desc')
            ->paginationPageOptions([10])
            ->filters([
                //
            ])
            ->recordActions([
                \Filament\Actions\DeleteAction::make(),
            ])
            ->toolbarActions([
                BulkActionGroup::make([
                    DeleteBulkAction::make(),
                ]),
            ]);
    }
}