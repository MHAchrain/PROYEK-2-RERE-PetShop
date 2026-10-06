<?php

namespace App\Filament\Resources\Kategoris\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class KategorisTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                TextColumn::make('row_index')
                    ->label('#')
                    ->rowIndex(),

                TextColumn::make('id_kategori')
                    ->label('ID Kategori')
                    ->formatStateUsing(function ($state) {
                        $last4 = substr(str_pad((string) $state, 4, '0', STR_PAD_LEFT), -4);
                        return 'CAT-' . $last4;
                    })
                    ->sortable(),

                TextColumn::make('nama_kategori')
                    ->label('Nama Kategori')
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
            ->defaultSort('id_kategori', 'desc')
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