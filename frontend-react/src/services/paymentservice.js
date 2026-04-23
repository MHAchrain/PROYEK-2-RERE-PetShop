import api from "../api/axios";

export const createPayment = async (payload) => {
  const res = await api.post("/pembayaran", payload);
  return res.data;
};

export const getPaymentByOrderId = async (orderId) => {
  const res = await api.get(`/pembayaran/${orderId}`);
  return res.data.data;
};
