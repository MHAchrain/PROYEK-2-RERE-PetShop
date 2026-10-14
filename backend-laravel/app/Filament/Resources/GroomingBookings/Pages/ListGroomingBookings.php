<?php

namespace App\Filament\Resources\GroomingBookings\Pages;

use App\Filament\Resources\GroomingBookings\GroomingBookingResource;
use Filament\Actions\CreateAction;
use Filament\Resources\Pages\ListRecords;

class ListGroomingBookings extends ListRecords
{
    protected static string $resource = GroomingBookingResource::class;

    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make(),
        ];
    }
}
