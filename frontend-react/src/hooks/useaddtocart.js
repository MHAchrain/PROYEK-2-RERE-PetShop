import { useNavigate } from "react-router-dom";
import toast from "../utils/toast.jsx";
import { useAuth } from "../context/authcontext";
import { useCart } from "../context/cartcontext";
import { addCartItem } from "../services/cartservice";

export const useAddToCart = () => {
  const navigate = useNavigate();
  const { user } = useAuth();
  const { setCart } = useCart();

  const addToCart = async ({ productId, quantity = 1, requireAuth = false, onSuccess }) => {
    if (requireAuth && !user) {
      toast.error("Masuk dulu buat tambah ke keranjang");
      navigate("/auth");
      return { ok: false, reason: "auth_required" };
    }

    try {
      const cartData = await addCartItem({
        id_produk: productId,
        qty: quantity,
      });

      setCart((prev) => {
        if (!prev || !prev.items) {
          return cartData;
        }

        const existing = prev.items.find((item) => item.id_produk === productId);

        return {
          ...prev,
          items: existing
            ? prev.items.map((item) =>
                item.id_produk === productId ? { ...item, qty: item.qty + quantity } : item
              )
            : [...prev.items, { id_produk: productId, qty: quantity }],
        };
      });

      await onSuccess?.();
      return { ok: true, reason: null };
    } catch (error) {
      return { ok: false, reason: "request_failed", error };
    }
  };

  return { addToCart };
};


