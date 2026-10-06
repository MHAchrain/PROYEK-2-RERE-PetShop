<?php

namespace App\Filament\Resources\GroomingBookings\Pages;

use App\Filament\Resources\GroomingBookings\GroomingBookingResource;
use Filament\Actions\EditAction;
use Filament\Resources\Pages\ViewRecord;

class ViewGroomingBooking extends ViewRecord
{
    protected static string $resource = GroomingBookingResource::class;

    protected function getHeaderActions(): array
    {
        return [
            EditAction::make(),
        ];
    }
}
