import api from "../api/axios";

export const fetchCart = async () => {
  const res = await api.get("/cart");
  return res.data.data;
};

export const addCartItem = async (payload) => {
  const res = await api.post("/cart/add", payload);
  return res.data.data;
};

export const removeCartItem = async (itemId) => {
  const res = await api.delete(`/cart/item/${itemId}`);
  return res.data;
};

export const updateCartItemQty = async (itemId, qty) => {
  const res = await api.patch(`/cart/item/${itemId}`, { qty });
  return res.data;
};

export const checkoutCart = async (payload = {}) => {
  const res = await api.post("/checkout", payload);
  return res.data;
};
