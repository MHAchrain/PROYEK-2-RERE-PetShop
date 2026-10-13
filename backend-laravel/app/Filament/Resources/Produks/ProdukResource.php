<?php

namespace App\Filament\Resources\Produks;

use App\Filament\Resources\Produks\Pages\CreateProduk;
use App\Filament\Resources\Produks\Pages\EditProduk;
use App\Filament\Resources\Produks\Pages\ListProduks;
use App\Filament\Resources\Produks\Schemas\ProdukForm;
use App\Filament\Resources\Produks\Tables\ProduksTable;
use App\Models\Produk;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Support\Icons\Heroicon;
use Filament\Tables\Table;
use UnitEnum;

class ProdukResource extends Resource
{
    protected static ?string $model = Produk::class;

    protected static string|BackedEnum|null $navigationIcon = 'heroicon-o-shopping-bag';

    protected static ?string $navigationLabel = 'Produk';

    protected static ?string $modelLabel = 'Produk';

    protected static ?string $pluralModelLabel = 'Produk';

    protected static string|UnitEnum|null $navigationGroup = 'Katalog Produk';

    protected static ?int $navigationSort = 1;

    protected static ?string $recordTitleAttribute = 'nama_produk';

    public static function getNavigationBadge(): ?string
    {
        $lowStock = static::getModel()::where('stok', '<', 5)->count();
        if ($lowStock > 0) {
            return "{$lowStock} Stok Tipis";
        }

        $total = static::getModel()::count();
        return $total > 0 ? (string) $total : null;
    }

    public static function getNavigationBadgeColor(): string|array|null
    {
        $lowStock = static::getModel()::where('stok', '<', 5)->count();
        return $lowStock > 0 ? 'danger' : 'gray';
    }

    public static function getNavigationBadgeTooltip(): ?string
    {
        $lowStock = static::getModel()::where('stok', '<', 5)->count();
        return $lowStock > 0 ? "Ada {$lowStock} produk dengan stok menipis (< 5)" : 'Total produk di katalog';
    }

    public static function form(Schema $schema): Schema
    {
        return ProdukForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return ProduksTable::configure($table);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => ListProduks::route('/'),
            'create' => CreateProduk::route('/create'),
            'edit' => EditProduk::route('/{record}/edit'),
        ];
    }
}
