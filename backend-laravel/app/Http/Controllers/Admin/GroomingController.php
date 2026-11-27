<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\GroomingBooking;
use App\Models\GroomingService;
use Illuminate\Http\Request;
use Spatie\SimpleExcel\SimpleExcelWriter;

class GroomingController extends Controller
{
    /**
     * Halaman Layanan Grooming (Paket & Tarif)
     */
    public function services()
    {
        $services = GroomingService::all();
        return view('admin.grooming.services', compact('services'));
    }

    /**
     * Halaman Pesanan / Booking Grooming
     */
    public function bookings(Request $request)
    {
        $bookingQuery = GroomingBooking::with(['pelanggan', 'service']);

        if ($request->filled('status')) {
            $bookingQuery->where('status', $request->status);
        }

        if ($request->filled('date')) {
            $bookingQuery->whereDate('date', $request->date);
        }

        $bookings = $bookingQuery->latest('id')->paginate(15)->withQueryString();

        try {
            \Midtrans\Config::$serverKey = config('midtrans.server_key');
            \Midtrans\Config::$isProduction = (bool) config('midtrans.is_production', false);

            foreach ($bookings as $b) {
                if (!empty($b->midtrans_order_id) && (empty($b->payment_method) || $b->status === 'menunggu_pembayaran')) {
                    try {
                        $s = (object) \Midtrans\Transaction::status($b->midtrans_order_id);
                        $pt = $s->payment_type ?? null;
                        $bank = $s->va_numbers[0]->bank ?? null;
                        $txStatus = $s->transaction_status ?? null;

                        if ($pt === 'bank_transfer' && $bank) {
                            $b->payment_method = strtoupper($bank) . ' VA';
                        } elseif ($pt === 'echannel') {
                            $b->payment_method = 'MANDIRI VA';
                        } elseif (!empty($pt)) {
                            $b->payment_method = strtoupper(str_replace('_', ' ', $pt));
                        }

                        if (in_array($txStatus, ['settlement', 'capture'], true)) {
                            $b->payment_status = 'paid';
                            if ($b->status === 'menunggu_pembayaran') {
                                $b->status = 'terjadwal';
                            }
                        }
                        $b->save();
                    } catch (\Throwable $e) {
                    }
                }
            }
        } catch (\Throwable $e) {
        }

        return view('admin.grooming.bookings', compact('bookings'));
    }

    public function storeService(Request $request)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'price' => ['required', 'numeric', 'min:0'],
            'duration_minutes' => ['required', 'integer', 'min:1'],
            'description' => ['nullable', 'string'],
        ]);

        $validated['is_active'] = $request->boolean('is_active', true);

        GroomingService::create($validated);

        return back()->with('success', 'Paket layanan grooming baru berhasil ditambahkan!');
    }

    public function updateService(Request $request, GroomingService $service)
    {
        $validated = $request->validate([
            'name' => ['required', 'string', 'max:255'],
            'price' => ['required', 'numeric', 'min:0'],
            'duration_minutes' => ['required', 'integer', 'min:1'],
            'description' => ['nullable', 'string'],
        ]);

        $validated['is_active'] = $request->boolean('is_active');

        $service->update($validated);

        return back()->with('success', 'Paket layanan grooming berhasil diperbarui!');
    }

    public function toggleServiceStatus(GroomingService $service)
    {
        $service->update([
            'is_active' => !$service->is_active,
        ]);

        $statusText = $service->is_active ? 'diaktifkan' : 'dinonaktifkan';
        return back()->with('success', "Paket {$service->name} berhasil {$statusText}!");
    }

    public function destroyService(GroomingService $service)
    {
        $service->delete();
        return back()->with('success', "Paket layanan {$service->name} berhasil dihapus!");
    }

    public function updateBookingStatus(Request $request, GroomingBooking $booking)
    {
        $validated = $request->validate([
            'status' => ['required', 'string', 'max:50'],
        ]);

        $booking->update($validated);

        return back()->with('success', 'Status pesanan grooming berhasil diubah!');
    }

    public function exportBookings()
    {
        $fileName = 'rekap_pesanan_grooming_' . date('Y-m-d_His') . '.xlsx';
        $filePath = storage_path('app/temp_' . $fileName);

        $writer = SimpleExcelWriter::create($filePath);

        GroomingBooking::with(['pelanggan', 'service'])->chunk(100, function ($bookings) use ($writer) {
            foreach ($bookings as $b) {
                $writer->addRow([
                    'Kode Booking' => $b->kode_booking,
                    'Tanggal' => $b->date ? $b->date->format('Y-m-d') : '-',
                    'Waktu' => (string) $b->time,
                    'Pelanggan' => $b->pelanggan->nama ?? '-',
                    'No HP' => $b->pelanggan->no_hp ?? '-',
                    'Nama Hewan' => $b->pet_name,
                    'Jenis Hewan' => $b->pet_type,
                    'Ras' => $b->pet_breed ?? '-',
                    'Ukuran' => $b->pet_size ?? '-',
                    'Layanan' => $b->service->name ?? '-',
                    'Tarif (Rp)' => (float) $b->price,
                    'Status' => (string) $b->status,
                ]);
            }
        });

        return response()->download($filePath, $fileName)->deleteFileAfterSend(true);
    }
}
