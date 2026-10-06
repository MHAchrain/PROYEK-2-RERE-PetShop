<?php

namespace App\Http\Requests;

use Illuminate\Foundation\Http\FormRequest;

class StoreGroomingBookingRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    public function rules(): array
    {
        return [
            'serviceId' => 'required|exists:grooming_services,id',
            'petName'   => 'required|string|max:100',
            'petType'   => 'required|string|max:100',
            'petBreed'  => 'required|string|max:100',
            'petSize'   => 'required|string|max:50',
            'petNote'   => 'nullable|string|max:1000',
            'date'      => 'required|date|after_or_equal:today',
            'time'      => 'required|string|max:20',
        ];
    }

    public function messages(): array
    {
        return [
            'serviceId.required'        => 'Pilih layanan grooming terlebih dahulu.',
            'serviceId.exists'          => 'Layanan grooming tidak valid.',
            'petName.required'          => 'Isi nama hewan terlebih dahulu.',
            'petType.required'          => 'Isi jenis hewan terlebih dahulu.',
            'petBreed.required'         => 'Isi ras hewan terlebih dahulu.',
            'petSize.required'          => 'Pilih/isi ukuran hewan terlebih dahulu.',
            'date.required'             => 'Pilih tanggal grooming terlebih dahulu.',
            'date.after_or_equal'       => 'Tanggal booking tidak boleh tanggal kemarin.',
            'time.required'             => 'Pilih slot waktu terlebih dahulu.',
        ];
    }
}
