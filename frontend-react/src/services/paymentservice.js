import api from "../api/axios";

export const createPayment = async (payload) => {
  const res = await api.post("/pembayaran", payload);
  return res.data;
};

export const getPaymentByOrderId = async (orderId) => {
  const res = await api.get(`/pembayaran/${orderId}`);
  return res.data.data;
};

export const syncPaymentByOrderId = async (orderId, payload) => {
  const res = await api.patch(`/pembayaran/${orderId}/sync`, payload);
  return res.data.data;
};
