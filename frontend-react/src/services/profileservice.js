import api from "../api/axios";

export const updateCustomerProfile = async (payload) => {
  const res = await api.post("/pelanggan/update", payload);
  return res.data;
};
