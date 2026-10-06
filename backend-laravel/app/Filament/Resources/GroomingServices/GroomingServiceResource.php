<?php

namespace App\Filament\Resources\GroomingServices;

use App\Filament\Resources\GroomingServices\Pages\CreateGroomingService;
use App\Filament\Resources\GroomingServices\Pages\EditGroomingService;
use App\Filament\Resources\GroomingServices\Pages\ListGroomingServices;
use App\Filament\Resources\GroomingServices\Schemas\GroomingServiceForm;
use App\Filament\Resources\GroomingServices\Tables\GroomingServicesTable;
use App\Models\GroomingService;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Tables\Table;
use UnitEnum;

class GroomingServiceResource extends Resource
{
    protected static ?string $model = GroomingService::class;

    protected static string|BackedEnum|null $navigationIcon = 'heroicon-o-sparkles';

    protected static ?string $navigationLabel = 'Layanan Grooming';

    protected static ?string $modelLabel = 'Layanan Grooming';

    protected static ?string $pluralModelLabel = 'Layanan Grooming';

    protected static string|UnitEnum|null $navigationGroup = 'Grooming';

    protected static ?int $navigationSort = 2;

    protected static ?string $recordTitleAttribute = 'name';

    public static function form(Schema $schema): Schema
    {
        return GroomingServiceForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return GroomingServicesTable::configure($table);
    }

    public static function getRelations(): array
    {
        return [];
    }

    public static function getPages(): array
    {
        return [
            'index'  => ListGroomingServices::route('/'),
            'create' => CreateGroomingService::route('/create'),
            'edit'   => EditGroomingService::route('/{record}/edit'),
        ];
    }
}
