import { useState } from "react";
import { ChevronDown, HelpCircle, MessageCircleQuestion, ShieldCheck, Truck } from "lucide-react";

export default function FaqSection() {
  const [openIndex, setOpenIndex] = useState(null);

  const faqs = [
    {
      q: "Bagaimana cara melacak pesanan saya?",
      a: "Anda dapat melihat status pesanan di halaman 'Pesanan Saya' secara real-time setelah checkout berhasil.",
      icon: <Truck size={18} />,
    },
    {
      q: "Apakah bisa melakukan pembatalan?",
      a: "Pembatalan bisa dilakukan selama pesanan belum diproses lebih lanjut oleh admin dan pembayaran belum dikonfirmasi.",
      icon: <ShieldCheck size={18} />,
    },
    {
      q: "Metode pembayaran apa saja yang tersedia?",
      a: "Kami menerima transfer bank, e-wallet seperti Gopay dan OVO, serta pembayaran melalui gerai seperti Alfamart dan Indomaret bila tersedia.",
      icon: <MessageCircleQuestion size={18} />,
    },
  ];

  return (
    <div className="space-y-6 animate-in fade-in duration-500">
      <div className="flex flex-col gap-4 rounded-[28px] border border-primary/10 bg-[linear-gradient(135deg,rgba(249,115,22,0.08)_0%,rgba(255,255,255,1)_55%,rgba(248,250,252,1)_100%)] p-5 sm:p-6 lg:flex-row lg:items-start lg:justify-between">
        <div>
          <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary/70">Pusat Bantuan</p>
          <h3 className="mt-2 text-2xl font-bold text-gray-900">Pertanyaan yang sering ditanyakan</h3>
          <p className="mt-2 max-w-2xl text-sm leading-relaxed text-gray-600">
            Temukan jawaban singkat untuk hal-hal yang paling sering ditanyakan seputar akun, pesanan, dan pembayaran.
          </p>
        </div>

        <div className="grid gap-3 sm:grid-cols-2 lg:w-[20rem] lg:grid-cols-1">
          <div className="rounded-2xl border border-white/80 bg-white/80 px-4 py-3 shadow-sm">
            <p className="text-xs font-semibold uppercase tracking-[0.16em] text-gray-400">Total FAQ</p>
            <p className="mt-2 text-sm font-semibold text-gray-800">{faqs.length} pertanyaan</p>
          </div>

          <div className="rounded-2xl border border-white/80 bg-white/80 px-4 py-3 shadow-sm">
            <p className="text-xs font-semibold uppercase tracking-[0.16em] text-gray-400">Status</p>
            <p className="mt-2 text-sm font-semibold text-gray-800">
              {openIndex === null ? "Belum ada yang dibuka" : `FAQ #${openIndex + 1} sedang dibuka`}
            </p>
          </div>
        </div>
      </div>

      <div className="grid gap-5 xl:grid-cols-[minmax(0,1fr)_18rem]">
        <div className="space-y-3 rounded-[28px] border border-gray-100 bg-gray-50/60 p-5 sm:p-6">
          {faqs.map((faq, index) => {
            const isOpen = openIndex === index;

            return (
              <div key={index} className="overflow-hidden rounded-[24px] border border-gray-100 bg-white shadow-sm">
                <button
                  type="button"
                  onClick={() => setOpenIndex(isOpen ? null : index)}
                  className="flex w-full items-center justify-between gap-4 px-4 py-4 text-left transition hover:bg-gray-50 sm:px-5"
                >
                  <div className="flex items-start gap-3">
                    <span className={`mt-0.5 rounded-xl p-2 ${isOpen ? "bg-primary text-white" : "bg-primary/10 text-primary"}`}>
                      {faq.icon}
                    </span>
                    <div>
                      <p className="text-sm font-semibold text-gray-800 sm:text-base">{faq.q}</p>
                      <p className="mt-1 text-xs text-gray-400">{isOpen ? "Klik untuk menutup jawaban" : "Klik untuk melihat jawaban"}</p>
                    </div>
                  </div>

                  <ChevronDown
                    className={`shrink-0 text-gray-400 transition-transform duration-300 ${isOpen ? "rotate-180 text-primary" : ""}`}
                    size={18}
                  />
                </button>

                {isOpen && (
                  <div className="border-t border-gray-100 bg-gray-50 px-4 py-4 text-sm leading-relaxed text-gray-600 animate-in slide-in-from-top-2 duration-300 sm:px-5">
                    {faq.a}
                  </div>
                )}
              </div>
            );
          })}
        </div>

        <div className="rounded-[28px] border border-gray-100 bg-white p-5 shadow-sm sm:p-6">
          <div className="flex items-center gap-3">
            <span className="rounded-2xl bg-primary/10 p-3 text-primary">
              <HelpCircle size={20} />
            </span>
            <div>
              <h4 className="text-lg font-bold text-gray-900">Butuh Bantuan?</h4>
              <p className="text-sm text-gray-500">Gunakan FAQ sebagai panduan cepat.</p>
            </div>
          </div>

          <div className="mt-6 rounded-2xl border border-dashed border-primary/20 bg-primary/5 px-4 py-4">
            <p className="text-xs font-semibold uppercase tracking-[0.16em] text-primary/70">Tips</p>
            <p className="mt-2 text-sm leading-relaxed text-gray-700">
              Jika masalah Anda belum terjawab di sini, cek detail pesanan atau informasi profil terlebih dahulu sebelum menghubungi admin.
            </p>
          </div>

          <div className="mt-4 space-y-3">
            <div className="rounded-2xl border border-gray-100 bg-gray-50/70 px-4 py-3">
              <p className="text-xs font-semibold uppercase tracking-[0.16em] text-gray-400">Topik Umum</p>
              <p className="mt-2 text-sm font-medium text-gray-700">Pesanan, pembayaran, pembatalan, dan status akun.</p>
            </div>

            <div className="rounded-2xl border border-gray-100 bg-gray-50/70 px-4 py-3">
              <p className="text-xs font-semibold uppercase tracking-[0.16em] text-gray-400">Akses Cepat</p>
              <p className="mt-2 text-sm font-medium text-gray-700">Buka tiap pertanyaan untuk melihat jawaban lengkapnya.</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
