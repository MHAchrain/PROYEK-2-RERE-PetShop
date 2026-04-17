import api from "../api/axios";

export const wishlistService = {
  getAll: async () => {
    const res = await api.get("/favorites");
    return res.data.data;
  },

  add: async (productId) => {
    const res = await api.post("/favorites", {
      produk_id: productId,
    });
    return res.data.data;
  },

  remove: async (productId) => {
    const res = await api.delete(`/favorites/${productId}`);
    return res.data.data;
  },
};