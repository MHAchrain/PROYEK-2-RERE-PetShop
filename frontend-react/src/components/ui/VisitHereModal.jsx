import React, { useState } from 'react';

const NGROK_DOMAIN = 'https://tunefully-plummy-iraida.ngrok-free.dev';

export default function VisitHereModal() {
  const [isOpen, setIsOpen] = useState(
    () => !localStorage.getItem('rere_ngrok_ready'),
  );

  const handleBypass = () => {
    // Buka domain ngrok di tab baru untuk menanam cookie bypass
    window.open(NGROK_DOMAIN, '_blank');

    // Simpan status ready dan reload otomatis halaman utama
    setTimeout(() => {
      localStorage.setItem('rere_ngrok_ready', 'true');
      setIsOpen(false);
      window.location.reload();
    }, 3500);
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-[9999] flex items-center justify-center bg-black/60 backdrop-blur-sm p-4">
      <div className="bg-white w-full max-w-sm rounded-2xl p-6 text-center shadow-2xl border border-slate-100 animate-in fade-in zoom-in duration-200">
        <h3 className="text-lg font-bold text-slate-800 mb-1">
          Sinkronisasi Katalog Produk
        </h3>

        <p className="text-xs text-slate-500 leading-relaxed mb-5">
          Klik tombol di bawah sekali saja, lalu tekan tombol{' '}
          <b>"Visit Site"</b> di tab baru yang terbuka agar seluruh foto produk
          dapat dimuat.
        </p>

        <button
          type="button"
          onClick={handleBypass}
          className="w-full bg-[#7f1d1d] hover:bg-[#991b1b] text-white font-semibold py-2.5 px-4 rounded-xl text-sm transition-all shadow-md active:scale-95">
          Buka Akses Gambar
        </button>

        <button
          type="button"
          onClick={() => setIsOpen(false)}
          className="mt-3 text-xs text-slate-400 hover:text-slate-600 block w-full py-1">
          Nanti Saja
        </button>
      </div>
    </div>
  );
}
