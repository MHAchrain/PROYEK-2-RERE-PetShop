import { PackageCheck } from "lucide-react";
import OrderCard from "../ui/ordercard";

export default function OrderSection({ orders = [], isLoading, activeTab = "semua" }) {
  if (isLoading) {
    return (
      <div className="space-y-5 animate-pulse">
        {[...Array(3)].map((_, i) => (
          <div key={i} className="h-64 w-full rounded-[28px] bg-gray-100" />
        ))}
      </div>
    );
  }

  if (orders.length === 0) {
    return (
      <div className="flex flex-col items-center justify-center rounded-[28px] border border-dashed border-gray-200 bg-gray-50/70 px-6 py-16 text-center">
        <div className="mb-5 flex h-18 w-18 items-center justify-center rounded-full bg-primary/10 text-primary">
          <PackageCheck size={34} />
        </div>
        <h3 className="text-xl font-bold text-gray-800">Belum ada pesanan</h3>
        <p className="mt-2 max-w-md text-sm leading-relaxed text-gray-500">
          {activeTab === "semua"
            ? "Semua pesanan yang berhasil dibuat akan muncul di sini."
            : `Belum ada pesanan pada tab ${activeTab}.`}
        </p>
      </div>
    );
  }

  return (
    <div className="w-full space-y-4 animate-in fade-in duration-500 md:space-y-5">
      {orders.map((order) => (
        <OrderCard key={order.id_pesanan} order={order} />
      ))}
    </div>
  );
}
