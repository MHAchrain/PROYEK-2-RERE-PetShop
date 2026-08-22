import { useEffect, useMemo, useState } from 'react';
import { Link, useNavigate, useParams } from 'react-router-dom';
import {
  ArrowLeft,
  CreditCard,
  ExternalLink,
  MapPin,
  Phone,
  Printer,
  ReceiptText,
  ShoppingBag,
  Truck,
} from 'lucide-react';
import toast from '../utils/toast.jsx';
import Skeleton from '../components/ui/skeleton';
import { cancelOrder, getOrderDetail } from '../services/orderservice';
import {
  createPayment,
  syncPaymentByOrderId,
} from '../services/paymentservice';
import { getStorageUrl } from '../utils/appconfig';
import logo from '../assets/logorere.png';
import noImage from '../assets/no-image.png';

const statusLabelMap = {
  baru: 'Pesanan Baru',
  menunggu_verifikasi: 'Menunggu Verifikasi',
  diproses: 'Sedang Diproses',
  dikirim: 'Sedang Dikirim',
  selesai: 'Pesanan Selesai',
  dibatalkan: 'Pesanan Dibatalkan',
  batal: 'Pesanan Dibatalkan',
};

const statusClassMap = {
  baru: 'bg-amber-100 text-amber-700',
  menunggu_verifikasi: 'bg-orange-100 text-orange-700',
  diproses: 'bg-sky-100 text-sky-700',
  dikirim: 'bg-indigo-100 text-indigo-700',
  selesai: 'bg-emerald-100 text-emerald-700',
  dibatalkan: 'bg-rose-100 text-rose-700',
  batal: 'bg-rose-100 text-rose-700',
};

const paymentStatusLabelMap = {
  pending: 'Menunggu Pembayaran',
  paid: 'Sudah Dibayar',
  failed: 'Pembayaran Gagal',
};

const paymentStatusClassMap = {
  pending: 'bg-amber-100 text-amber-700',
  paid: 'bg-emerald-100 text-emerald-700',
  failed: 'bg-rose-100 text-rose-700',
};

const shippingStatusLabelMap = {
  diproses: 'Sedang Diproses',
  dikirim: 'Sedang Dikirim',
  diterima: 'Sudah Diterima',
};

const shippingStatusClassMap = {
  diproses: 'bg-amber-100 text-amber-700',
  dikirim: 'bg-indigo-100 text-indigo-700',
  diterima: 'bg-emerald-100 text-emerald-700',
};

const formatCourierName = (courier) => {
  const normalizedCourier = String(courier || '')
    .trim()
    .toLowerCase();

  if (!normalizedCourier) return '-';
  if (normalizedCourier.includes('internal')) return 'Kurir Internal (Udin)';
  if (normalizedCourier.includes('jne')) return 'JNE Ekspress';
  if (
    normalizedCourier.includes('ojol') ||
    normalizedCourier.includes('gosend') ||
    normalizedCourier.includes('grab')
  ) {
    return 'Gosend/Grab';
  }
  if (normalizedCourier.includes('menunggu')) return 'Menunggu Kurir';

  return courier;
};

export default function OrderDetailPage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [order, setOrder] = useState(null);
  const [isLoading, setIsLoading] = useState(true);
  const [isCancelling, setIsCancelling] = useState(false);
  const [isOpeningPayment, setIsOpeningPayment] = useState(false);
  const [isCancelModalOpen, setIsCancelModalOpen] = useState(false);
  const [printedAt, setPrintedAt] = useState(() => new Date());

  useEffect(() => {
    const fetchOrder = async () => {
      try {
        setIsLoading(true);
        const data = await getOrderDetail(id);
        setOrder(data);
      } catch (error) {
        console.error(error);
        toast.error('Detail pesanan tidak ditemukan.');
        navigate('/pesanan');
      } finally {
        setIsLoading(false);
      }
    };

    fetchOrder();
  }, [id, navigate]);

  useEffect(() => {
    const syncPrintedAt = () => {
      setPrintedAt(new Date());
    };

    window.addEventListener('beforeprint', syncPrintedAt);

    return () => {
      window.removeEventListener('beforeprint', syncPrintedAt);
    };
  }, []);

  const formattedDate = useMemo(() => {
    if (!order?.tanggal_pesanan) return '-';

    return new Date(order.tanggal_pesanan).toLocaleString('id-ID', {
      day: '2-digit',
      month: 'long',
      year: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    });
  }, [order?.tanggal_pesanan]);

  const statusLabel =
    statusLabelMap[order?.status_pesanan] || order?.status_pesanan || '-';
  const statusClass =
    statusClassMap[order?.status_pesanan] || 'bg-gray-100 text-gray-700';
  const paymentStatusLabel =
    paymentStatusLabelMap[order?.pembayaran?.status_bayar] ||
    order?.pembayaran?.status_bayar ||
    '-';
  const paymentStatusClass =
    paymentStatusClassMap[order?.pembayaran?.status_bayar] ||
    'bg-gray-100 text-gray-700';
  const shippingStatusLabel =
    shippingStatusLabelMap[order?.pengiriman?.status_kirim] ||
    order?.pengiriman?.status_kirim ||
    '-';
  const shippingStatusClass =
    shippingStatusClassMap[order?.pengiriman?.status_kirim] ||
    'bg-gray-100 text-gray-700';
  const courierName = formatCourierName(order?.pengiriman?.kurir);
  const canCancel = ['baru', 'menunggu_verifikasi'].includes(
    order?.status_pesanan,
  );
  const printedAtLabel = printedAt.toLocaleString('id-ID', {
    day: '2-digit',
    month: 'long',
    year: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  });

  const handlePrint = () => {
    window.print();
  };

  const handleCancel = async () => {
    if (!order) return;

    try {
      setIsCancelling(true);
      const response = await cancelOrder(order.id_pesanan);
      setOrder((prev) =>
        prev
          ? {
              ...prev,
              status_pesanan: response?.data?.status_pesanan || 'batal',
              pembayaran: prev.pembayaran
                ? {
                    ...prev.pembayaran,
                    status_bayar:
                      response?.data?.status_bayar ||
                      prev.pembayaran.status_bayar,
                  }
                : prev.pembayaran,
            }
          : prev,
      );
      setIsCancelModalOpen(false);
      toast.success('Pesanan berhasil dibatalkan.');
    } catch (error) {
      toast.error(error.message || 'Gagal membatalkan pesanan.');
    } finally {
      setIsCancelling(false);
    }
  };

  const refreshOrder = async () => {
    const latestOrder = await getOrderDetail(id);
    setOrder(latestOrder);
    return latestOrder;
  };

  const syncPaymentState = async (result, fallbackStatus = null) => {
    if (!order?.id_pesanan) return;

    try {
      await syncPaymentByOrderId(order.id_pesanan, {
        payment_type: result?.payment_type,
        transaction_status: result?.transaction_status || fallbackStatus,
        fraud_status: result?.fraud_status,
        store: result?.store,
        va_numbers: result?.va_numbers,
      });

      await refreshOrder();
    } catch (error) {
      console.error(error);
    }
  };

  const handleOpenPaymentDetail = async () => {
    if (!order?.id_pesanan) return;

    try {
      setIsOpeningPayment(true);

      const response = await createPayment({
        id_pesanan: order.id_pesanan,
        metode_bayar: 'Midtrans',
      });

      const snapToken = response.snap_token;

      if (!snapToken) {
        throw new Error('Snap Token tidak ditemukan dalam response.');
      }

      if (!window.snap?.pay) {
        throw new Error('Library pembayaran Midtrans belum termuat.');
      }

      window.snap.pay(snapToken, {
        onSuccess: async function (result) {
          await syncPaymentState(result, 'settlement');
          toast.success('Pembayaran berhasil.');
        },
        onPending: async function (result) {
          await syncPaymentState(result, 'pending');
          toast.success(
            response.is_existing
              ? 'Detail pembayaran Midtrans berhasil dibuka.'
              : 'Metode pembayaran berhasil dipilih.',
          );
        },
        onError: async function (result) {
          await syncPaymentState(result, 'deny');
          toast.error('Pembayaran gagal.');
        },
        onClose: function () {
          toast.error('Kamu menutup jendela pembayaran.');
        },
      });
    } catch (error) {
      toast.error(
        error.response?.data?.message ||
          error.message ||
          'Gagal membuka detail pembayaran.',
      );
    } finally {
      setIsOpeningPayment(false);
    }
  };

  if (isLoading) {
    return (
      <div className="min-h-screen px-4 py-8 md:px-8 md:py-10 lg:px-16 xl:px-20">
        <div className="mx-auto max-w-7xl space-y-6">
          <Skeleton className="h-10 w-44 rounded-2xl bg-gray-200" />
          <Skeleton className="h-40 w-full rounded-[28px] bg-gray-100" />
          <Skeleton className="h-64 w-full rounded-[28px] bg-gray-100" />
        </div>
      </div>
    );
  }

  if (!order) return null;

  return (
    <div className="min-h-screen px-4 py-8 md:px-8 md:py-10 lg:px-16 xl:px-20 print:bg-white print:px-0 print:py-0">
      <div className="mx-auto max-w-7xl space-y-6 print:max-w-none print:space-y-4">
        <section className="hidden border-b border-gray-200 pb-5 print:block">
          <div className="flex items-start justify-between gap-4">
            <div className="flex items-center gap-4">
              <img
                src={logo}
                alt="Logo ReRe Petshop"
                className="h-14 w-auto object-contain"
              />
              <div>
                <p className="text-xs font-semibold uppercase tracking-[0.22em] text-primary/70">
                  Invoice Resmi
                </p>
                <h1 className="mt-1 text-2xl font-bold text-gray-900">
                  ReRe Petshop
                </h1>
                <p className="mt-1 text-sm text-gray-500">
                  Invoice pesanan pelanggan
                </p>
              </div>
            </div>

            <div className="text-right">
              <p className="text-xs font-semibold uppercase tracking-[0.16em] text-gray-400">
                Waktu Cetak
              </p>
              <p className="mt-1 text-sm font-semibold text-gray-800">
                {printedAtLabel}
              </p>
            </div>
          </div>
        </section>

        <div className="flex flex-col gap-4 print:hidden sm:flex-row sm:items-center sm:justify-between">
          <Link
            to="/pesanan"
            className="inline-flex items-center gap-2 rounded-2xl border border-gray-200 font-medium bg-white px-4 py-3 text-sm text-gray-700 shadow-sm transition hover:border-primary hover:text-primary">
            <ArrowLeft size={16} />
            Kembali ke Pesanan
          </Link>

          <div className="flex flex-col gap-3 sm:flex-row">
            <button
              type="button"
              onClick={handlePrint}
              className="inline-flex items-center justify-center gap-2 rounded-2xl font-medium border border-gray-300 bg-white px-4 py-3 text-sm text-gray-700 transition hover:border-primary hover:text-primary">
              <Printer size={16} />
              Print Invoice
            </button>

            <button
              type="button"
              onClick={() => setIsCancelModalOpen(true)}
              disabled={!canCancel || isCancelling}
              className={`inline-flex items-center justify-center rounded-2xl px-4 py-3 text-sm text-white transition ${
                canCancel && !isCancelling
                  ? 'bg-primary font-semibold hover:bg-primary-600'
                  : 'cursor-not-allowed bg-gray-300'
              }`}>
              {isCancelling ? 'Membatalkan...' : 'Batalkan Pesanan'}
            </button>
          </div>
        </div>

        <section className="overflow-hidden rounded-[28px] border border-gray-200 bg-white shadow-sm print:rounded-none print:border print:shadow-none">
          <div className="border-b border-gray-100 px-5 py-5 md:px-6">
            <div className="flex flex-col gap-4 lg:flex-row lg:items-start lg:justify-between">
              <div>
                <p className="text-sm font-semibold uppercase tracking-[0.16em] text-primary/70">
                  Invoice Pesanan
                </p>
                <h1 className="mt-2 text-2xl font-bold text-gray-900 md:text-3xl">
                  #{order.id_pesanan}
                </h1>
                <p className="mt-2 text-sm text-gray-500">
                  Dibuat pada {formattedDate}
                </p>
              </div>

              <div
                className={`inline-flex w-auto max-w-max shrink-0 self-start whitespace-nowrap rounded-full px-4 py-2 text-sm font-semibold ${statusClass}`}>
                {statusLabel}
              </div>
            </div>
          </div>

          <div className="grid gap-4 px-5 py-5 md:grid-cols-2 xl:grid-cols-4 md:px-6">
            <div className="rounded-2xl bg-gray-50 px-4 py-4">
              <p className="mb-2 flex items-center gap-2 text-[11px] font-bold uppercase tracking-[0.16em] text-gray-400">
                <ReceiptText size={14} />
                Total Belanja
              </p>
              <p className="text-lg font-extrabold text-gray-900">
                Rp {Number(order.total || 0).toLocaleString('id-ID')}
              </p>
            </div>

            <div className="rounded-2xl bg-gray-50 px-4 py-4">
              <p className="mb-2 flex items-center gap-2 text-[11px] font-bold uppercase tracking-[0.16em] text-gray-400">
                <ShoppingBag size={14} />
                Jumlah Produk
              </p>
              <p className="text-lg font-extrabold text-gray-900">
                {order.details?.length || 0} produk
              </p>
            </div>

            <div className="rounded-2xl bg-gray-50 px-4 py-4">
              <p className="mb-2 flex items-center gap-2 text-[11px] font-bold uppercase tracking-[0.16em] text-gray-400">
                <MapPin size={14} />
                Alamat Kirim
              </p>
              <p className="text-sm font-medium leading-relaxed text-gray-700">
                {order.alamat_kirim || '-'}
              </p>
            </div>

            <div className="rounded-2xl bg-gray-50 px-4 py-4">
              <p className="mb-2 flex items-center gap-2 text-[11px] font-bold uppercase tracking-[0.16em] text-gray-400">
                <Phone size={14} />
                Nomor Telepon
              </p>
              <p className="text-sm font-semibold text-gray-900">
                {order.no_telp || '-'}
              </p>
            </div>
          </div>
        </section>

        <section className="rounded-[28px] border border-gray-200 bg-white p-5 shadow-sm print:rounded-none print:border print:shadow-none md:p-6">
          <div className="mb-5 flex items-center justify-between gap-4">
            <div>
              <h2 className="text-xl font-bold text-gray-900">
                Produk Dalam Pesanan
              </h2>
              <p className="mt-1 text-sm text-gray-500">
                Rincian item yang masuk ke invoice ini.
              </p>
            </div>
            <div className="hidden rounded-2xl bg-gray-50 px-4 py-2 text-sm font-semibold text-gray-700 sm:block">
              {order.details?.reduce(
                (sum, item) => sum + (Number(item.qty) || 0),
                0,
              ) || 0}{' '}
              item
            </div>
          </div>

          <div className="space-y-4">
            {order.details?.map((detail) => {
              const product = detail.produk;
              const imageSrc =
                product?.foto_base64 ||
                (product?.foto ? getStorageUrl(product.foto) : noImage);

              return (
                <div
                  key={detail.id_detail}
                  className="flex flex-col gap-4 rounded-[28px] border border-gray-200 bg-[linear-gradient(180deg,#ffffff_0%,#fffaf8_100%)] p-4 sm:flex-row sm:items-center sm:justify-between">
                  <div className="flex items-start gap-4">
                    <div className="flex h-20 w-20 shrink-0 items-center justify-center overflow-hidden rounded-[28px] bg-gray-50 sm:h-24 sm:w-24">
                      <img
                        src={imageSrc}
                        alt={product?.nama_produk || 'Produk'}
                        loading="lazy"
                        onError={(e) => {
                          e.currentTarget.onerror = null;
                          e.currentTarget.src = noImage;
                        }}
                        className="h-full w-full object-cover"
                      />
                    </div>

                    <div className="min-w-0">
                      <h3 className="text-base font-bold leading-snug text-gray-900 sm:text-lg">
                        {product?.nama_produk || 'Produk tidak tersedia'}
                      </h3>
                      <p className="mt-1 text-sm text-gray-500">
                        Qty: {detail.qty}
                      </p>
                      <p className="mt-2 text-sm font-medium text-gray-700">
                        Harga satuan: Rp{' '}
                        {Number(detail.harga_satuan || 0).toLocaleString(
                          'id-ID',
                        )}
                      </p>
                    </div>
                  </div>

                  <div className="rounded-2xl bg-gray-50 px-4 py-3 text-right">
                    <p className="text-xs font-bold uppercase tracking-[0.16em] text-gray-400">
                      Subtotal
                    </p>
                    <p className="mt-1 text-lg font-extrabold text-primary">
                      Rp {Number(detail.subtotal || 0).toLocaleString('id-ID')}
                    </p>
                  </div>
                </div>
              );
            })}
          </div>
        </section>

        <section className="grid gap-4 md:grid-cols-2 print:grid-cols-2">
          <div className="rounded-[28px] border border-gray-200 bg-white p-5 shadow-sm print:rounded-none print:border print:shadow-none md:p-6">
            <h2 className="mb-4 flex items-center gap-2 text-lg font-bold text-gray-900">
              <CreditCard size={18} />
              Pembayaran
            </h2>
            {order.pembayaran ? (
              <div className="space-y-4 text-sm text-gray-700">
                <p>
                  Metode:{' '}
                  <span className="font-semibold">
                    {order.pembayaran.metode_bayar || '-'}
                  </span>
                </p>
                <div className="flex items-center gap-2">
                  <span>Status:</span>
                  <span
                    className={`rounded-full px-3 py-1 text-xs font-semibold ${paymentStatusClass}`}>
                    {paymentStatusLabel}
                  </span>
                </div>
                <p>
                  Jumlah bayar:{' '}
                  <span className="font-semibold">
                    Rp{' '}
                    {Number(order.pembayaran.jumlah_bayar || 0).toLocaleString(
                      'id-ID',
                    )}
                  </span>
                </p>
                {order.pembayaran.status_bayar !== 'paid' && (
                  <button
                    type="button"
                    onClick={handleOpenPaymentDetail}
                    disabled={isOpeningPayment}
                    className="inline-flex items-center justify-center gap-2 rounded-2xl bg-primary px-4 py-3 text-sm font-semibold text-white transition hover:bg-primary-600 disabled:opacity-50">
                    <ExternalLink size={16} />
                    {isOpeningPayment
                      ? 'Membuka...'
                      : 'Lihat Detail Pembayaran'}
                  </button>
                )}
              </div>
            ) : (
              <div className="space-y-4">
                <p className="text-sm text-gray-500">
                  Data pembayaran belum tersedia.
                </p>
                <Link
                  to={`/payment/${order.id_pesanan}`}
                  className="inline-flex items-center justify-center rounded-2xl bg-primary px-4 py-3 text-sm font-semibold text-white transition hover:bg-primary-600">
                  Lanjut ke Pembayaran
                </Link>
              </div>
            )}
          </div>

          <div className="rounded-[28px] border border-gray-200 bg-white p-5 shadow-sm print:rounded-none print:border print:shadow-none md:p-6">
            <h2 className="mb-4 flex items-center gap-2 text-lg font-bold text-gray-900">
              <Truck size={18} />
              Pengiriman
            </h2>
            {order.pengiriman ? (
              <div className="space-y-4 text-sm text-gray-700">
                <p>
                  Kurir: <span className="font-semibold">{courierName}</span>
                </p>
                <div className="flex items-center gap-2">
                  <span>Status:</span>
                  <span
                    className={`rounded-full px-3 py-1 text-xs font-semibold ${shippingStatusClass}`}>
                    {shippingStatusLabel}
                  </span>
                </div>
                <p>
                  Resi:{' '}
                  <span className="font-semibold">
                    {order.pengiriman.resi || '-'}
                  </span>
                </p>
              </div>
            ) : (
              <p className="text-sm text-gray-500">
                Data pengiriman belum tersedia.
              </p>
            )}
          </div>
        </section>
      </div>

      {isCancelModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/45 px-4 backdrop-blur-sm print:hidden">
          <div className="w-full max-w-md rounded-[28px] bg-white p-6 shadow-lg">
            <p className="text-sm font-semibold uppercase tracking-[0.16em] text-primary">
              Konfirmasi Pembatalan
            </p>
            <h2 className="mt-3 text-2xl font-bold text-gray-900">
              Batalkan pesanan ini?
            </h2>
            <p className="mt-3 text-sm leading-relaxed text-gray-600">
              Pesanan{' '}
              <span className="font-semibold text-gray-900">
                #{order.id_pesanan}
              </span>{' '}
              akan dibatalkan dan stok produk akan dikembalikan.
            </p>

            <div className="mt-6 flex flex-col-reverse gap-3 sm:flex-row sm:justify-end">
              <button
                type="button"
                onClick={() => setIsCancelModalOpen(false)}
                disabled={isCancelling}
                className="inline-flex items-center justify-center rounded-2xl border font-medium border-gray-200 px-4 py-3 text-sm text-gray-700 transition hover:border-gray-300 hover:bg-gray-50 disabled:cursor-not-allowed disabled:opacity-60">
                Kembali
              </button>

              <button
                type="button"
                onClick={handleCancel}
                disabled={isCancelling}
                className="inline-flex items-center justify-center rounded-2xl font-semibold bg-primary px-4 py-3 text-sm text-white transition hover:bg-primary-600 disabled:cursor-not-allowed disabled:bg-primary-300">
                {isCancelling ? 'Membatalkan...' : 'Ya, batalkan pesanan'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
}
