import api from "../api/axios";
import { normalizeSearchQuery } from "../utils/searchutils";

const shuffleProducts = (products = []) => {
  const shuffled = [...products];

  for (let i = shuffled.length - 1; i > 0; i -= 1) {
    const randomIndex = Math.floor(Math.random() * (i + 1));
    [shuffled[i], shuffled[randomIndex]] = [shuffled[randomIndex], shuffled[i]];
  }

  return shuffled;
};

const getProductStock = (product = {}) => Number(product.stok ?? product.stock ?? 0) || 0;

const sortAvailableFirst = (products = []) =>
  [...products]
    .map((product, index) => ({ product, index }))
    .sort((a, b) => {
      const aHasStock = getProductStock(a.product) > 0;
      const bHasStock = getProductStock(b.product) > 0;

      if (aHasStock === bHasStock) {
        return a.index - b.index;
      }

      return aHasStock ? -1 : 1;
    })
    .map(({ product }) => product);

export const getProducts = async ({ shuffle = true } = {}) => {
  const res = await api.get("/produk");
  const products = Array.isArray(res.data.data) ? res.data.data : [];
  const preparedProducts = shuffle ? shuffleProducts(products) : products;

  return sortAvailableFirst(preparedProducts);
};

export const searchProducts = async (query) => {
  const normalizedQuery = normalizeSearchQuery(query);

  if (!normalizedQuery) {
    return [];
  }

  const res = await api.get("/produk", {
    params: {
      search: normalizedQuery,
    },
  });

  return sortAvailableFirst(Array.isArray(res.data.data) ? res.data.data : []);
};

export const getProductById = async (id) => {
  const res = await api.get(`/produk/${id}`);
  return res.data.data;
};

export const getProductsByCategory = async (id) => {
  const res = await api.get(`/kategori/${id}/produk`);
  const result = res.data?.data?.produks || [];
  return sortAvailableFirst(result);
};
