import { Heart, Eye, Star } from "lucide-react";

export default function ProductCard({ nama, harga, image, diskon, rating }) {
    return (
        <div className="relative w-full rounded-sm overflow-hidden">
            {/* Image Section */}
            <div className="group relative w-full aspect-square bg-cover bg-center overflow-hidden" 
            style={{ backgroundImage: `url(${image})` }}>

                {/* Discount */}
                    <div className="absolute top-3 left-3 bg-red-700 text-white text-xs px-3 py-1 rounded-md z-10">
                        -{diskon}%
                    </div>

                {/* Right Icons */}
                <div className="absolute top-3 right-3 flex flex-col gap-2 z-10">
                    <button className="bg-white p-2 rounded-full shadow cursor-pointer hover:bg-gray-200 transition">
                        <Heart size={18} />
                    </button>
                    <button className="bg-white p-2 rounded-full shadow cursor-pointer hover:bg-gray-200 transition">
                        <Eye size={18} />
                    </button>
                </div>

                {/* Button Add to Cart */}
                <div className="absolute bottom-0 left-0 w-full translate-y-full group-hover:translate-y-0
                                transition-transform duration-300">
                    <button className="w-full bg-black text-white py-3 font-medium">
                        Add to Cart
                    </button>
                </div>
            </div>

            {/* Product Section */}
            <div className="pt-4 space-y-2 text-sm md:text-base">
                <h4 className="font-semibold truncate">
                    {nama}
                </h4>
                <p className="text-red-400">
                    Rp {harga.toLocaleString('id-ID')}
                </p>
                <div className="flex gap-1">
                    {[...Array(rating)].map((_, i) => (
                        <Star key={i} size={16} className="fill-yellow-400 text-yellow-400" />
                    ))}
                </div>
            </div>
        </div>
    )
}