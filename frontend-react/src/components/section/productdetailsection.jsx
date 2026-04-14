import { useState } from "react";
import ProductDetail from "../ui/productdetail";
import Skeleton from "../ui/skeleton";

export default function ProductDetailSection({ product, isLoading }) {
    const [qty, setQty] = useState(1);

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
        setQty={setQty}
        />
    );
}