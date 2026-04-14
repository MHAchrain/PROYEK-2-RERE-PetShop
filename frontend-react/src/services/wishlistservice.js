import axios from "../api/axios";

export const wishlistService = {
  getAll: async () => {
    const res = await axios.get("/api/wishlist");
    return res.data;
  },

  add: async (productId) => {
    const res = await axios.post("/api/wishlist", {
      product_id: productId,
    });
    return res.data;
  },

  remove: async (productId) => {
    const res = await axios.delete(`/api/wishlist/${productId}`);
    return res.data;
  },
};