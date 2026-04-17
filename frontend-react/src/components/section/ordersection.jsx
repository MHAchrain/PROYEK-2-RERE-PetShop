import React from "react";
import OrderCard from "../ui/ordercard";

export default function OrderSection({ orders = [], isLoading }) {
    if (isLoading) {
        return (
        <div className="space-y-6 animate-pulse">
            {[...Array(3)].map((_, i) => (
            <div key={i} className="h-48 bg-gray-100 rounded-2xl w-full" />
            ))}
        </div>
        );
    }

    if (orders.length === 0) {
        return (
        <div className="flex flex-col items-center justify-center py-20 text-center">
            <div className="text-5xl mb-4">📦</div>
            <h3 className="text-xl font-bold text-gray-800">Belum ada pesanan</h3>
            <p className="text-gray-500">Semua pesanan Anda akan muncul di sini.</p>
        </div>
        );
    }

    return (
        <div className="w-full animate-in fade-in duration-500">
            {orders.map((order) => (
                <OrderCard key={order.id_pesanan} order={order} />
            ))}
        </div>
    );
}