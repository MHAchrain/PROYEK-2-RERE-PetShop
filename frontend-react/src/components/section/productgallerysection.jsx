import { useState, useEffect } from "react";
import ProductGallery from "../ui/productgallery";
import Skeleton from "../ui/skeleton";

export default function ProductGallerySection({ product, isLoading }) {
    const [selectedImage, setSelectedImage] = useState(null);

    useEffect(() => {
        if (product?.images?.length > 0) {
        setSelectedImage(product.images[0]);
        }
    }, [product]);

    if (isLoading) {
        return (
            <div className="flex gap-4">

            {/* Thumbnail */}
            <div className="flex flex-col gap-2">
            {[...Array(4)].map((_, i) => (
                <Skeleton key={i} className="w-16 h-16" />
            ))}
            </div>

            {/* Main Image */}
            <div className="flex-1">
            <Skeleton className="w-full h-80 rounded-lg" />
            </div>

        </div>
        );
    }

    if (!product) return null;

    return (
        <ProductGallery
        images={product.images || []}
        selectedImage={selectedImage}
        onSelect={setSelectedImage}
        />
    );
}