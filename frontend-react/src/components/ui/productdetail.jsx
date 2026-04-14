import { Truck, RefreshCcw, Heart, Plus, Minus } from "lucide-react";
export default function ProductDetail({ product, qty, setQty }) {
    return (
        <div className="w-full">

            <h1 className="text-2xl md:text-2xl lg:text-3xl font-semibold leading-tight">
                {product.name}
            </h1>

            <div className="flex items-center gap-3 mt-2">
                <span className={`text-sm font-medium ${product.stock > 0 ? "text-green-600" : "text-red-500"}`}>
                    {product.stock > 0 ? "In Stock" : "Out of Stock"}
                </span>
            </div>

            <p className="text-2xl md:text-3xl font-bold mt-4 text-primary">
                Rp {product.price.toLocaleString()}
            </p>

            {/* Description */}
            {product.description && (
                <p className="mt-4 text-gray-600 text-sm md:text-base leading-relaxed max-w-xl">
                {product.description}
                </p>
            )}

            <hr className="my-6 border-gray-200" />

            <div className="flex flex-col sm:flex-row items-stretch sm:items-center gap-4 mt-6">
                {/* Quantity */}
                <div className="flex h-12 w-full sm:w-fit items-stretch border border-gray-300 rounded-md overflow-hidden shadow-sm">
                    <button
                        onClick={() => setQty(Math.max(1, qty - 1))}
                        className="flex-1 sm:w-12 flex items-center justify-center hover:bg-gray-100 active:bg-primary active:text-white transition-all"
                    >
                        <Minus size={20} />
                    </button>

                    <div className="flex-1 sm:min-w-20 flex items-center justify-center text-lg font-bold border-x border-gray-300 bg-white">
                        {qty}
                    </div>

                    <button
                        onClick={() => setQty(qty + 1)}
                        className="flex-1 sm:w-12 flex items-center justify-center hover:bg-gray-100 active:bg-primary active:text-white transition-all"
                    >
                        <Plus size={20} />
                    </button>
                </div>

                {/* Button */}
                <div className="flex flex-1 gap-3">
                    <button className="min-w-40 max-w-60 h-12 bg-primary text-white px-6 rounded-md font-bold hover:bg-primary/90 shadow-md active:scale-95 transition-all text-sm md:text-base">
                        Buy Now
                    </button>

                    <button
                        className="h-12 w-12 flex items-center justify-center border border-gray-300 rounded-md hover:border-primary hover:text-primary transition-all group"
                        title="Add to Wishlist"
                    >
                        <Heart size={22} className="group-active:fill-primary transition-all" />
                    </button>
                </div>
            </div>

            <div className="w-full sm:max-w-100 border border-gray-300 rounded-xl mt-10 overflow-hidden shadow-sm">
                
                {/* Free Shipping */}
                <div className="flex items-center gap-4 p-4 md:p-5 hover:bg-gray-50 transition-colors">
                    <div className="p-2 bg-primary/10 rounded-lg text-primary shrink-0">
                        <Truck size={32} className="md:w-10 md:h-10" />
                    </div>
                    <div className="flex flex-col">
                        <h3 className="font-bold text-gray-800 text-sm md:text-base leading-none mb-1">Free Shipping</h3>
                        <p className="text-xs md:text-sm text-gray-500">Free delivery over Rp 200.000</p>
                    </div>
                </div>

                <div className="border-t border-gray-300"></div>

                {/* Easy Returns */}
                <div className="flex items-center gap-4 p-4 md:p-5 hover:bg-gray-50 transition-colors">
                    <div className="p-2 bg-primary/10 rounded-lg text-primary shrink-0">
                        <RefreshCcw size={32} className="md:w-10 md:h-10" />
                    </div>
                    <div className="flex flex-col">
                        <h3 className="font-bold text-gray-800 text-sm md:text-base leading-none mb-1">Easy Returns</h3>
                        <p className="text-xs md:text-sm text-gray-500">30-day return policy</p>
                    </div>
                </div>
            </div>

        </div>
    );
}