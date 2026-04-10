import { createContext, useContext, useState, useEffect } from "react";
import axios from "../api/axios";
import { useAuth } from "../context/authcontext";

const CartContext = createContext();

export function CartProvider({ children }) {
    const [cart, setCart] = useState(null);
    const { token } = useAuth();

    useEffect(() => {
        if (!token) return;

        const fetchCart = async () => {
            try {
                const res = await axios.get("/cart", {
                    headers: {
                        Authorization: `Bearer ${token}`,
                    },
                });

                setCart(res.data.data);
            } catch (err) {
                console.log(err);
            }
        };

        fetchCart();
    }, [token]);

    return (
        <CartContext.Provider value={{ cart, setCart }}>
            {children}
        </CartContext.Provider>
    );
}

export const useCart = () => useContext(CartContext);