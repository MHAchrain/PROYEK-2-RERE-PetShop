<?php

namespace App\Filament\Resources\Produks\Tables;

use Filament\Actions\BulkActionGroup;
use Filament\Actions\DeleteBulkAction;
use Filament\Actions\EditAction;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;

class ProduksTable
{
    public static function configure(Table $table): Table
    {
        return $table
            ->columns([
                 TextColumn::make('id_produk')
                    ->label('ID PRODUK')
                    ->formatStateUsing(fn ($state) => 'PRO-' . str_pad($state, 4, '0', STR_PAD_LEFT))
                    ->sortable(),

                TextColumn::make('id_kategori')
                    ->label('Kategori')
                    ->formatStateUsing(function ($state, $record) {
                         return 'CAT-' . str_pad($record->kategori->id_kategori, 4, '0', STR_PAD_LEFT)
                          . ' - ' . $record->kategori->nama_kategori;
                    })
                    ->sortable(),

                TextColumn::make('nama_produk')
                    ->label('Nama Produk')
                    ->searchable(),
                TextColumn::make('harga')
                    ->label('Harga')
                    ->numeric()
                    ->sortable(),
                TextColumn::make('stok')
                    ->label('Stok')
                    ->numeric()
                    ->sortable(),
                TextColumn::make('foto')
                    ->label('Foto')     
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
