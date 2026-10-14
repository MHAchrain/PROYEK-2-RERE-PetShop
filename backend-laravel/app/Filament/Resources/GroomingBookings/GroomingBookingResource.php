<?php

namespace App\Filament\Resources\GroomingBookings;

use App\Filament\Resources\GroomingBookings\Pages\CreateGroomingBooking;
use App\Filament\Resources\GroomingBookings\Pages\EditGroomingBooking;
use App\Filament\Resources\GroomingBookings\Pages\ListGroomingBookings;
use App\Filament\Resources\GroomingBookings\Pages\ViewGroomingBooking;
use App\Filament\Resources\GroomingBookings\Schemas\GroomingBookingForm;
use App\Filament\Resources\GroomingBookings\Tables\GroomingBookingsTable;
use App\Models\GroomingBooking;
use BackedEnum;
use Filament\Resources\Resource;
use Filament\Schemas\Schema;
use Filament\Tables\Table;
use UnitEnum;

class GroomingBookingResource extends Resource
{
    protected static ?string $model = GroomingBooking::class;

    protected static string|BackedEnum|null $navigationIcon = 'heroicon-o-calendar-days';

    protected static ?string $navigationLabel = 'Booking Grooming';

    protected static ?string $modelLabel = 'Booking Grooming';

    protected static ?string $pluralModelLabel = 'Booking Grooming';

    protected static string|UnitEnum|null $navigationGroup = 'Grooming';

    protected static ?int $navigationSort = 1;

    protected static ?string $recordTitleAttribute = 'id';

    public static function form(Schema $schema): Schema
    {
        return GroomingBookingForm::configure($schema);
    }

    public static function table(Table $table): Table
    {
        return GroomingBookingsTable::configure($table);
    }

    public static function getRelations(): array
    {
        return [];
    }

    public static function getPages(): array
    {
        return [
            'index'  => ListGroomingBookings::route('/'),
            'create' => CreateGroomingBooking::route('/create'),
            'view'   => ViewGroomingBooking::route('/{record}'),
            'edit'   => EditGroomingBooking::route('/{record}/edit'),
        ];
    }
}
