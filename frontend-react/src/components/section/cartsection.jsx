import { useEffect, useState } from "react";
import axios from "axios";
import { useAuth } from "../../context/authcontext";
import { useCart } from "../../context/cartcontext";
import CartCard from "../ui/cartcard";

export default function CartSection() {
    const { token } = useAuth();
    const { cart, setCart } = useCart();
    const total = cart?.items?.reduce((sum, item) => {
        const harga = Number(item.produk?.harga) || 0;
        const qty = Number(item.qty) || 0;
        return sum + harga * qty;
    }, 0);

    useEffect(() => {
        if (!token) return;
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
            }
        };

        fetchCart();
    }, [token]);

    if (!cart || !cart.items || cart.items.length === 0) {
    return (
        <div className="container mx-auto py-8">
            <h2 className="text-2xl font-bold mb-6">Keranjang Belanja</h2>
            <p className="text-gray-600">Keranjang belanja Anda kosong.</p>
        </div>
        );
    }

    return (
        <div className="container mx-auto py-8">
            <h2 className="text-2xl font-bold mb-6">Keranjang Belanja</h2>

            <div className="space-y-4">
                {cart.items.map((item) => (
                    <CartCard key={item.id_item} item={item} />
                ))}
            </div>

            <div className="mt-6 text-right">
                <h3 className="text-xl font-bold">
                Total: Rp {total.toLocaleString("id-ID")}
                </h3>
            </div>
        </div>
    )
}   