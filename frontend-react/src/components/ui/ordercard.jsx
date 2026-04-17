import { Link } from "react-router-dom";
import { CalendarDays, MapPin, Phone, ReceiptText, ShoppingBag } from "lucide-react";
import { getStorageUrl } from "../../utils/appconfig";

const statusLabelMap = {
  baru: "Pesanan Baru",
  menunggu_verifikasi: "Menunggu Verifikasi",
  diproses: "Sedang Diproses",
  dikirim: "Sedang Dikirim",
  selesai: "Pesanan Selesai",
  dibatalkan: "Pesanan Dibatalkan",
  batal: "Pesanan Dibatalkan",
};

const statusClassMap = {
  baru: "bg-amber-100 text-amber-700",
  menunggu_verifikasi: "bg-orange-100 text-orange-700",
  diproses: "bg-sky-100 text-sky-700",
  dikirim: "bg-indigo-100 text-indigo-700",
  selesai: "bg-emerald-100 text-emerald-700",
  dibatalkan: "bg-rose-100 text-rose-700",
  batal: "bg-rose-100 text-rose-700",
};

export default function OrderCard({ order }) {
  const firstDetail = order.details?.[0] || null;
  const product = firstDetail?.produk || null;
  const totalItems = order.details?.reduce((sum, detail) => sum + (Number(detail.qty) || 0), 0) || 0;
  const additionalProducts = Math.max(0, (order.details?.length || 1) - 1);
  const formattedDate = order.tanggal_pesanan
    ? new Date(order.tanggal_pesanan).toLocaleDateString("id-ID", {
        day: "2-digit",
        month: "short",
        year: "numeric",
      })
    : "-";

  const statusLabel = statusLabelMap[order.status_pesanan] || order.status_pesanan;
  const statusClass = statusClassMap[order.status_pesanan] || "bg-gray-100 text-gray-700";

  return (
    <article className="overflow-hidden rounded-[28px] border border-gray-200 bg-[linear-gradient(180deg,#ffffff_0%,#fffaf8_100%)] shadow-sm transition hover:shadow-md">
      <div className="border-b border-gray-100 px-4 py-4 sm:px-5 md:px-6">
        <div className="flex flex-col gap-4 xl:flex-row xl:items-start xl:justify-between">
          <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
            <div className="min-w-0">
              <p className="mb-2 flex items-center gap-2 text-[11px] font-bold uppercase tracking-[0.16em] text-gray-400">
                <CalendarDays size={14} />
                Tanggal
              </p>
              <p className="text-sm font-semibold text-gray-800">{formattedDate}</p>
            </div>

            <div className="min-w-0">
              <p className="mb-2 flex items-center gap-2 text-[11px] font-bold uppercase tracking-[0.16em] text-gray-400">
                <ReceiptText size={14} />
                Total
              </p>
              <p className="text-sm font-semibold text-gray-800">Rp {Number(order.total || 0).toLocaleString("id-ID")}</p>
            </div>

            <div className="min-w-0">
              <p className="mb-2 flex items-center gap-2 text-[11px] font-bold uppercase tracking-[0.16em] text-gray-400">
                <MapPin size={14} />
                Alamat
              </p>
              <p className="line-clamp-2 text-sm font-medium leading-relaxed text-gray-600">
                {order.alamat_kirim || "Alamat belum tersedia"}
              </p>
            </div>

            <div className="min-w-0">
              <p className="mb-2 flex items-center gap-2 text-[11px] font-bold uppercase tracking-[0.16em] text-gray-400">
                <ShoppingBag size={14} />
                Order ID
              </p>
              <p className="text-sm font-extrabold text-gray-900">#{order.id_pesanan}</p>
            </div>
          </div>

          <div className={`inline-flex w-fit rounded-full px-4 py-2 text-sm font-bold ${statusClass}`}>
            {statusLabel}
          </div>
        </div>
      </div>

      <div className="px-4 py-5 sm:px-5 md:px-6">
        <div className="flex flex-col gap-5 lg:flex-row lg:items-center lg:justify-between">
          <div className="flex flex-col gap-4 sm:flex-row sm:items-start">
            <div className="flex h-24 w-24 shrink-0 items-center justify-center overflow-hidden rounded-2xl bg-gray-50 sm:h-28 sm:w-28">
              {product?.foto ? (
                <img
                  src={getStorageUrl(product.foto)}
                  alt={product?.nama_produk || "Produk"}
                  className="h-full w-full object-cover"
                />
              ) : (
                <div className="px-3 text-center text-xs text-gray-400">Tidak ada foto</div>
              )}
            </div>

            <div className="min-w-0 flex-1">
              <h3 className="text-base font-extrabold leading-snug text-gray-900 sm:text-lg">
                {product?.nama_produk || "Produk tidak tersedia"}
                {additionalProducts > 0 ? ` +${additionalProducts} produk lainnya` : ""}
              </h3>

              <div className="mt-2 flex flex-wrap gap-2 text-sm text-gray-500">
                <span className="rounded-full bg-gray-100 px-3 py-1 font-medium">{totalItems} item</span>
                <span className="rounded-full bg-gray-100 px-3 py-1 font-medium">
                  Produk utama: {firstDetail?.qty || 0}
                </span>
              </div>

              <p className="mt-3 flex items-center gap-2 text-sm font-medium text-gray-700">
                <Phone size={15} className="text-primary" />
                {order.no_telp || "-"}
              </p>
            </div>
          </div>

          <div className="flex flex-col gap-3 sm:flex-row lg:flex-col lg:min-w-48">
            {product?.id_produk && (
              <Link
                to={`/product/${product.id_produk}`}
                className="inline-flex items-center justify-center rounded-2xl border border-gray-300 px-4 py-3 text-sm font-bold text-gray-700 transition hover:border-primary hover:text-primary"
              >
                Lihat Produk
              </Link>
            )}

            <Link
              to={`/pesanan/${order.id_pesanan}`}
              className="inline-flex items-center justify-center rounded-2xl bg-primary px-4 py-3 text-sm font-bold text-white transition hover:bg-primary-600"
            >
              Detail Pesanan
            </Link>
          </div>
        </div>
      </div>
    </article>
  );
}
