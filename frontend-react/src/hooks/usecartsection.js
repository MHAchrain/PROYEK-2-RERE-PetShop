import { useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import toast from "react-hot-toast";
import { useCart } from "../context/cartcontext";
import { fetchCart, removeCartItem, checkoutCart } from "../services/cartservice";

export const useCartSection = ({ token }) => {
  const { cart, setCart } = useCart();
  const navigate = useNavigate();
  const [isLoading, setIsLoading] = useState(true);
  const [isCheckingOut, setIsCheckingOut] = useState(false);

  const total = useMemo(
    () =>
      cart?.items?.reduce((sum, item) => {
        const harga = Number(item.produk?.harga) || 0;
        const qty = Number(item.qty) || 0;
        return sum + harga * qty;
      }, 0) || 0,
    [cart]
  );

  useEffect(() => {
    if (!token) {
      setIsLoading(true);
      return;
    }

    const loadCart = async () => {
      try {
        const cartData = await fetchCart();
        setCart(cartData);
      } catch (error) {
        console.log(error);
      } finally {
        setTimeout(() => setIsLoading(false), 800);
      }
    };

    loadCart();
  }, [token, setCart]);

  const removeItem = async (itemId) => {
    try {
      await removeCartItem(itemId);
      setCart((prev) => ({
        ...prev,
        items: prev.items.filter((item) => item.id_item !== itemId),
      }));
    } catch (error) {
      console.log(error);
    }
  };

  const updateQty = (itemId, newQty) => {
    setCart((prev) => ({
      ...prev,
      items: prev.items.map((item) =>
        item.id_item === itemId ? { ...item, qty: Math.max(1, newQty) } : item
      ),
    }));
  };

  const handleCheckout = async () => {
    try {
      setIsCheckingOut(true);
      const response = await checkoutCart();

      if (response.success) {
        toast.success("Checkout Berhasil! Pesanan sedang diproses.");
        setCart({ items: [], total: 0 });
        navigate("/order-history");
      }
    } catch (error) {
      toast.error(error.response?.data?.message || "Checkout gagal.");
    } finally {
      setIsCheckingOut(false);
    }
  };

  return {
    cart,
    total,
    isLoading,
    isCheckingOut,
    removeItem,
    updateQty,
    handleCheckout,
    navigate,
  };
};
