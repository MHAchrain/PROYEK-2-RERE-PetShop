import api from "../api/axios";

const shuffleProducts = (products = []) => {
  const shuffled = [...products];

  for (let i = shuffled.length - 1; i > 0; i -= 1) {
    const randomIndex = Math.floor(Math.random() * (i + 1));
    [shuffled[i], shuffled[randomIndex]] = [shuffled[randomIndex], shuffled[i]];
  }

  return shuffled;
};

export const getProducts = async ({ shuffle = true } = {}) => {
  const res = await api.get("/produk");
  const products = Array.isArray(res.data.data) ? res.data.data : [];

  return shuffle ? shuffleProducts(products) : products;
};

export const getProductById = async (id) => {
  const res = await api.get(`/produk/${id}`);
  return res.data.data;
};

export const getProductsByCategory = async (id) => {
  const res = await api.get(`/kategori/${id}/produk`);
  const result = res.data?.data?.produks || [];
  return result;
};
