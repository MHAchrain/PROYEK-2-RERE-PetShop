import api from "../api/axios";

export const getCategories = async () => {
  const res = await api.get("/kategori");
  return res.data.data;
};

export const getCategoriesById = async (id) => {
  const res = await api.get(`/kategori/${id}`);
  return res.data.data;
};

export const getProductsByCategory = async (id) => {
  const res = await api.get(`/kategori/${id}/produk`);
  return res.data.data;
};