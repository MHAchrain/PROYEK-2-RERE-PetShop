<?php

namespace App\Filament\Resources\GroomingServices\Pages;

use App\Filament\Resources\GroomingServices\GroomingServiceResource;
use Filament\Actions\DeleteAction;
use Filament\Resources\Pages\EditRecord;

class EditGroomingService extends EditRecord
{
    protected static string $resource = GroomingServiceResource::class;

    protected function getHeaderActions(): array
    {
        return [
            DeleteAction::make(),
        ];
    }
}
