import axios from "axios";
import { useEffect, useState } from "react";
import { useAuth } from "../../context/authcontext";
import { useCart } from "../../context/cartcontext";
import { useNavigate } from "react-router-dom";
import CartCard from "../ui/cartcard";
import Skeleton from "../ui/skeleton";

export default function CartSection() {
    const { token } = useAuth();
    const { cart, setCart } = useCart();
    const [isLoading, setIsLoading] = useState(true);
    const [isCheckingOut, setIsCheckingOut] = useState(false);
    const navigate = useNavigate();

    const total = cart?.items?.reduce((sum, item) => {
        const harga = Number(item.produk?.harga) || 0;
        const qty = Number(item.qty) || 0;
        return sum + harga * qty;
    }, 0);

    const removeItem = async (id) => {
        try {
            await axios.delete(`http://127.0.0.1:8000/api/cart/item/${id}`, {
                headers: {
                    Authorization: `Bearer ${token}`,
                },
            });

            setCart((prev) => ({
                ...prev,
                items: prev.items.filter((item) => item.id_item !== id),
            }));

        } catch (error) {
            console.log(error);
        }
    };

    const updateQty = (id, newQty) => {
        setCart((prev) => ({
            ...prev,
            items: prev.items.map((item) =>
                item.id_item === id
                    ? { ...item, qty: Math.max(1, newQty) }
                    : item
            ),
        }));
    };

    const handleCheckout = async () => {
        try {
            setIsCheckingOut(true);
            // Kirim request kosong ({}) karena data diambil dari DB Pelanggan di Laravel
            const res = await axios.post("http://127.0.0.1:8000/api/checkout", {}, {
                headers: { Authorization: `Bearer ${token}` }
            });

            if (res.data.success) {
                alert("Checkout Berhasil! Pesanan sedang diproses.");
                setCart({ items: [], total: 0 }); // Kosongkan cart di state
                navigate("/order-history"); // Pindah ke halaman riwayat
            }
        } catch (error) {
            // Kalau error 422 (alamat/no telp kosong di DB), munculin pesannya
            alert(error.response?.data?.message || "Checkout gagal.");
        } finally {
            setIsCheckingOut(false);
        }
    };

    useEffect(() => {
        if (!token) {
            setIsLoading(true);
            return;
        }

        const fetchCart = async () => {
            try {
                const res = await axios.get("http://127.0.0.1:8000/api/cart", {
                    headers: {
                        Authorization: `Bearer ${token}`,
                    },
                });
                setCart(res.data.data);
            } catch (error) {
                console.log(error);
            } finally {
                setTimeout(() => setIsLoading(false), 800);
            }
        };

        fetchCart();
    }, [token, setCart]);

    if (isLoading) {
        return (
            <div className="container mx-auto py-8 px-4">
                <Skeleton className="w-48 h-8 mb-6 bg-gray-200" />
                
                <div className="space-y-4">
                    
                    {[1, 2, 3].map((i) => (
                        <Skeleton key={i} className="w-full h-24 rounded-lg bg-gray-100" />
                    ))}
                </div>

                <div className="mt-6 flex justify-end">
                    <Skeleton className="w-64 h-10 bg-gray-200" />
                </div>
            </div>
        );
    }

    if (!cart || !cart.items || cart.items.length === 0) {
        return (
            <div className="container mx-auto">
                <h1 className="font-semibold text-center text-gray-600">Keranjang belanja Anda kosong.</h1>
            </div>
        );
    }

    return (
        <div className="w-full space-y-10">
            {/* Table Header & Items */}
            <div className="overflow-x-auto">
                <table className="w-full border-separate border-spacing-y-4">
                    <thead>
                        <tr className="text-left bg-white">
                            <th className="py-4 px-6 font-medium">Product</th>
                            <th className="py-4 px-6 font-medium">Price</th>
                            <th className="py-4 px-6 font-medium">Quantity</th>
                            <th className="py-4 px-6 font-medium text-right">Subtotal</th>
                        </tr>
                    </thead>
                    <tbody>
                        {cart?.items?.map((item) => (
                            <CartCard
                                key={item.id_item}
                                item={item}
                                removeItem={removeItem}
                                updateQty={updateQty}
                            />
                        ))}
                    </tbody>
                </table>
            </div>

            {/* Action Buttons */}
            <div className="flex justify-between items-center">
                <button 
                    onClick={() => navigate("/")}
                    className="group flex items-center gap-2 px-8 py-3 border-2 border-gray-200 rounded-lg text-gray-700 font-bold transition-all duration-300 hover:border-primary hover:text-primary hover:shadow-lg active:scale-95"
                    >
                    {/* Ikon Panah yang gerak pas di-hover */}
                    <span className="transition-transform duration-300 group-hover:-translate-x-1">
                        ←
                    </span>
                    Return To Shop
                </button>
            </div>

            {/* Bottom Section: Coupon & Cart Total */}
            <div className="flex flex-col lg:flex-row justify-between gap-10 items-start">
                {/* Coupon Form */}
                <div className="flex gap-4 w-full lg:w-auto">
                    <input 
                        type="text" 
                        placeholder="Coupon Code" 
                        className="px-4 py-3 border border-gray-400 rounded w-full lg:w-64 outline-none focus:border-black"
                    />
                    <button className="px-6 py-3 bg-[#8B100E] text-white rounded font-medium whitespace-nowrap">
                        Apply Coupon
                    </button>
                </div>

                {/* Cart Total Box */}
                <div className="border-2 border-gray-400 p-6 rounded-md w-full lg:w-96 space-y-4">
                    <h3 className="text-xl font-bold mb-4">Cart Total</h3>

                    <div className="flex justify-between border-b pb-3 border-gray-300">
                        <span>Subtotal:</span>
                        <span>Rp {total.toLocaleString("id-ID")}</span>
                    </div>
                    
                    <div className="flex justify-between border-b pb-3 border-gray-300">
                        <span>Shipping:</span>
                        <span className="text-gray-500">Free</span>
                    </div>
                    
                    <div className="flex justify-between font-bold text-lg pt-2">
                        <span>Total:</span>
                        <span>Rp {total.toLocaleString("id-ID")}</span>
                    </div>
                    
                    <button 
                        onClick={handleCheckout}
                        disabled={isCheckingOut}
                        className={`w-full py-4 bg-primary text-white rounded font-medium mt-4 transition-all ${
                            isCheckingOut ? "opacity-50 cursor-not-allowed" : "hover:bg-primary-600"
                        }`}>
                        {isCheckingOut ? "Sedang Diproses..." : "Buat Pesanan"}
                    </button>
                </div>
            </div>
        </div>
    )
}