import { Heart, Eye, Star } from "lucide-react";
import { useNavigate } from "react-router-dom";
import { Link } from "react-router-dom";

export default function ProductCard({ id, nama, harga, image, diskon, rating }) {
    const hasDiskon = diskon > 0;

    const hargaFinal = hasDiskon
    ? harga - (harga * diskon) / 100
    : harga;

    const navigate = useNavigate();

    return (
        <div className="relative group rounded-sm overflow-hidden 
        transition-all duration-500 hover:scale-105">

        {/* IMAGE WRAPPER */}
        <div className="relative aspect-square overflow-hidden">

            {/* Clickable Area */}
            <Link to={`/product/${id}`} className="block w-full h-full">
                <img
                src={image[0]}
                alt={nama}
                loading="lazy"
                className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
                />
            </Link>

            {/* Discount Badge */}
            {hasDiskon && (
            <div className="absolute top-3 left-3 bg-red-700 text-white text-xs px-3 py-1 rounded-md z-20">
                -{diskon}%
            </div>
            )}

            {/* Right Icons */}
            <div className="absolute top-3 right-3 flex flex-col gap-2 z-20">
                <button
                    onClick={(e) => {
                    e.stopPropagation();
                    console.log("wishlist");
                    }}
                    className="bg-white p-2 rounded-full shadow hover:bg-gray-200 transition"
                >
                    <Heart size={18} />
                </button>

                <button
                    onClick={(e) => {
                    e.stopPropagation();
                    console.log("quick view");
                    }}
                    className="bg-white p-2 rounded-full shadow hover:bg-gray-200 transition"
                >
                    <Eye size={18} />
                </button>
            </div>

            {/* Add To Cart */}
            <div className="absolute bottom-0 left-0 w-full 
            translate-y-full group-hover:translate-y-0
            transition-transform duration-300 z-20">
                <button
                    onClick={(e) => {
                    e.stopPropagation();
                    console.log("add to cart");
                    }}
                    className="w-full bg-black text-white py-3 font-medium transition"
                >
                    Add to Cart
                </button>
            </div>
        </div>

        {/* PRODUCT INFO */}
        <Link to={`/product/${id}`} className="block pt-4 space-y-2 text-sm md:text-base">
            <h4 className="font-semibold truncate">
            {nama}
            </h4>

            <div className="flex items-center gap-2">
                <p className={`font-semibold ${hasDiskon ? "text-primary" : "text-gray-800"}`}>
                    Rp {hargaFinal.toLocaleString("id-ID")}
                </p>

                {hasDiskon && (
                    <p className="text-gray-400 line-through text-sm">
                    Rp {harga.toLocaleString("id-ID")}
                    </p>
                )}
            </div>

            <div className="flex gap-1">
            {[...Array(rating)].map((_, i) => (
                <Star key={i} size={16} className="fill-yellow-400 text-yellow-400" />
            ))}
            </div>
        </Link>
    </div>
    )
}