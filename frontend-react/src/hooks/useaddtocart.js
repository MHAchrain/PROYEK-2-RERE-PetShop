import { useNavigate } from "react-router-dom";
import toast from "react-hot-toast";
import { useAuth } from "../context/authcontext";
import { useCart } from "../context/cartcontext";
import { addCartItem } from "../services/cartservice";

export const useAddToCart = () => {
  const navigate = useNavigate();
  const { user } = useAuth();
  const { setCart } = useCart();

  const addToCart = async ({ productId, quantity = 1, requireAuth = false, onSuccess }) => {
    if (requireAuth && !user) {
      toast.error("Login dulu buat tambah ke keranjang");
      navigate("/auth");
      return false;
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
      return true;
    } catch (error) {
      return false;
    }
  };

  return { addToCart };
};
