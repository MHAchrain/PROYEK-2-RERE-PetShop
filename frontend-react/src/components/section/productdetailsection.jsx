import { useState } from "react";
import { useNavigate } from "react-router-dom";
import toast from "react-hot-toast";
import ProductDetail from "../ui/productdetail";
import Skeleton from "../ui/skeleton";
import { useAddToCart } from "../../hooks/useaddtocart";

export default function ProductDetailSection({ product, isLoading }) {
    const [qty, setQty] = useState(1);
    const [isBuyingNow, setIsBuyingNow] = useState(false);
    const navigate = useNavigate();
    const { addToCart } = useAddToCart();

    const safeStock = Number(product?.stock) || 0;
    const maxQty = safeStock > 0 ? safeStock : 1;

    const handleSetQty = (nextQty) => {
        setQty(Math.min(maxQty, Math.max(1, Number(nextQty) || 1)));
    };

    const handleBuyNow = async () => {
        if (!product?.id) return;

        if (safeStock < 1) {
            toast.error("Produk sedang habis.");
            return;
        }

        try {
            setIsBuyingNow(true);

            const success = await addToCart({
                productId: product.id,
                quantity: qty,
                requireAuth: true,
                onSuccess: async () => {
                    toast.success("Produk masuk ke keranjang.");
                    navigate("/cart");
                },
            });

            if (!success) {
                toast.error("Gagal menambahkan produk ke keranjang.");
            }
        } finally {
            setIsBuyingNow(false);
        }
    };

    if (isLoading) {
        return (
            <div>

            <Skeleton className="w-2/3 h-8 mb-2" />

            <Skeleton className="w-1/4 h-5 mt-1" />

            <Skeleton className="w-1/3 h-8 mt-2" />
            <Skeleton className="w-full h-20 mt-4" />
            <div className="flex items-center gap-4 mt-6">
            <div className="flex h-12 border border-gray-300 rounded overflow-hidden">
                <Skeleton className="w-10 h-full" />
                <Skeleton className="w-16 h-full border-x border-gray-300" />
                <Skeleton className="w-10 h-full" />
            </div>
            <Skeleton className="h-12 w-40 rounded" />
            <Skeleton className="h-12 w-12 rounded" />
            </div>

            <div className="w-fit border-2 border-gray-400 rounded mt-10">
                <div className="flex items-center gap-4 p-5">
                    <Skeleton className="w-10 h-10 rounded" />
                    <div className="flex flex-col gap-2">
                    <Skeleton className="w-32 h-4" />
                    <Skeleton className="w-48 h-3" />
                    </div>
                </div>
                <div className="border-t-2 border-gray-400"></div>
                <div className="flex items-center gap-4 p-5">
                    <Skeleton className="w-10 h-10 rounded" />
                    <div className="flex flex-col gap-2">
                    <Skeleton className="w-32 h-4" />
                    <Skeleton className="w-48 h-3" />
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
        onBuyNow={handleBuyNow}
        isBuyingNow={isBuyingNow}
        />
    );
}
