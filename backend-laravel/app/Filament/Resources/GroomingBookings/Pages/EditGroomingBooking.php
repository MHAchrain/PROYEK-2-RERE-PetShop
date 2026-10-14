<?php

namespace App\Filament\Resources\GroomingBookings\Pages;

use App\Filament\Resources\GroomingBookings\GroomingBookingResource;
use Filament\Actions\DeleteAction;
use Filament\Resources\Pages\EditRecord;

class EditGroomingBooking extends EditRecord
{
    protected static string $resource = GroomingBookingResource::class;

    protected function getHeaderActions(): array
    {
        return [
            DeleteAction::make(),
        ];
    }
}
