<?php

namespace App\Filament\Resources\GroomingServices\Pages;

use App\Filament\Resources\GroomingServices\GroomingServiceResource;
use Filament\Actions\CreateAction;
use Filament\Resources\Pages\ListRecords;

class ListGroomingServices extends ListRecords
{
    protected static string $resource = GroomingServiceResource::class;

    protected function getHeaderActions(): array
    {
        return [
            CreateAction::make(),
        ];
    }
}
