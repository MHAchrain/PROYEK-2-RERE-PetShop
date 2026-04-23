export default function HeroSlide({ text, image }) {
  return (
    <div
      className="relative min-w-full h-full overflow-hidden bg-cover bg-center"
      style={{ backgroundImage: `url(${image})` }}
    >
      <div className="absolute inset-0 bg-[linear-gradient(110deg,rgba(17,24,39,0.92)_0%,rgba(17,24,39,0.7)_40%,rgba(17,24,39,0.24)_100%)]" />
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_top_right,rgba(251,191,36,0.28),transparent_28%)]" />

      <div className="relative z-10 flex h-full items-end sm:items-center">
        <div className="w-full px-4 py-18 sm:px-6 sm:py-10 md:px-10 lg:px-12">
          <div className="max-w-xl rounded-[24px] border border-white/15 bg-white/10 p-4 text-white shadow-xl backdrop-blur-sm sm:max-w-2xl sm:rounded-[28px] sm:p-6 lg:p-7">
            <p className="text-[11px] font-semibold uppercase tracking-[0.18em] text-white/70 sm:text-xs">Promo pilihan</p>
            <h2 className="mt-2 text-xl font-bold leading-tight sm:mt-3 sm:text-3xl lg:text-4xl">{text}</h2>
            <p className="mt-2 max-w-xl text-xs leading-relaxed text-white/80 sm:mt-3 sm:text-sm md:text-base">
              Temukan makanan, aksesoris, dan layanan terbaik untuk anabul dalam satu tempat dengan pengalaman belanja yang lebih rapi.
            </p>

            <div className="mt-4 flex flex-wrap gap-2 text-[11px] font-medium text-white/90 sm:mt-5 sm:text-xs">
              <span className="rounded-full border border-white/15 bg-white/10 px-2.5 py-1.5 sm:px-3 sm:py-2">Produk terkurasi</span>
              <span className="rounded-full border border-white/15 bg-white/10 px-2.5 py-1.5 sm:px-3 sm:py-2">Grooming tersedia</span>
              <span className="rounded-full border border-white/15 bg-white/10 px-2.5 py-1.5 sm:px-3 sm:py-2">Belanja lebih mudah</span>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
