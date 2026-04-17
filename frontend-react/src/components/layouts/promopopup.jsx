import { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import { BadgePercent, Gift, Sparkles, X } from "lucide-react";

const PROMO_POPUP_STORAGE_KEY = "rere-promopopup-dismissed";

export default function PromoPopup() {
  const [isMounted, setIsMounted] = useState(false);
  const [isVisible, setIsVisible] = useState(false);

  useEffect(() => {
    const isDismissed = window.localStorage.getItem(PROMO_POPUP_STORAGE_KEY);
    if (isDismissed === "true") return;

    const mountTimer = window.setTimeout(() => {
      setIsMounted(true);
      window.setTimeout(() => setIsVisible(true), 30);
    }, 1800);

    return () => window.clearTimeout(mountTimer);
  }, []);

  const handleClose = () => {
    window.localStorage.setItem(PROMO_POPUP_STORAGE_KEY, "true");
    setIsVisible(false);
    window.setTimeout(() => setIsMounted(false), 220);
  };

  if (!isMounted) return null;

  return (
    <div
      className={`fixed inset-0 z-70 flex items-center justify-center bg-black/45 px-4 backdrop-blur-sm transition duration-200 ${
        isVisible ? "opacity-100" : "pointer-events-none opacity-0"
      }`}
    >
      <div
        className={`relative w-full max-w-md overflow-hidden rounded-[28px] border border-white/60 bg-[linear-gradient(160deg,#fff7ef_0%,#ffffff_38%,#fff0e0_100%)] shadow-[0_24px_90px_rgba(0,0,0,0.22)] transition duration-300 ${
          isVisible ? "translate-y-0 scale-100" : "translate-y-4 scale-95"
        }`}
      >
        <div className="absolute inset-x-0 top-0 h-32 bg-[radial-gradient(circle_at_top,rgba(133,9,9,0.18),transparent_68%)]" />

        <button
          type="button"
          onClick={handleClose}
          className="absolute right-4 top-4 z-10 inline-flex h-9 w-9 items-center justify-center rounded-full border border-black/5 bg-white/75 text-gray-500 transition hover:bg-white hover:text-gray-900"
          aria-label="Tutup popup promo"
        >
          <X size={16} />
        </button>

        <div className="relative p-6 sm:p-7">
          <div className="mb-4 inline-flex items-center gap-2 rounded-full bg-primary/8 px-3 py-1.5 text-xs font-semibold uppercase tracking-[0.18em] text-primary">
            <Sparkles size={14} />
            Promo Spesial
          </div>

          <div className="mb-5 flex items-start gap-4">
            <div className="flex h-14 w-14 shrink-0 items-center justify-center rounded-2xl bg-[linear-gradient(135deg,#850909,#d63838)] text-white shadow-lg shadow-primary/20">
              <Gift size={24} />
            </div>

            <div>
              <h2 className="text-2xl font-bold leading-tight text-gray-900">
                Checkout hari ini, dapat voucher ongkir + diskon ekstra
              </h2>
              <p className="mt-2 text-sm leading-relaxed text-gray-600">
                Cocok buat dorong pembelian tanpa bikin halaman terasa terlalu ramai. Popup ini cuma tampil sekali
                sampai user menutupnya.
              </p>
            </div>
          </div>

          <div className="mb-5 rounded-3xl bg-[linear-gradient(135deg,#850909_0%,#a80f0f_100%)] p-4 text-white shadow-lg shadow-primary/20">
            <div className="mb-2 flex items-center gap-2 text-sm font-semibold text-white/85">
              <BadgePercent size={16} />
              Kode promo hari ini
            </div>
            <div className="text-3xl font-black tracking-[0.2em] text-[#ffe1a8]">REREHEMAT</div>
            <p className="mt-2 text-sm text-white/80">Pakai saat checkout untuk dapat promo spesial produk pilihan.</p>
          </div>

          <div className="flex flex-col gap-3 sm:flex-row">
            <Link
              to="/search"
              onClick={handleClose}
              className="inline-flex flex-1 items-center justify-center rounded-full bg-primary px-5 py-3 text-sm font-semibold text-white transition hover:-translate-y-0.5 hover:bg-[#6f0707]"
            >
              Belanja Sekarang
            </Link>
            <button
              type="button"
              onClick={handleClose}
              className="inline-flex items-center justify-center rounded-full border border-gray-200 bg-white px-5 py-3 text-sm font-semibold text-gray-700 transition hover:border-gray-300 hover:bg-gray-50"
            >
              Nanti Saja
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
