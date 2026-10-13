<?php

namespace App\Filament\Resources\PesananDetails;

use App\Filament\Resources\PesananDetails\Pages\CreatePesananDetail;
use App\Filament\Resources\PesananDetails\Pages\EditPesananDetail;
use App\Filament\Resources\PesananDetails\Pages\ListPesananDetails;
use App\Filament\Resources\PesananDetails\Schemas\PesananDetailForm;
use App\Filament\Resources\PesananDetails\Tables\PesananDetailsTable;
use App\Models\PesananDetail;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;

class PesananDetailResource extends Resource
{
    protected static ?string $model = PesananDetail::class;

    protected static string|BackedEnum|null $navigationIcon = 'heroicon-o-clipboard-document-list';
    protected static string|\UnitEnum|null $navigationGroup = 'Transaksi & Pesanan';
    protected static ?int $navigationSort = 4;
    protected static ?string $navigationLabel = 'Detail Item Pesanan';
    protected static ?string $modelLabel = 'Detail Item Pesanan';
    protected static ?string $pluralModelLabel = 'Detail Item Pesanan';

    public static function form(Schema $schema): Schema
    {
        return PesananDetailForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return PesananDetailsTable::configure($table);
    }

    public static function getRelations(): array
    {
        return [];
    }

    public static function getPages(): array
    {
        return [
            'index' => ListPesananDetails::route('/'),
            'create' => CreatePesananDetail::route('/create'),
            'edit' => EditPesananDetail::route('/{record}/edit'),
        ];
    }
}