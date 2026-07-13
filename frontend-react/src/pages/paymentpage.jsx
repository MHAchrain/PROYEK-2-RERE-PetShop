import { useEffect, useState } from 'react';
import { Link, useLocation, useNavigate, useParams } from 'react-router-dom';
import {
  ArrowLeft,
  BadgeCheck,
  Clock3,
  MapPin,
  ReceiptText,
} from 'lucide-react';
import toast from '../utils/toast.jsx';
import { getOrderDetail } from '../services/orderservice';
import {
  createPayment,
  getPaymentByOrderId,
  syncPaymentByOrderId,
} from '../services/paymentservice';
import { getStorageUrl } from '../utils/appconfig';

const paymentStatusMap = {
  pending: {
    label: 'Menunggu Pembayaran',
    className: 'bg-amber-100 text-amber-700',
    helper: 'Silakan selesaikan pembayaran melalui jendela Midtrans.',
  },
  paid: {
    label: 'Sudah Dibayar',
    className: 'bg-emerald-100 text-emerald-700',
    helper:
      'Pembayaran telah dikonfirmasi secara otomatis. Pesanan segera diproses.',
  },
  failed: {
    label: 'Pembayaran Gagal',
    className: 'bg-rose-100 text-rose-700',
    helper:
      'Transaksi gagal atau kedaluwarsa. Silakan coba buat pembayaran baru.',
  },
};

export default function PaymentPage() {
  const { id } = useParams();
  const { state } = useLocation();
  const navigate = useNavigate();
  const [order, setOrder] = useState(state?.order || null);
  const [payment, setPayment] = useState(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isSubmitting, setIsSubmitting] = useState(false);

  useEffect(() => {
    const loadData = async () => {
      try {
        setIsLoading(true);
        const orderPromise = state?.order
          ? Promise.resolve(state.order)
          : getOrderDetail(id);
        const [orderData, paymentData] = await Promise.all([
          orderPromise,
          getPaymentByOrderId(id).catch((error) =>
            error.response?.status === 404 ? null : Promise.reject(error),
          ),
        ]);

        setOrder(orderData);
        setPayment(paymentData);
      } catch (error) {
        console.error(error);
        toast.error('Halaman pembayaran tidak bisa dibuka.');
        navigate('/pesanan');
      } finally {
        setIsLoading(false);
      }
    };
    loadData();
  }, [id, navigate, state?.order]);

  useEffect(() => {
    if (!order?.id_pesanan) return;

    const shouldPoll =
      payment?.status_bayar === 'pending' ||
      payment?.metode_bayar === 'Menunggu Pilihan Metode';

    if (!shouldPoll) return;

    const intervalId = window.setInterval(async () => {
      try {
        const latestPayment = await getPaymentByOrderId(order.id_pesanan);
        setPayment((currentPayment) => {
          if (!latestPayment) return currentPayment;
          return { ...currentPayment, ...latestPayment };
        });
      } catch (error) {
        if (error.response?.status !== 404) {
          console.error(error);
        }
      }
    }, 3000);

    return () => window.clearInterval(intervalId);
  }, [order?.id_pesanan, payment?.metode_bayar, payment?.status_bayar]);

  const activePaymentStatus = payment?.status_bayar || null;
  const paymentStatus = paymentStatusMap[activePaymentStatus] || {
    label: 'Belum Dibuat',
    className: 'bg-gray-100 text-gray-700',
    helper:
      "Klik 'Bayar Sekarang' untuk memunculkan pilihan metode pembayaran.",
  };

  const activePaymentMethod =
    payment?.metode_bayar || (payment ? 'Menunggu Pilihan Metode' : '-');

  const syncPaymentState = async (result, fallbackStatus = null) => {
    if (!order?.id_pesanan) return null;

    try {
      const updatedPayment = await syncPaymentByOrderId(order.id_pesanan, {
        payment_type: result?.payment_type,
        transaction_status: result?.transaction_status || fallbackStatus,
        fraud_status: result?.fraud_status,
        store: result?.store,
        va_numbers: result?.va_numbers,
      });

      setPayment(updatedPayment);
      return updatedPayment;
    } catch (error) {
      console.error(error);
      return null;
    }
  };

  const handleCreatePayment = async () => {
    if (!order?.id_pesanan) return;

    try {
      setIsSubmitting(true);

      const response = await createPayment({
        id_pesanan: order.id_pesanan,
        metode_bayar: 'Midtrans',
      });

      const snapToken = response.snap_token;

      if (!snapToken) {
        throw new Error('Snap Token tidak ditemukan dalam response.');
      }

      const latestPayment = await getPaymentByOrderId(order.id_pesanan).catch(
        () => null,
      );

      if (latestPayment) {
        setPayment(latestPayment);
      }

      if (!window.snap?.pay) {
        throw new Error('Library pembayaran Midtrans belum termuat.');
      }

      window.snap.pay(snapToken, {
        onSuccess: async function (result) {
          await syncPaymentState(result, 'settlement');
          toast.success('Pembayaran Berhasil!');
          navigate(`/pesanan/${order.id_pesanan}`);
        },
        onPending: async function (result) {
          await syncPaymentState(result, 'pending');
          toast.success('Metode pembayaran berhasil dipilih.');
          navigate(`/pesanan/${order.id_pesanan}`);
        },
        onError: async function (result) {
          await syncPaymentState(result, 'deny');
          toast.error('Pembayaran Gagal.');
        },
        onClose: function () {
          toast.error('Kamu menutup jendela pembayaran.');
        },
      });
    } catch (error) {
      console.error(error);
      const message =
        error.response?.data?.message ||
        error.message ||
        'Gagal menghubungkan ke Midtrans.';
      toast.error(message);
    } finally {
      setIsSubmitting(false);
    }
  };

  if (isLoading)
    return (
      <div className="p-20 text-center text-primary font-bold">
        Memuat Data Pembayaran...
      </div>
    );
  if (!order) return null;

  return (
    <div className="min-h-screen px-4 py-8 md:px-8 md:py-10 lg:px-16 xl:px-20">
      <div className="mx-auto max-w-7xl space-y-6">
        <div className="flex flex-col gap-4 sm:flex-row sm:items-center sm:justify-between">
          <Link
            to="/cart"
            className="inline-flex items-center gap-2 rounded-2xl border font-medium border-gray-200 bg-white px-4 py-3 text-sm text-gray-700 hover:text-primary transition">
            <ArrowLeft size={16} /> Kembali
          </Link>
          <div className="inline-flex items-center gap-2 rounded-2xl border border-primary/15 bg-primary/5 px-4 py-3 text-sm font-semibold text-primary">
            <BadgeCheck size={16} /> Pesanan #{order.id_pesanan}
          </div>
        </div>

        <section className="overflow-hidden rounded-[28px] border border-gray-200 bg-white p-6 shadow-sm">
          <div className="grid gap-6 lg:grid-cols-2 lg:items-center">
            <div>
              <p className="text-xs font-bold uppercase tracking-widest text-primary/70">
                Pembayaran Aman
              </p>
              <h1 className="mt-3 text-3xl font-bold text-gray-900">
                Pembayaran Instan.
              </h1>
              <p className="mt-2 text-gray-600">
                Klik tombol untuk membayar via QRIS, E-Wallet, atau Transfer
                Bank secara otomatis.
              </p>
              <div className="mt-6 flex gap-4">
                <div className="rounded-2xl bg-gray-50 p-4 border border-gray-100">
                  <p className="text-[11px] font-bold text-gray-400 uppercase">
                    Total Tagihan
                  </p>
                  <p className="text-xl font-bold text-primary">
                    Rp {Number(order.total || 0).toLocaleString('id-ID')}
                  </p>
                </div>
              </div>
            </div>

            <div className="rounded-3xl bg-primary/5 p-6 border border-primary/10">
              <h3 className="font-bold text-gray-900 flex items-center gap-2">
                <Clock3 size={18} /> Status: {paymentStatus.label}
              </h3>
              <p className="mt-2 text-sm text-gray-600 leading-relaxed">
                {paymentStatus.helper}
              </p>
              {activePaymentStatus !== 'paid' && (
                <button
                  onClick={handleCreatePayment}
                  disabled={isSubmitting}
                  className="mt-6 w-full rounded-2xl bg-primary py-4 text-white font-semibold hover:bg-primary-600 transition disabled:opacity-50 shadow-lg shadow-primary/20">
                  {isSubmitting ? 'Memproses...' : 'BAYAR SEKARANG'}
                </button>
              )}
            </div>
          </div>
        </section>

        <div className="grid gap-6 xl:grid-cols-[1.15fr_0.85fr]">
          <section className="rounded-[28px] border border-gray-200 bg-white p-6 shadow-sm">
            <h2 className="text-xl font-bold text-gray-900 mb-5">
              Detail Belanja
            </h2>
            <div className="space-y-4">
              {order.details?.map((detail) => (
                <div
                  key={detail.id_detail}
                  className="flex items-center gap-4 p-4 rounded-2xl border border-gray-100 bg-gray-50/50">
                  <img
                    src={getStorageUrl(detail.produk?.foto)}
                    className="h-16 w-16 rounded-xl object-cover"
                    alt=""
                  />
                  <div className="flex-1">
                    <p className="font-bold text-gray-900">
                      {detail.produk?.nama_produk}
                    </p>
                    <p className="text-sm text-gray-500">
                      {detail.qty} x Rp{' '}
                      {Number(detail.harga_satuan).toLocaleString('id-ID')}
                    </p>
                  </div>
                  <p className="font-bold text-primary">
                    Rp {Number(detail.subtotal).toLocaleString('id-ID')}
                  </p>
                </div>
              ))}
            </div>
          </section>

          <section className="space-y-6">
            <div className="rounded-[28px] border border-gray-200 bg-white p-6 shadow-sm">
              <h2 className="flex items-center gap-2 text-lg font-bold text-gray-900">
                <MapPin size={18} className="text-primary" /> Alamat Pengiriman
              </h2>
              <p className="mt-4 text-sm text-gray-600 leading-relaxed">
                {order.alamat_kirim || 'Alamat tidak tersedia'}
              </p>
            </div>

            {payment && (
              <div className="rounded-[28px] border border-gray-200 bg-white p-6 shadow-sm">
                <h2 className="flex items-center gap-2 text-lg font-bold text-gray-900 mb-4">
                  <ReceiptText size={18} className="text-primary" /> Info
                  Transaksi
                </h2>
                <div className="space-y-2 text-sm">
                  <div className="flex justify-between py-2 border-b border-gray-50">
                    <span className="text-gray-500">Metode</span>
                    <span className="font-bold text-gray-900">
                      {activePaymentMethod}
                    </span>
                  </div>
                  <div className="flex justify-between py-2">
                    <span className="text-gray-500">Nomor Referensi</span>
                    <span className="font-mono text-xs text-gray-400">
                      {payment.ref_gateway}
                    </span>
                  </div>
                </div>
              </div>
            )}
          </section>
        </div>
      </div>
    </div>
  );
}
