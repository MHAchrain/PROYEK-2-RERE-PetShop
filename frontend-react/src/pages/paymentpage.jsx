import { useEffect, useMemo, useState } from "react";
import { Link, useLocation, useNavigate, useParams } from "react-router-dom";
import {
  ArrowLeft,
  BadgeCheck,
  Clock3,
  CreditCard,
  Landmark,
  MapPin,
  ReceiptText,
  Smartphone,
} from "lucide-react";
import toast from "react-hot-toast";
import Skeleton from "../components/ui/skeleton";
import { getOrderDetail } from "../services/orderservice";
import { createPayment, getPaymentByOrderId } from "../services/paymentservice";
import { getStorageUrl } from "../utils/appconfig";

const paymentMethods = [
  {
    id: "transfer_bca",
    label: "Transfer Bank BCA",
    value: "Transfer Bank BCA",
    description: "Verifikasi cepat untuk pembayaran transfer bank.",
    icon: Landmark,
    accent: "from-blue-50 to-sky-50",
  },
  {
    id: "transfer_bri",
    label: "Transfer Bank BRI",
    value: "Transfer Bank BRI",
    description: "Cocok untuk pembayaran via ATM atau mobile banking.",
    icon: CreditCard,
    accent: "from-orange-50 to-amber-50",
  },
  {
    id: "ewallet_ovo",
    label: "E-Wallet OVO",
    value: "E-Wallet OVO",
    description: "Praktis untuk pembayaran digital tanpa input rekening.",
    icon: Smartphone,
    accent: "from-rose-50 to-pink-50",
  },
];

const paymentStatusMap = {
  pending: {
    label: "Menunggu Verifikasi",
    className: "bg-amber-100 text-amber-700",
    helper: "Pembayaran sudah tercatat dan sedang menunggu konfirmasi admin.",
  },
  paid: {
    label: "Sudah Dibayar",
    className: "bg-emerald-100 text-emerald-700",
    helper: "Pembayaran telah dikonfirmasi. Pesanan akan segera diproses.",
  },
  failed: {
    label: "Pembayaran Gagal",
    className: "bg-rose-100 text-rose-700",
    helper: "Silakan coba metode lain atau ulangi pembayaran.",
  },
};

export default function PaymentPage() {
  const { id } = useParams();
  const { state } = useLocation();
  const navigate = useNavigate();
  const [order, setOrder] = useState(state?.order || null);
  const [payment, setPayment] = useState(null);
  const [selectedMethod, setSelectedMethod] = useState(paymentMethods[0].value);
  const [isLoading, setIsLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    const loadData = async () => {
      try {
        setIsLoading(true);

        const orderPromise = state?.order ? Promise.resolve(state.order) : getOrderDetail(id);
        const [orderData, paymentData] = await Promise.all([
          orderPromise,
          getPaymentByOrderId(id).catch((error) => {
            if (error.response?.status === 404) {
              return null;
            }

            throw error;
          }),
        ]);

        setOrder(orderData);
        setPayment(paymentData);

        if (paymentData?.metode_bayar) {
          setSelectedMethod(paymentData.metode_bayar);
        }
      } catch (error) {
        console.error(error);
        toast.error("Halaman pembayaran tidak bisa dibuka.");
        navigate("/pesanan");
      } finally {
        setIsLoading(false);
      }
    };

    loadData();
  }, [id, navigate, state?.order]);

  const totalItems = useMemo(
    () => order?.details?.reduce((sum, item) => sum + (Number(item.qty) || 0), 0) || 0,
    [order]
  );

  const activePaymentStatus = payment?.status_bayar || "pending";
  const paymentStatus = paymentStatusMap[activePaymentStatus] || {
    label: activePaymentStatus || "Belum Dibuat",
    className: "bg-gray-100 text-gray-700",
    helper: "Silakan pilih metode pembayaran untuk melanjutkan pesanan.",
  };

  const handleCreatePayment = async () => {
    if (!order?.id_pesanan) return;

    try {
      setIsSubmitting(true);

      const response = await createPayment({
        id_pesanan: order.id_pesanan,
        metode_bayar: selectedMethod,
        ref_gateway: `RERE-${order.id_pesanan}-${Date.now()}`,
      });

      setPayment(response.data);
      toast.success("Pembayaran berhasil dibuat.");
    } catch (error) {
      const message = error.response?.data?.message || "Gagal membuat pembayaran.";

      if (error.response?.status === 400) {
        try {
          const existingPayment = await getPaymentByOrderId(order.id_pesanan);
          setPayment(existingPayment);
        } catch (fetchError) {
          console.error(fetchError);
        }
      }

      toast.error(message);
    } finally {
      setIsSubmitting(false);
    }
  };

  if (isLoading) {
    return (
      <div className="min-h-screen px-4 py-8 md:px-8 md:py-10 lg:px-16 xl:px-20">
        <div className="mx-auto max-w-7xl space-y-6">
          <Skeleton className="h-10 w-48 rounded-2xl bg-gray-200" />
          <Skeleton className="h-52 w-full rounded-[30px] bg-gray-100" />
          <div className="grid gap-6 xl:grid-cols-[1.2fr_0.8fr]">
            <Skeleton className="h-128 w-full rounded-[30px] bg-gray-100" />
            <Skeleton className="h-128 w-full rounded-[30px] bg-gray-100" />
          </div>
        </div>
      </div>
    );
  }

  if (!order) return null;

  return (
    <div className="min-h-screen px-4 py-8 md:px-8 md:py-10 lg:px-16 xl:px-20">
      <div className="mx-auto max-w-7xl space-y-6">
        <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
          <Link
            to="/cart"
            className="inline-flex items-center gap-2 rounded-2xl border border-gray-200 bg-white px-4 py-3 text-sm font-bold text-gray-700 shadow-sm transition hover:border-primary hover:text-primary"
          >
            <ArrowLeft size={16} />
            Kembali ke Keranjang
          </Link>

          <div className="inline-flex w-full items-center justify-center gap-2 rounded-2xl border border-primary/15 bg-primary/5 px-4 py-3 text-sm font-semibold text-primary sm:w-auto">
            <BadgeCheck size={16} />
            Pesanan #{order.id_pesanan} berhasil dibuat
          </div>
        </div>

        <section className="overflow-hidden rounded-[30px] border border-gray-200 bg-[linear-gradient(135deg,#fff8f4_0%,#ffffff_55%,#fff6f2_100%)] shadow-sm">
          <div className="grid gap-6 px-5 py-6 md:px-6 lg:grid-cols-[1.1fr_0.9fr] lg:items-center">
            <div>
              <p className="text-xs font-semibold uppercase tracking-[0.2em] text-primary/70">Pembayaran Pesanan</p>
              <h1 className="mt-3 text-3xl font-black leading-tight text-gray-900 md:text-4xl">
                Satu langkah lagi sebelum pesanan diproses.
              </h1>
              <p className="mt-3 max-w-2xl text-sm leading-relaxed text-gray-600 md:text-base">
                Pilih metode pembayaran yang paling nyaman, cek kembali ringkasan belanja, lalu lanjutkan pembayaran untuk mengamankan stok produk kamu.
              </p>

              <div className="mt-6 grid gap-3 sm:grid-cols-3">
                <div className="rounded-2xl border border-white/80 bg-white/90 p-4 shadow-sm">
                  <p className="text-[11px] font-bold uppercase tracking-[0.16em] text-gray-400">Status Pesanan</p>
                  <p className="mt-2 text-base font-extrabold text-gray-900">{order.status_pesanan || "baru"}</p>
                </div>

                <div className="rounded-2xl border border-white/80 bg-white/90 p-4 shadow-sm">
                  <p className="text-[11px] font-bold uppercase tracking-[0.16em] text-gray-400">Jumlah Item</p>
                  <p className="mt-2 text-base font-extrabold text-gray-900">{totalItems} item</p>
                </div>

                <div className="rounded-2xl border border-white/80 bg-white/90 p-4 shadow-sm">
                  <p className="text-[11px] font-bold uppercase tracking-[0.16em] text-gray-400">Total Bayar</p>
                  <p className="mt-2 text-base font-extrabold text-primary">
                    Rp {Number(order.total || 0).toLocaleString("id-ID")}
                  </p>
                </div>
              </div>
            </div>

            <div className="rounded-[28px] border border-primary/10 bg-white/90 p-5 shadow-lg shadow-primary/5 backdrop-blur">
              <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary/70">Progress Checkout</p>
              <div className="mt-5 space-y-4">
                {[
                  { step: "1", title: "Pesanan dibuat", helper: "Keranjang berhasil diubah menjadi pesanan." },
                  { step: "2", title: "Pilih pembayaran", helper: "Tentukan metode yang ingin digunakan." },
                  { step: "3", title: "Verifikasi admin", helper: "Pesanan masuk antrean setelah pembayaran tercatat." },
                ].map((item, index) => (
                  <div key={item.step} className="flex items-start gap-4">
                    <div
                      className={`flex h-11 w-11 shrink-0 items-center justify-center rounded-2xl text-sm font-black ${
                        index < 2 ? "bg-primary text-white" : "bg-primary/10 text-primary"
                      }`}
                    >
                      {item.step}
                    </div>
                    <div>
                      <p className="font-bold text-gray-900">{item.title}</p>
                      <p className="mt-1 text-sm leading-relaxed text-gray-500">{item.helper}</p>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </section>

        <div className="grid gap-6 xl:grid-cols-[1.15fr_0.85fr]">
          <section className="rounded-[30px] border border-gray-200 bg-white p-5 shadow-sm md:p-6">
            <div className="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
              <div>
                <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary/70">Metode Pembayaran</p>
                <h2 className="mt-2 text-2xl font-bold text-gray-900">Pilih cara bayar</h2>
                <p className="mt-2 text-sm leading-relaxed text-gray-500">
                  Payment page ini dibuat tetap satu tema dengan halaman cart dan pesanan, jadi transisinya terasa lebih natural.
                </p>
              </div>

              {payment && (
                <div className={`inline-flex w-auto max-w-max shrink-0 self-start whitespace-nowrap rounded-full px-4 py-2 text-sm font-bold ${paymentStatus.className}`}>
                  {paymentStatus.label}
                </div>
              )}
            </div>

            <div className="mt-6 grid gap-4">
              {paymentMethods.map((method) => {
                const Icon = method.icon;
                const isSelected = selectedMethod === method.value;

                return (
                  <button
                    key={method.id}
                    type="button"
                    onClick={() => !payment && setSelectedMethod(method.value)}
                    className={`w-full rounded-[26px] border p-4 text-left transition-all md:p-5 ${
                      isSelected
                        ? "border-primary bg-primary/5 shadow-lg shadow-primary/10"
                        : "border-gray-200 bg-white hover:border-primary/30 hover:bg-gray-50"
                    } ${payment ? "cursor-default" : ""}`}
                  >
                    <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
                      <div className="flex items-start gap-4">
                        <div className={`flex h-14 w-14 items-center justify-center rounded-2xl bg-linear-to-br ${method.accent}`}>
                          <Icon size={24} className="text-primary" />
                        </div>

                        <div>
                          <p className="text-base font-extrabold text-gray-900">{method.label}</p>
                          <p className="mt-1 text-sm leading-relaxed text-gray-500">{method.description}</p>
                        </div>
                      </div>

                      <div
                        className={`inline-flex h-6 w-6 shrink-0 items-center justify-center rounded-full border-2 ${
                          isSelected ? "border-primary bg-primary" : "border-gray-300"
                        }`}
                      >
                        {isSelected && <div className="h-2.5 w-2.5 rounded-full bg-white" />}
                      </div>
                    </div>
                  </button>
                );
              })}
            </div>

            <div className="mt-6 rounded-[28px] border border-dashed border-primary/20 bg-primary/5 p-5">
              <p className="flex items-center gap-2 text-xs font-semibold uppercase tracking-[0.16em] text-primary/70">
                <Clock3 size={15} />
                Instruksi Singkat
              </p>
              <p className="mt-3 text-sm leading-relaxed text-gray-600">{paymentStatus.helper}</p>

              {!payment ? (
                <button
                  type="button"
                  onClick={handleCreatePayment}
                  disabled={isSubmitting}
                  className={`mt-5 inline-flex w-full items-center justify-center rounded-2xl px-5 py-4 text-sm font-bold text-white transition sm:w-auto ${
                    isSubmitting ? "cursor-not-allowed bg-primary/50" : "bg-primary hover:bg-primary-600"
                  }`}
                >
                  {isSubmitting ? "Membuat Pembayaran..." : "Bayar Sekarang"}
                </button>
              ) : (
                <div className="mt-5 flex flex-col gap-3 sm:flex-row">
                  <Link
                    to={`/pesanan/${order.id_pesanan}`}
                    className="inline-flex items-center justify-center rounded-2xl bg-primary px-5 py-4 text-sm font-bold text-white transition hover:bg-primary-600"
                  >
                    Lihat Detail Pesanan
                  </Link>
                  <Link
                    to="/pesanan"
                    className="inline-flex items-center justify-center rounded-2xl border border-gray-300 px-5 py-4 text-sm font-bold text-gray-700 transition hover:border-primary hover:text-primary"
                  >
                    Ke Riwayat Pesanan
                  </Link>
                </div>
              )}
            </div>
          </section>

          <div className="space-y-6">
            <section className="rounded-[30px] border border-gray-200 bg-white p-5 shadow-sm md:p-6">
              <div className="flex items-start justify-between gap-4">
                <div>
                  <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary/70">Ringkasan Pesanan</p>
                  <h2 className="mt-2 text-xl font-bold text-gray-900">Belanja kamu</h2>
                </div>

                <div className="rounded-2xl bg-gray-50 px-3 py-2 text-sm font-semibold text-gray-700">
                  #{order.id_pesanan}
                </div>
              </div>

              <div className="mt-5 space-y-4">
                {order.details?.map((detail) => {
                  const product = detail.produk;

                  return (
                    <div
                      key={detail.id_detail}
                      className="flex items-start gap-4 rounded-3xl border border-gray-200 bg-[linear-gradient(180deg,#ffffff_0%,#fffaf8_100%)] p-4"
                    >
                      <div className="flex h-20 w-20 shrink-0 items-center justify-center overflow-hidden rounded-2xl bg-gray-50">
                        {product?.foto ? (
                          <img
                            src={getStorageUrl(product.foto)}
                            alt={product?.nama_produk || "Produk"}
                            className="h-full w-full object-cover"
                          />
                        ) : (
                          <div className="px-2 text-center text-xs text-gray-400">Tidak ada foto</div>
                        )}
                      </div>

                      <div className="min-w-0 flex-1">
                        <p className="text-sm font-bold text-gray-900 sm:text-base">
                          {product?.nama_produk || "Produk tidak tersedia"}
                        </p>
                        <p className="mt-1 text-sm text-gray-500">
                          {detail.qty} x Rp {Number(detail.harga_satuan || 0).toLocaleString("id-ID")}
                        </p>
                        <p className="mt-2 text-sm font-extrabold text-primary">
                          Rp {Number(detail.subtotal || 0).toLocaleString("id-ID")}
                        </p>
                      </div>
                    </div>
                  );
                })}
              </div>

              <div className="mt-6 space-y-3 border-t border-gray-100 pt-5 text-sm">
                <div className="flex items-center justify-between text-gray-600">
                  <span>Subtotal</span>
                  <span>Rp {Number(order.total || 0).toLocaleString("id-ID")}</span>
                </div>
                <div className="flex items-center justify-between text-gray-600">
                  <span>Pengiriman</span>
                  <span>Free</span>
                </div>
                <div className="flex items-center justify-between text-lg font-extrabold text-gray-900">
                  <span>Total Bayar</span>
                  <span className="text-primary">Rp {Number(order.total || 0).toLocaleString("id-ID")}</span>
                </div>
              </div>
            </section>

            <section className="rounded-[30px] border border-gray-200 bg-white p-5 shadow-sm md:p-6">
              <h2 className="flex items-center gap-2 text-lg font-bold text-gray-900">
                <MapPin size={18} className="text-primary" />
                Alamat Pengiriman
              </h2>

              <div className="mt-4 rounded-3xl bg-gray-50 p-4">
                <p className="text-sm leading-relaxed text-gray-700">{order.alamat_kirim || "-"}</p>
                <p className="mt-3 text-sm font-semibold text-gray-900">{order.no_telp || "-"}</p>
              </div>
            </section>

            {payment && (
              <section className="rounded-[30px] border border-gray-200 bg-white p-5 shadow-sm md:p-6">
                <h2 className="flex items-center gap-2 text-lg font-bold text-gray-900">
                  <ReceiptText size={18} className="text-primary" />
                  Detail Pembayaran
                </h2>

                <div className="mt-4 space-y-3 text-sm text-gray-700">
                  <div className="flex items-center justify-between gap-4 rounded-2xl bg-gray-50 px-4 py-3">
                    <span>Metode</span>
                    <span className="text-right font-semibold text-gray-900">{payment.metode_bayar}</span>
                  </div>
                  <div className="flex items-center justify-between gap-4 rounded-2xl bg-gray-50 px-4 py-3">
                    <span>Status</span>
                    <span className={`rounded-full px-3 py-1 text-xs font-bold ${paymentStatus.className}`}>
                      {paymentStatus.label}
                    </span>
                  </div>
                  <div className="flex items-center justify-between gap-4 rounded-2xl bg-gray-50 px-4 py-3">
                    <span>Nomor Referensi</span>
                    <span className="text-right font-semibold text-gray-900">{payment.ref_gateway || "-"}</span>
                  </div>
                  <div className="flex items-center justify-between gap-4 rounded-2xl bg-gray-50 px-4 py-3">
                    <span>Jumlah Bayar</span>
                    <span className="text-right font-extrabold text-primary">
                      Rp {Number(payment.jumlah_bayar || 0).toLocaleString("id-ID")}
                    </span>
                  </div>
                </div>
              </section>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
