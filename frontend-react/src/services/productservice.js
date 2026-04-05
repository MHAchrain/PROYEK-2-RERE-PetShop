import api from "../api/axios";

export const getProducts = async () => {
  const res = await api.get("/produk");
  return res.data.data; // sesuaikan backend
};

export const getProductById = async (id) => {
  const res = await api.get(`/produk/${id}`);
  return res.data.data;
};