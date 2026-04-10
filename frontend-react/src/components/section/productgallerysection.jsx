import { useState, useEffect } from "react";
import ProductGallery from "../ui/productgallery";

export default function ProductGallerySection({ product }) {
    const [selectedImage, setSelectedImage] = useState(null);

    useEffect(() => {
        if (product.images.length > 0) {
        setSelectedImage(product.images[0]);
        }
    }, [product]);

    return (
        <ProductGallery
        images={product.images}
        selectedImage={selectedImage}
        onSelect={setSelectedImage}
        />
    );
}