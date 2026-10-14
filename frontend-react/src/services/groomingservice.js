import api from '../api/axios';
import { groomingServices as fallbackServices } from '../Data';

// 1. Ambil daftar layanan dari API (fallback ke Data.js jika gagal)
export const getGroomingServices = async () => {
    try {
        const response = await api.get('/grooming/services');
        if (response.data?.success && Array.isArray(response.data.data)) {
            return response.data.data;
        }
    } catch {
        // Fallback jika offline / network issue
    }
    return fallbackServices.filter((service) => service.isActive);
};

// 2. Ambil slot waktu dinamis dari Backend API
export const getGroomingSlots = async (date) => {
    if (!date) return [];

    try {
        const response = await api.get('/grooming/slots', {
            params: { date },
        });

        if (response.data?.success && Array.isArray(response.data.data)) {
            return response.data.data;
        }
    } catch {
        // Jika server bermasalah, buat default fallback slot untuk tanggal yang dipilih
        const defaultTimes = ['09:00', '11:00', '13:00', '15:00', '17:00'];
        return defaultTimes.map((time) => ({
            date,
            time,
            capacity: 2,
            booked: 0,
        }));
    }

    return [];
};

// 3. Ambil riwayat booking dari Backend API
export const getGroomingBookings = async (userId) => {
    if (userId === null || userId === undefined || userId === '') return [];

    try {
        const response = await api.get('/grooming/history');
        if (response.data?.success && Array.isArray(response.data.data)) {
            return response.data.data;
        }
    } catch {
        // Abaikan
    }

    return [];
};

// 4. Buat booking baru ke Backend API (mengembalikan data booking + snap_token Midtrans)
export const createGroomingBooking = async (bookingData) => {
    const response = await api.post('/grooming/bookings', bookingData);

    if (response.data?.success) {
        return {
            ...response.data.data,
            snap_token: response.data.snap_token,
        };
    }

    throw new Error(response.data?.message || 'Gagal membuat booking grooming.');
};

// 5. Sinkronisasi status pembayaran Midtrans
export const syncGroomingPayment = async (bookingId, paymentStatus) => {
    try {
        const response = await api.post(`/grooming/bookings/${bookingId}/sync-payment`, {
            payment_status: paymentStatus,
        });
        return response.data;
    } catch {
        return null;
    }
};

// 6. Ambil token pembayaran Midtrans untuk booking lama yang belum dibayar
export const getGroomingPaymentToken = async (bookingId) => {
    const response = await api.get(`/grooming/bookings/${bookingId}/payment-token`);
    if (response.data?.success && response.data.snap_token) {
        return response.data.snap_token;
    }
    throw new Error(response.data?.message || 'Gagal memuat token pembayaran.');
};
