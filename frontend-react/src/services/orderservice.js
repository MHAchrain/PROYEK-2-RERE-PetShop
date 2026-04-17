import api from "../api/axios";

// Memanggil public function index
export const getOrders = async () => {
    try {
        const res = await api.get("/pesanan");
        return res.data.data || []; // Laravel return object dengan key 'data'
    } catch (error) {
        console.error("Gagal ambil riwayat pesanan:", error);
        throw error;
    }
};

// Memanggil public function show
export const getOrderDetail = async (id) => {
    try {
        const res = await api.get(`/pesanan/${id}`);
        return res.data.data;
    } catch (error) {
        console.error("Gagal ambil detail pesanan:", error);
        throw error;
    }
};

// Memanggil public function selesai
export const markOrderAsFinished = async (id) => {
    try {
        const res = await api.post(`/pesanan/${id}/selesai`);
        return res.data;
    } catch (error) {
        // Lu bisa tangkap pesan error 422 dari Laravel di sini
        const msg = error.response?.data?.message || "Gagal konfirmasi selesai";
        throw new Error(msg);
    }
};

// Memanggil public function batal
export const cancelOrder = async (id) => {
    try {
        const res = await api.post(`/pesanan/${id}/batal`);
        return res.data;
    } catch (error) {
        const msg = error.response?.data?.message || "Gagal membatalkan pesanan";
        throw new Error(msg);
    }
};