import { useEffect, useMemo, useState } from "react";
import Skeleton from "../components/ui/skeleton";
import OrderSection from "../components/section/ordersection";
import { getOrders } from "../services/orderservice";

export default function OrderPage() {
  const [activeTab, setActiveTab] = useState("semua");
  const [isLoading, setIsLoading] = useState(true);
  const [orders, setOrders] = useState([]);

  const tabs = [
    { id: "semua", label: "Semua" },
    { id: "baru", label: "Baru" },
    { id: "diproses", label: "Diproses" },
    { id: "dikirim", label: "Dikirim" },
    { id: "selesai", label: "Selesai" },
    { id: "dibatalkan", label: "Dibatalkan" },
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

  const filteredOrders = useMemo(() => {
    return orders.filter((order) => {
      if (activeTab === "semua") return true;
      if (activeTab === "dibatalkan") {
        return ["dibatalkan", "batal"].includes(order.status_pesanan);
      }

      return order.status_pesanan === activeTab;
    });
  }, [activeTab, orders]);

  return (
    <div className="min-h-screen px-4 py-8 md:px-8 md:py-10 lg:px-16 xl:px-20">
      <div className="mx-auto w-full max-w-7xl space-y-6 md:space-y-8">
        <div className="flex flex-col gap-3 sm:flex-row sm:items-end sm:justify-between">
          <div className="space-y-3">
            <div className="flex items-center gap-4">
              <div className="h-10 w-4 rounded-sm bg-primary sm:w-5"></div>
              {isLoading ? (
                <Skeleton className="h-7 w-40 bg-gray-200" />
              ) : (
                <div>
                  <p className="text-xl font-bold capitalize text-primary sm:text-2xl">Riwayat Pesanan</p>
                </div>
              )}
            </div>
            <p className="max-w-2xl text-sm leading-relaxed text-gray-500 sm:text-base">
              Pantau pesanan terbaru, cek status pengiriman, dan lihat kembali produk yang pernah kamu beli.
            </p>
          </div>

          <div className="rounded-2xl border border-gray-200 bg-white px-4 py-3 text-sm text-gray-600 shadow-sm">
            <span className="font-semibold text-gray-900">{orders.length}</span> pesanan tercatat
          </div>
        </div>

        <div className="rounded-[28px] border border-gray-200 bg-white p-3 shadow-sm sm:p-4">
          <div className="mb-3 px-2">
            <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary/70">Navigasi Pesanan</p>
            <p className="mt-1 text-sm text-gray-500">Pilih status untuk memfilter riwayat pesanan Anda.</p>
          </div>

          <div className="grid grid-cols-2 gap-2 sm:grid-cols-3 lg:grid-cols-6">
            {tabs.map((tab) => (
              <button
                key={tab.id}
                type="button"
                onClick={() => setActiveTab(tab.id)}
                className={`w-full rounded-2xl px-4 py-3 text-center text-sm font-bold transition-all ${
                  activeTab === tab.id
                    ? "bg-primary text-white shadow-lg shadow-primary/20"
                    : "bg-gray-50 text-gray-500 hover:bg-gray-100 hover:text-gray-800"
                }`}
              >
                <span className="block leading-tight">{tab.label}</span>
              </button>
            ))}
          </div>
        </div>

        <div className="rounded-[30px] border border-gray-200 bg-white p-4 shadow-sm sm:p-5 md:p-6">
          <OrderSection orders={filteredOrders} isLoading={isLoading} activeTab={activeTab} />
        </div>
      </div>
    </div>
  );
}
