import { useState, useEffect } from "react";
import Skeleton from "../components/ui/skeleton";
import OrderSection from "../components/section/ordersection";
import { getOrders } from "../services/orderservice";

export default function OrderPage() {
  const [activeTab, setActiveTab] = useState("semua");
  const [isLoading, setIsLoading] = useState(true);
  const [orders, setOrders] = useState([]);

  const tabs = [
    { id: "semua", label: "Semua" },
    { id: "dikirim", label: "Dikirim" },
    { id: "pembatalan", label: "Dibatalkan" },
    { id: "selesai", label: "Selesai" },
    { id: "ulasan", label: "Ulasan" },
  ];

  useEffect(() => {
    const fetchData = async () => {
      try {
        setIsLoading(true);
        const data = await getOrders();
        setOrders(data);
      } catch (err) {
        console.error("Error:", err);
      } finally {
        setIsLoading(false);
      }
    };

    fetchData();
  }, []);

  // --- LOGIKA FILTER TERPUSAT ---
  const renderContent = () => {
    const filteredOrders = orders.filter(order => {
      if (activeTab === "semua") return true;
      if (activeTab === "pembatalan") return order.status_pesanan === "dibatalkan"; 
      if (activeTab === "selesai") return order.status_pesanan === "selesai";
      if (activeTab === "dikirim") return order.status_pesanan === "dikirim";
      if (activeTab === "ulasan") return order.status_pesanan === "selesai"; 
      return true;
    });

    return <OrderSection orders={filteredOrders} isLoading={isLoading} />;
  };

  return (
    <div className="min-h-screen flex flex-col my-15 mx-20">
      <div className="flex items-center gap-5 mb-16">
        <div className="bg-primary w-5 h-10 rounded-sm"></div>
        {isLoading ? (
          <Skeleton className="w-32 h-8 bg-gray-200" />
        ) : (
          <p className="text-primary font-bold text-xl capitalize">Riwayat Pesanan</p>
        )}
      </div>

      {/* Navigasi Tab */}
      <div className="flex gap-4 mb-8 overflow-x-auto pb-2 scrollbar-hide">
        {tabs.map((tab) => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className={`px-6 py-2 text-sm font-bold transition-all rounded-md whitespace-nowrap ${
              activeTab === tab.id 
                ? "bg-primary text-white shadow-md shadow-primary/20" 
                : "text-gray-500 hover:bg-gray-100"
            }`}
          >
            {tab.label}
          </button>
        ))}
      </div>

      {/* Konten Utama - Cukup panggil renderContent */}
      <div className="bg-white rounded-2xl min-h-100">
        {renderContent()}
      </div>
    </div>
  );
}