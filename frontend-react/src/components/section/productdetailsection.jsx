import { useState } from "react";
import ProductDetail from "../ui/productdetail";

export default function ProductDetailSection({ product }) {
    const [qty, setQty] = useState(1);

    return (
        <ProductDetail
        product={product}
        qty={qty}
        setQty={setQty}
        />
    );
}