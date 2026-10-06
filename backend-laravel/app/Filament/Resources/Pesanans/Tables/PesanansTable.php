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
                TextColumn::make('row_index')
                    ->label('#')
                    ->rowIndex(),

                TextColumn::make('id_pesanan')
                    ->label('ID Pesanan')
                    ->formatStateUsing(fn ($state) => 'ORD-' . str_pad($state, 4, '0', STR_PAD_LEFT))
                    ->sortable()
                    ->searchable(),

                TextColumn::make('tanggal_pesanan')
                    ->label('Tanggal')
                    ->dateTime('d M Y H:i')
                    ->sortable(),

                TextColumn::make('total')
                    ->label('Total')
                    ->formatStateUsing(fn ($state) => 'Rp ' . number_format($state, 0, ',', '.'))
                    ->sortable(),

                TextColumn::make('alamat_kirim')
                    ->label('Alamat Kirim')
                    ->searchable()
                    ->wrap(),

                TextColumn::make('status_pesanan')
                    ->label('Status')
                    ->badge()
                    ->color(fn ($state) => match($state) {
                        'baru'     => 'info',
                        'diproses' => 'warning',
                        'dikirim'  => 'primary',
                        'selesai'  => 'success',
                        'batal'    => 'danger',
                        default    => 'gray',
                    })
                    ->formatStateUsing(fn (string $state): string => match ($state) {
                        'baru'     => 'Baru',
                        'diproses' => 'Diproses',
                        'dikirim'  => 'Dikirim',
                        'selesai'  => 'Selesai',
                        'batal'    => 'Dibatalkan',
                        default    => $state,
                    })
                    // ✅ ACTION UBAH STATUS (BIAR MUNCUL POPUP)
                    ->action(
                        \Filament\Actions\Action::make('ubah_status')
                            ->form([
                                \Filament\Forms\Components\Select::make('status_pesanan')
                                    ->label('Ubah Status')
                                    ->options([
                                        'baru'     => 'Baru',
                                        'diproses' => 'Diproses',
                                        'dikirim'  => 'Dikirim',
                                        'selesai'  => 'Selesai',
                                        'batal'    => 'Dibatalkan',
                                    ])
                                    ->required(),
                            ])
                            ->action(function ($record, array $data) {
                                $record->update(['status_pesanan' => $data['status_pesanan']]);
                            })
                    ),
            ])
            ->defaultSort('id_pesanan', 'desc')
            ->paginationPageOptions([10])
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