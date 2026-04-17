import { useEffect, useMemo, useState } from "react";
import { useNavigate } from "react-router-dom";
import toast from "react-hot-toast";
import { useCart } from "../context/cartcontext";
import { useAuth } from "../context/authcontext";
import { fetchCart, removeCartItem, checkoutCart, updateCartItemQty } from "../services/cartservice";

export const useCartSection = ({ token }) => {
  const { cart, setCart } = useCart();
  const { user } = useAuth();
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
      setCart((prev) => {
        if (!prev) return prev;

        const nextItems = prev.items.filter((item) => item.id_item !== itemId);

        return {
          ...prev,
          total: nextItems.reduce(
            (sum, item) => sum + (Number(item.produk?.harga) || 0) * (Number(item.qty) || 0),
            0
          ),
          items: nextItems,
        };
      });
      toast.success("Item dihapus dari keranjang.");
    } catch (error) {
      console.log(error);
      toast.error("Gagal menghapus item.");
    }
  };

  const updateQty = async (itemId, newQty) => {
    const safeQty = Math.max(1, newQty);
    const previousCart = cart;

    setCart((prev) => {
      if (!prev) return prev;

      const nextItems = prev.items.map((item) =>
        item.id_item === itemId ? { ...item, qty: safeQty } : item
      );

      return {
        ...prev,
        total: nextItems.reduce(
          (sum, item) => sum + (Number(item.produk?.harga) || 0) * (Number(item.qty) || 0),
          0
        ),
        items: nextItems,
      };
    });

    try {
      await updateCartItemQty(itemId, safeQty);
    } catch (error) {
      setCart(previousCart);
      toast.error(error.response?.data?.message || "Gagal memperbarui jumlah produk.");
    }
  };

  const handleCheckout = async () => {
    const pelanggan = user?.pelanggan || user?.data?.pelanggan;
    const alamatKirim = pelanggan?.alamat?.trim();
    const noTelp = pelanggan?.no_hp?.trim();

    if (!alamatKirim || !noTelp) {
      toast.error("Lengkapi alamat dan nomor telepon dulu di profil sebelum checkout.");
      navigate("/atur-akun");
      return;
    }

    try {
      setIsCheckingOut(true);

      const response = await checkoutCart({
        alamat_kirim: alamatKirim,
        no_telp: noTelp,
      });

      if (response.success) {
        toast.success("Pesanan berhasil dibuat.");
        setCart({ items: [], total: 0 });
        navigate("/pesanan");
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
