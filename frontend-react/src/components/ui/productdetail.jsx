import { Truck, RefreshCcw, Heart, Plus, Minus } from "lucide-react";
export default function ProductDetail({ product, qty, setQty }) {
    return (
        <div>

            <h1 className="text-2xl font-semibold">
                {product.name}
            </h1>

            <p className="text-green-600 mt-1">
                {product.stock > 0 ? "In Stock" : "Out of Stock"}
            </p>

            <p className=" text-2xl mt-2">
                Rp {product.price.toLocaleString()}
            </p>

            {/* Description */}
            {product.description && (
                <p className="mt-4 text-gray-600">
                {product.description}
                </p>
            )}

            <div className="flex items-center gap-4 mt-6">
                {/* Quantity */}
                <div className="flex h-12 items-stretch border border-gray-300 rounded overflow-hidden">

                    {/* Minus */}
                    <button
                        onClick={() => setQty(Math.max(1, qty - 1))}
                        className="px-3 flex items-center justify-center 
                                hover:bg-primary hover:text-white 
                                transition-all duration-200"
                    >
                        <Minus size={20} />
                    </button>

                    {/* Quantity */}
                    <div className="px-8 flex items-center justify-center text-lg font-semibold border-x border-gray-300">
                        {qty}
                    </div>

                    {/* Plus */}
                    <button
                        onClick={() => setQty(qty + 1)}
                        className="px-3 flex items-center justify-center 
                                hover:bg-primary hover:text-white 
                                transition-all duration-200"
                    >
                        <Plus size={20} />
                    </button>

                </div>

                {/* Button */}
                <button className="h-12 bg-primary text-white px-10 rounded hover:bg-primary-700 transition">
                    Buy Now
                </button>

                <button
                    className="h-12 w-12 border border-gray-300 rounded px-3 py-2 hover:bg-primary hover:text-white transition">
                    <Heart size={24} />
                </button>
            </div>

            <div className="w-fit border-2 border-gray-400 rounded mt-10">
                <div className="flex items-center gap-4 p-5">
                    <Truck size={40} />
                    <div className="flex flex-col">
                        <h3 className="font-bold">Free Shipping</h3>
                        <p>Free shipping on orders over Rp 200.000</p>
                    </div>
                </div>

                <div className="border-t-2 border-gray-400"></div>

                <div className="flex items-center gap-4 p-5">
                    <RefreshCcw size={40} />
                    <div className="flex flex-col">
                        <h3 className="font-bold">Easy Returns</h3>
                        <p>30-day return policy</p>
                    </div>
                </div>
            </div>

        </div>
    );
}