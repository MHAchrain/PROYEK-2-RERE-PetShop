import { useEffect, useState } from "react";
import { useNavigate } from "react-router-dom";
import toast from "../../utils/toast.jsx";
import ProductDetail from "../ui/productdetail";
import Skeleton from "../ui/skeleton";
import { useAddToCart } from "../../hooks/useaddtocart";
import { useAuth } from "../../context/authcontext";
import { wishlistService } from "../../services/wishlistservice";

export default function ProductDetailSection({ product, isLoading }) {
    const [qty, setQty] = useState(1);
    const [isBuyingNow, setIsBuyingNow] = useState(false);
    const [isAddingToCart, setIsAddingToCart] = useState(false);
    const [isWishlistLoading, setIsWishlistLoading] = useState(false);
    const [isWishlisted, setIsWishlisted] = useState(false);
    const navigate = useNavigate();
    const { addToCart } = useAddToCart();
    const { user } = useAuth();

    const safeStock = Number(product?.stock) || 0;
    const maxQty = safeStock > 0 ? safeStock : 1;

    const handleSetQty = (nextQty) => {
        setQty(Math.min(maxQty, Math.max(1, Number(nextQty) || 1)));
    };

    useEffect(() => {
        let isMounted = true;

        const syncWishlistStatus = async () => {
            if (!user || !product?.id) {
                if (isMounted) {
                    setIsWishlisted(false);
                }
                return;
            }

            try {
                const wishlistItems = await wishlistService.getAll();
                const existsInWishlist = Array.isArray(wishlistItems)
                    ? wishlistItems.some((item) => Number(item.produk?.id_produk) === Number(product.id))
                    : false;

                if (isMounted) {
                    setIsWishlisted(existsInWishlist);
                }
            } catch (error) {
                console.error("Gagal sinkron status wishlist:", error.response?.data || error.message);
            }
        };

        syncWishlistStatus();

        return () => {
            isMounted = false;
        };
    }, [product?.id, user]);

    const handleAddToCart = async () => {
        if (!product?.id) return;

        if (safeStock < 1) {
            toast.error("Produk sedang habis.");
            return;
        }

        try {
            setIsAddingToCart(true);

            const result = await addToCart({
                productId: product.id,
                quantity: qty,
                requireAuth: true,
                onSuccess: async () => {
                    toast.success("Produk berhasil ditambahkan ke keranjang.");
                },
            });
            if (!result.ok && result.reason !== "auth_required") {
                toast.error("Gagal menambahkan produk ke keranjang.");
            }
        } finally {
            setIsAddingToCart(false);
        }
    }

    const handleBuyNow = async () => {
        if (!product?.id) return;

        if (safeStock < 1) {
            toast.error("Produk sedang habis.");
            return;
        }

        try {
            setIsBuyingNow(true);

            const result = await addToCart({
                productId: product.id,
                quantity: qty,
                requireAuth: true,
                onSuccess: async () => {
                    toast.success("Produk masuk ke keranjang.");
                    navigate("/cart");
                },
            });

            if (!result.ok && result.reason !== "auth_required") {
                toast.error("Gagal menambahkan produk ke keranjang.");
            }
        } finally {
            setIsBuyingNow(false);
        }
    };

    const handleAddToWishlist = async () => {
        if (!product?.id) return;

        if (!user) {
            toast.error("Masuk dulu buat tambah ke wishlist");
            navigate("/auth");
            return;
        }

        try {
            setIsWishlistLoading(true);

            if (isWishlisted) {
                await wishlistService.remove(product.id);
                setIsWishlisted(false);
                toast.success("Produk dihapus dari wishlist");
                return;
            }

            await wishlistService.add(product.id);
            setIsWishlisted(true);
            toast.success("Berhasil ditambahkan ke wishlist");
        } catch (error) {
            toast.error(isWishlisted ? "Gagal menghapus wishlist" : "Gagal menambahkan ke wishlist");
        } finally {
            setIsWishlistLoading(false);
        }
    };

    if (isLoading) {
        return (
            <div className="w-full">
                {/* Title & Badge */}
                <Skeleton className="mb-3 h-9 w-3/4 rounded-md" />
                <Skeleton className="h-7 w-32 rounded-full" />

                {/* Harga & Deskripsi */}
                <Skeleton className="mt-4 h-9 w-44 rounded-md" />
                <Skeleton className="mt-4 h-16 w-full max-w-xl rounded-md" />

                {/* Divider Line */}
                <div className="my-6 border-t border-gray-200"></div>

                {/* Action Controls (Qty + 3 Tombol) */}
                <div className="mt-6 flex flex-col items-stretch gap-4 sm:flex-row sm:items-center">
                    {/* Quantity Counter Box */}
                    <Skeleton className="h-12 w-full rounded-md sm:w-36" />

                    {/* Container Tombol Keranjang, Beli, & Wishlist */}
                    <div className="flex flex-1 gap-3">
                        {/* Tombol Keranjang */}
                        <Skeleton className="h-12 w-14 rounded-md" />
                        
                        {/* Tombol Beli Sekarang */}
                        <Skeleton className="h-12 w-40 rounded-md" />
                        
                        {/* Tombol Wishlist (Square) */}
                        <Skeleton className="h-12 w-12 shrink-0 rounded-md" />
                    </div>
                </div>

                {/* Info Card (Gratis Ongkir & Retur) */}
                <div className="mt-10 w-full overflow-hidden rounded-xl border border-gray-200 shadow-sm sm:max-w-md">
                    <div className="flex items-center gap-4 p-4 md:p-5">
                    <Skeleton className="h-12 w-12 shrink-0 rounded-lg" />
                    <div className="flex flex-1 flex-col gap-2">
                        <Skeleton className="h-4 w-28 rounded" />
                        <Skeleton className="h-3 w-48 rounded" />
                    </div>
                    </div>

                    <div className="border-t border-gray-200"></div>

                    <div className="flex items-center gap-4 p-4 md:p-5">
                    <Skeleton className="h-12 w-12 shrink-0 rounded-lg" />
                    <div className="flex flex-1 flex-col gap-2">
                        <Skeleton className="h-4 w-28 rounded" />
                        <Skeleton className="h-3 w-48 rounded" />
                    </div>
                    </div>
                </div>
            </div>
        );
    }
    if (!product) return null;

    return (
        <ProductDetail
        product={product}
        qty={qty}
        setQty={handleSetQty}
        onAddToCart={handleAddToCart}
        onBuyNow={handleBuyNow}
        onAddToWishlist={handleAddToWishlist}
        isAddingToCart={isAddingToCart}
        isBuyingNow={isBuyingNow}
        isWishlistLoading={isWishlistLoading}
        isWishlisted={isWishlisted}
        />
    );
}
