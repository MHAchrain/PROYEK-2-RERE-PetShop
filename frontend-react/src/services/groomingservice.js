import { groomingServices, groomingSlots } from '../Data';

// Data dummy sementara. Nanti fungsi-fungsi ini bisa diganti dengan request API.
export const getGroomingServices = async () => {
    return groomingServices.filter((service) => service.isActive);
};

// Kembalikan semua slot pada tanggal tersebut agar UI dapat menampilkan slot penuh sebagai nonaktif.
export const getGroomingSlots = async (date) => {
    if (!date) return [];
    return groomingSlots.filter((slot) => slot.date === date);
};

// Membuat booking dummy. Booking ini belum disimpan permanen dan belum mengubah kapasitas slot; slot baru dianggap terisi setelah pembayaran sukses.
export const createGroomingBooking = async (bookingData) => {
    const service = groomingServices.find(
        (item) => String(item.id) === String(bookingData.serviceId) && item.isActive,
    );

    if (!service) {
        throw new Error('Layanan grooming tidak tersedia.');
    }

    const slot = groomingSlots.find(
        (item) => item.date === bookingData.date && item.time === bookingData.time,
    );

    if (!slot) {
        throw new Error('Slot grooming tidak ditemukan.');
    }

    if (slot.booked >= slot.capacity) {
        throw new Error('Slot grooming sudah penuh. Silakan pilih slot lain.');
    }

    return {
        id: `GR-${Date.now()}`,
        ...bookingData,
        serviceName: service.name,
        price: service.price,
        status: 'menunggu_pembayaran',
        createdAt: new Date().toISOString(),
    };
};