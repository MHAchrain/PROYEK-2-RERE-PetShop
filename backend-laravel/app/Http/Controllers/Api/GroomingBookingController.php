<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Http\Requests\StoreGroomingBookingRequest;
use App\Models\GroomingBooking;
use App\Models\GroomingService;
use App\Models\Pelanggan;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Midtrans\Config;
use Midtrans\Snap;

class GroomingBookingController extends Controller
{
    public function __construct()
    {
        Config::$serverKey = config('midtrans.server_key'); 
        Config::$isProduction = config('midtrans.isproduction', false);
        Config::$isSanitized = config('midtrans.is_sanitized', true);
        Config::$is3ds = config('midtrans.is3ds', true);
    }
    /**
     * Helper untuk mendapatkan id_pelanggan dari user yang sedang login
     */
    private function resolvePelangganId(): ?int
    {
        $user = Auth::user();
        if (! $user) {
            return null;
        }

        if (! empty($user->pelanggan_id)) {
            return (int) $user->pelanggan_id;
        }

        // Coba cari dari email pelanggan jika pelanggan_id null
        $pelanggan = Pelanggan::where('email', $user->email)->first();
        if ($pelanggan) {
            return (int) $pelanggan->id_pelanggan;
        }

        return null;
    }

    /**
     * Daftar semua layanan grooming yang aktif (untuk form booking / grmpage)
     */
    public function services(): JsonResponse
    {
        $services = GroomingService::active()->get();

        return response()->json([
            'success' => true,
            'data'    => $services,
        ]);
    }

    /**
     * Dapatkan slot grooming untuk tanggal tertentu
     */
    public function slots(Request $request): JsonResponse
    {
        $date = $request->query('date');
        if (! $date) {
            return response()->json([
                'success' => false,
                'message' => 'Tanggal harus disertakan.',
            ], 422);
        }

        // Jam slot default
        $defaultTimes = ['09:00', '11:00', '13:00', '15:00', '17:00'];
        $capacityPerSlot = 2; // kapasitas slot default

        // Hitung booking yang sudah masuk pada tanggal & jam tersebut (yang belum dibatalkan)
        $bookedCounts = GroomingBooking::where('date', $date)
            ->whereNotIn('status', ['dibatalkan', 'gagal'])
            ->selectRaw('time, COUNT(*) as total')
            ->groupBy('time')
            ->pluck('total', 'time');

        $slots = [];
        foreach ($defaultTimes as $time) {
            $booked = $bookedCounts->get($time, 0);
            $slots[] = [
                'date'     => $date,
                'time'     => $time,
                'capacity' => $capacityPerSlot,
                'booked'   => $booked,
            ];
        }

        return response()->json([
            'success' => true,
            'data'    => $slots,
        ]);
    }

    /**
     * Ambil riwayat booking pelanggan yang login (untuk grmhistorypage)
     */
    public function history(Request $request): JsonResponse
    {
        $pelangganId = $this->resolvePelangganId();

        if (! $pelangganId) {
            return response()->json([
                'success' => false,
                'message' => 'Data profil pelanggan tidak ditemukan.',
                'data'    => [],
            ], 404);
        }

        $query = GroomingBooking::with('service')
            ->where('id_pelanggan', $pelangganId)
            ->orderBy('id', 'desc');

        if ($request->has('status') && $request->status !== 'semua') {
            $query->status($request->status);
        }

        $bookings = $query->get()->map(function ($b) {
            return [
                'id'          => $b->id,
                'kodeBooking' => $b->kode_booking,
                'userId'      => $b->id_pelanggan,
                'serviceId'   => $b->grooming_service_id,
                'serviceName' => $b->service?->name ?? 'Layanan Grooming',
                'price'       => (float) $b->price,
                'date'        => $b->date->format('Y-m-d'),
                'time'        => $b->time,
                'petName'     => $b->pet_name,
                'petType'     => $b->pet_type,
                'petBreed'    => $b->pet_breed,
                'petSize'     => $b->pet_size,
                'petNote'     => $b->pet_note,
                'status'      => $b->status,
                'createdAt'   => $b->created_at->toISOString(),
            ];
        });

        return response()->json([
            'success' => true,
            'data'    => $bookings,
        ]);
    }

    /**
     * Buat booking grooming baru
     */
    public function store(StoreGroomingBookingRequest $request): JsonResponse
    {
        $pelangganId = $this->resolvePelangganId();

        if (! $pelangganId) {
            return response()->json([
                'success' => false,
                'message' => 'Anda harus login sebagai pelanggan untuk melakukan booking.',
            ], 401);
        }

        $service = GroomingService::active()->find($request->serviceId);
        if (! $service) {
            return response()->json([
                'success' => false,
                'message' => 'Layanan grooming tidak ditemukan atau sedang nonaktif.',
            ], 404);
        }

        // Cek kapasitas slot
        $existingBookings = GroomingBooking::where('date', $request->date)
            ->where('time', $request->time)
            ->whereNotIn('status', ['dibatalkan', 'gagal'])
            ->count();

        if ($existingBookings >= 2) {
            return response()->json([
                'success' => false,
                'message' => 'Slot waktu pada jam tersebut sudah penuh.',
            ], 422);
        }

        $booking = GroomingBooking::create([
            'id_pelanggan'        => $pelangganId,
            'grooming_service_id' => $service->id,
            'pet_name'            => $request->petName,
            'pet_type'            => $request->petType,
            'pet_breed'           => $request->petBreed,
            'pet_size'            => $request->petSize,
            'pet_note'            => $request->petNote,
            'date'                => $request->date,
            'time'                => $request->time,
            'price'               => $service->price,
            'status'              => 'menunggu_pembayaran',
        ]);

        $pelanggan = Pelanggan::find($pelangganId);

        // Generate Snap Token Midtrans
        $snapToken = null;
        try {
            $transactionDetails = [
                'order_id'     => 'GROOM-' . $booking->id . '-' . time(),
                'gross_amount' => (int) $booking->price,
            ];

            $customerDetails = [
                'first_name' => $pelanggan?->nama ?? 'Pelanggan',
                'email'      => $pelanggan?->email ?? '',
                'phone'      => $pelanggan?->no_hp ?? '',
            ];

            $itemDetails = [
                [
                    'id'       => (string) $service->id,
                    'price'    => (int) $booking->price,
                    'quantity' => 1,
                    'name'     => substr('Grooming: ' . $service->name, 0, 50),
                ]
            ];

            $params = [
                'transaction_details' => $transactionDetails,
                'customer_details'    => $customerDetails,
                'item_details'        => $itemDetails,
            ];

            $snapToken = Snap::getSnapToken($params);
        } catch (\Exception $e) {
            // Log Midtrans error fallback
        }

        return response()->json([
            'success'    => true,
            'message'    => 'Booking grooming berhasil dibuat.',
            'snap_token' => $snapToken,
            'data'       => [
                'id'          => $booking->id,
                'kodeBooking' => $booking->kode_booking,
                'serviceName' => $service->name,
                'price'       => (float) $booking->price,
                'date'        => $booking->date->format('Y-m-d'),
                'time'        => $booking->time,
                'petName'     => $booking->pet_name,
                'petType'     => $booking->pet_type,
                'petBreed'    => $booking->pet_breed,
                'petSize'     => $booking->pet_size,
                'status'      => $booking->status,
                'snap_token'  => $snapToken,
            ],
        ], 201);
    }

    /**
     * Sinkronisasi status pembayaran Midtrans
     */
    public function syncPayment(Request $request, int $id): JsonResponse
    {
        $pelangganId = $this->resolvePelangganId();

        $booking = GroomingBooking::where('id_pelanggan', $pelangganId)->find($id);
        if (! $booking) {
            return response()->json([
                'success' => false,
                'message' => 'Booking tidak ditemukan.',
            ], 404);
        }

        $paymentStatus = $request->input('payment_status'); // 'settlement', 'pending', 'deny', etc.

        if (in_array($paymentStatus, ['settlement', 'capture', 'success'])) {
            $booking->update(['status' => 'terjadwal']);
        } elseif (in_array($paymentStatus, ['deny', 'cancel', 'expire'])) {
            $booking->update(['status' => 'gagal']);
        }

        return response()->json([
            'success' => true,
            'message' => 'Status booking berhasil disinkronkan.',
            'data'    => $booking,
        ]);
    }

    /**
     * Detail booking
     */
    public function show(int $id): JsonResponse
    {
        $pelangganId = $this->resolvePelangganId();

        $booking = GroomingBooking::with(['service', 'pelanggan'])
            ->where('id_pelanggan', $pelangganId)
            ->find($id);

        if (! $booking) {
            return response()->json([
                'success' => false,
                'message' => 'Data booking tidak ditemukan.',
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data'    => [
                'id'          => $booking->id,
                'kodeBooking' => $booking->kode_booking,
                'serviceName' => $booking->service?->name,
                'price'       => (float) $booking->price,
                'date'        => $booking->date->format('Y-m-d'),
                'time'        => $booking->time,
                'petName'     => $booking->pet_name,
                'petType'     => $booking->pet_type,
                'petBreed'    => $booking->pet_breed,
                'petSize'     => $booking->pet_size,
                'petNote'     => $booking->pet_note,
                'status'      => $booking->status,
                'createdAt'   => $booking->created_at->toISOString(),
            ],
        ]);
    }

    /**
     * Batalkan booking oleh pelanggan
     */
    public function cancel(int $id): JsonResponse
    {
        $pelangganId = $this->resolvePelangganId();

        $booking = GroomingBooking::where('id_pelanggan', $pelangganId)->find($id);

        if (! $booking) {
            return response()->json([
                'success' => false,
                'message' => 'Data booking tidak ditemukan.',
            ], 404);
        }

        if (in_array($booking->status, ['selesai', 'dibatalkan', 'gagal'])) {
            return response()->json([
                'success' => false,
                'message' => 'Booking dengan status ini tidak dapat dibatalkan.',
            ], 422);
        }

        $booking->update(['status' => 'dibatalkan']);

        return response()->json([
            'success' => true,
            'message' => 'Booking berhasil dibatalkan.',
            'data'    => $booking,
        ]);
    }

    /**
     * Dapatkan Snap Token Midtrans untuk booking yang statusnya masih menunggu_pembayaran
     */
    public function getPaymentToken(int $id): JsonResponse
    {
        $pelangganId = $this->resolvePelangganId();

        $booking = GroomingBooking::with(['service', 'pelanggan'])
            ->where('id_pelanggan', $pelangganId)
            ->find($id);

        if (! $booking) {
            return response()->json([
                'success' => false,
                'message' => 'Data booking tidak ditemukan.',
            ], 404);
        }

        if ($booking->status !== 'menunggu_pembayaran') {
            return response()->json([
                'success' => false,
                'message' => 'Booking ini sudah tidak dalam status menunggu pembayaran.',
            ], 400);
        }

        try {
            $transactionDetails = [
                'order_id'     => 'GROOM-' . $booking->id . '-' . time(),
                'gross_amount' => (int) $booking->price,
            ];

            $customerDetails = [
                'first_name' => $booking->pelanggan?->nama ?? 'Pelanggan',
                'email'      => $booking->pelanggan?->email ?? '',
                'phone'      => $booking->pelanggan?->no_hp ?? '',
            ];

            $itemDetails = [
                [
                    'id'       => (string) ($booking->service?->id ?? $booking->id),
                    'price'    => (int) $booking->price,
                    'quantity' => 1,
                    'name'     => substr('Grooming: ' . ($booking->service?->name ?? 'Layanan'), 0, 50),
                ]
            ];

            $params = [
                'transaction_details' => $transactionDetails,
                'customer_details'    => $customerDetails,
                'item_details'        => $itemDetails,
            ];

            $snapToken = Snap::getSnapToken($params);

            return response()->json([
                'success'    => true,
                'snap_token' => $snapToken,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Gagal membuat token pembayaran: ' . $e->getMessage(),
            ], 500);
        }
    }
}
