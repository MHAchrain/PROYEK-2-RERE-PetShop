<?php

namespace App\Filament\Widgets;

use App\Models\Pesanan;
use App\Models\Pengiriman;
use Filament\Actions\Action;
use Filament\Forms\Components\Select;
use Filament\Tables\Columns\TextColumn;
use Filament\Tables\Table;
use Filament\Widgets\TableWidget as BaseWidget;
use Filament\Notifications\Notification;

class PesananSiapKirim extends BaseWidget
{
    protected static ?string $heading = '📦 Pesanan Siap Kirim';
    
    protected int | string | array $columnSpan = 'full';
    
    protected static ?int $sort = 2;

    public function table(Table $table): Table
    {
        return $table
            ->query(
                Pesanan::query()
                    ->whereHas('pembayaran', function ($q) {
                        $q->where('status_bayar', 'paid');
                    })
                    ->whereIn('status_pesanan', ['baru', 'diproses'])
                    ->orderBy('id_pesanan', 'desc')
            )
            ->columns([
                TextColumn::make('id_pesanan')
                    ->label('ID Pesanan')
                    ->formatStateUsing(fn ($state) => 'ORD-' . str_pad($state, 4, '0', STR_PAD_LEFT))
                    ->searchable(),

                TextColumn::make('tanggal_pesanan')
                    ->label('Tanggal')
                    ->dateTime('d M Y H:i')
                    ->sortable(),

                TextColumn::make('total')
                    ->label('Total')
                    ->formatStateUsing(fn ($state) => 'Rp ' . number_format($state, 0, ',', '.')),

                TextColumn::make('alamat_kirim')
                    ->label('Alamat Kirim')
                    ->wrap()
                    ->searchable(),

                TextColumn::make('status_pesanan')
                    ->label('Status')
                    ->badge()
                    ->color(fn ($state) => match($state) {
                        'baru'     => 'info',
                        'diproses' => 'warning',
                        default    => 'gray',
                    })
                    ->formatStateUsing(fn ($state) => match($state) {
                        'baru'     => 'Baru',
                        'diproses' => 'Diproses',
                        default    => $state,
                    }),
            ])
            ->recordActions([
                Action::make('kirim')
                    ->label('Kirim')
                    ->icon('heroicon-o-truck')
                    ->color('success')
                    ->form([
                        Select::make('kurir')
                            ->label('Pilih Kurir')
                            ->options([
                                'jne'      => 'JNE Ekspress',
                                'ojol'     => 'Gosend/Grab',
                                'internal' => 'Kurir Internal (Udin)',
                            ])
                            ->required()
                            ->default('jne'),
                    ])
                    ->modalHeading('Kirim Pesanan?')
                    ->modalDescription(fn ($record) => 'Pesanan ' . $record->kode_pesanan . ' akan ditandai sebagai Dikirim dan resi otomatis dibuat.')
                    ->action(function ($record, array $data) {
                        // ✅ AUTO-GENERATE RESI
                        $resi = 'RESI-' . date('Ymd') . '-' . str_pad($record->id_pesanan, 4, '0', STR_PAD_LEFT);

                        // Update status pesanan
                        $record->update(['status_pesanan' => 'dikirim']);

                        // Update / buat data pengiriman
                        $pengiriman = Pengiriman::where('id_pesanan', $record->id_pesanan)->first();
                        
                        if ($pengiriman) {
                            $pengiriman->update([
                                'status_kirim'  => 'dikirim',
                                'tanggal_kirim' => now(),
                                'kurir'         => $data['kurir'],
                                'resi'          => $resi,
                            ]);
                        } else {
                            Pengiriman::create([
                                'id_pesanan'    => $record->id_pesanan,
                                'status_kirim'  => 'dikirim',
                                'tanggal_kirim' => now(),
                                'kurir'         => $data['kurir'],
                                'resi'          => $resi,
                            ]);
                        }

                        Notification::make()
                            ->title('Pesanan berhasil dikirim! 🚚')
                            ->body('Kurir: ' . strtoupper($data['kurir']) . ' | Resi: ' . $resi)
                            ->success()
                            ->send();
                    }),
            ])
            ->paginated([5, 10, 25]);
    }
}