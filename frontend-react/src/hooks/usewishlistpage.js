import { useEffect, useMemo, useState } from "react";
import toast from "../utils/toast.jsx";
import { wishlistService } from "../services/wishlistservice";
import { getProducts } from "../services/productservice";

export const useWishlistPage = () => {
  const [wishlistItems, setWishlistItems] = useState([]);
  const [isLoading, setIsLoading] = useState(true);
  const [removingId, setRemovingId] = useState(null);
  const [recommendedProducts, setRecommendedProducts] = useState([]);
  const [isRecommendationLoading, setIsRecommendationLoading] = useState(true);

  useEffect(() => {
    const fetchWishlist = async () => {
      try {
        const data = await wishlistService.getAll();
        setWishlistItems(data || []);
      } catch (error) {
        console.error("Gagal mengambil wishlist:", error.response?.data || error.message);
        toast.error("Gagal memuat wishlist");
      } finally {
        setIsLoading(false);
      }
    };

    fetchWishlist();
  }, []);

  useEffect(() => {
    const fetchRecommendations = async () => {
      try {
        const data = await getProducts();
        setRecommendedProducts(Array.isArray(data) ? data : []);
      } catch (error) {
        console.error("Gagal mengambil produk rekomendasi:", error.response?.data || error.message);
      } finally {
        setIsRecommendationLoading(false);
      }
    };

    fetchRecommendations();
  }, []);

  const products = useMemo(
    () => wishlistItems.map((item) => item.produk).filter(Boolean),
    [wishlistItems]
  );

  const wishlistIds = useMemo(
    () => new Set(products.map((item) => item.id_produk)),
    [products]
  );

  const justForYouProducts = useMemo(
    () => recommendedProducts.filter((item) => !wishlistIds.has(item.id_produk)).slice(0, 4),
    [recommendedProducts, wishlistIds]
  );

  const removeWishlistItem = async (productId, showToast = true) => {
    setRemovingId(productId);

    try {
      await wishlistService.remove(productId);
      setWishlistItems((prev) => prev.filter((item) => item.produk?.id_produk !== productId));
      if (showToast) {
        toast.success("Produk dihapus dari wishlist");
      }
      return true;
    } catch (error) {
      console.error("Gagal menghapus wishlist:", error.response?.data || error.message);
      if (showToast) {
        toast.error("Gagal menghapus produk dari wishlist");
      }
      return false;
    } finally {
      setRemovingId(null);
    }
  };

  const handleAddFromJustForYou = (product) => {
    if (!product?.id_produk) return;

    setWishlistItems((prev) => {
      const alreadyExists = prev.some((item) => item.produk?.id_produk === product.id_produk);

      if (alreadyExists) {
        return prev;
      }

      return [
        {
          id: `favorite-${product.id_produk}`,
          produk_id: product.id_produk,
          produk: product,
        },
        ...prev,
      ];
    });
  };

  return {
    wishlistItems,
    products,
    wishlistCount: products.length,
    isLoading,
    removingId,
    justForYouProducts,
    isRecommendationLoading,
    removeWishlistItem,
    handleAddFromJustForYou,
  };
};


