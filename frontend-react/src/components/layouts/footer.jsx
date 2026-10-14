import { Clock3, Instagram, MapPin, Phone, ShieldCheck, Truck, Mail } from "lucide-react";
import { Link } from "react-router-dom";

const navigationLinks = [
  { label: "Beranda", to: "/" },
  { label: "Kategori", to: "/category/1" },
  { label: "Grooming", to: "/grooming" },
  { label: "Kontak", to: "/contact" },
];

const accountLinks = [
  { label: "Akun Saya", to: "/atur-akun" },
  { label: "Favorit", to: "/wishlist" },
  { label: "Keranjang", to: "/cart" },
  { label: "Pesanan", to: "/pesanan" },
];

const serviceHighlights = [
  {
    icon: Truck,
    title: "Pengiriman Cepat",
    description: "Pesanan harian diproses lebih cepat untuk area sekitar toko.",
  },
  {
    icon: ShieldCheck,
    title: "Produk Terpilih",
    description: "Makanan, vitamin, dan kebutuhan grooming dipilih untuk hewan kesayangan.",
  },
  {
    icon: Clock3,
    title: "Layanan Ramah",
    description: "Bisa tanya stok dan perawatan sebelum belanja lewat kontak toko.",
  },
];

export default function Footer() {
  return (
    <footer className="bg-neutral-950 text-neutral-300">
      <div className="mx-auto max-w-7xl px-6 py-12 md:px-10">
        <div className="grid gap-10 border-b border-white/10 pb-10 lg:grid-cols-[1.4fr_1fr_1fr]">
          <div className="space-y-5">
            <div>
              <p className="text-sm font-semibold uppercase tracking-[0.24em] text-primary">
                ReRe Petshop
              </p>
              <h2 className="mt-3 max-w-md text-2xl font-bold text-white">
                Kebutuhan anabul, pakan, dan grooming dalam satu tempat.
              </h2>
            </div>

            <p className="max-w-xl text-sm leading-7 text-neutral-400">
              ReRe Petshop hadir untuk bantu pemilik hewan belanja lebih mudah, cepat,
              dan nyaman, mulai dari makanan hingga layanan grooming.
            </p>

            <div className="grid gap-3 sm:grid-cols-3">
              {serviceHighlights.map(({ icon: Icon, title, description }) => (
                <div
                  key={title}
                  className="rounded-2xl border border-white/10 bg-white/5 p-4"
                >
                  <Icon size={18} className="text-primary" />
                  <p className="mt-3 text-sm font-semibold text-white">{title}</p>
                  <p className="mt-2 text-xs leading-6 text-neutral-400">{description}</p>
                </div>
              ))}
            </div>
          </div>

          <div className="grid gap-10 sm:grid-cols-2 lg:grid-cols-1">
            <div>
              <h3 className="text-lg font-semibold text-white">Navigasi</h3>
              <ul className="mt-4 space-y-3 text-sm">
                {navigationLinks.map((item) => (
                  <li key={item.label}>
                    <Link className="transition hover:text-white" to={item.to}>
                      {item.label}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>

            <div>
              <h3 className="text-lg font-semibold text-white">Akun</h3>
              <ul className="mt-4 space-y-3 text-sm">
                {accountLinks.map((item) => (
                  <li key={item.label}>
                    <Link className="transition hover:text-white" to={item.to}>
                      {item.label}
                    </Link>
                  </li>
                ))}
              </ul>
            </div>
          </div>

          <div>
            <h3 className="text-lg font-semibold text-white">Hubungi Kami</h3>
            <div className="mt-4 space-y-4 text-sm text-neutral-400">
              <div className="flex items-start gap-3">
                <MapPin size={18} className="mt-0.5 shrink-0 text-primary" />
                <p className="leading-6">
                  Jl. Kecubung 1 No.14, Kuta Baru, Kec. Ps. Kemis, Kabupaten Tangerang,
                  Banten 15560
                </p>
              </div>

              <a
                className="flex items-center gap-3 transition hover:text-white"
                href="mailto:rereps@gmail.com"
              >
                <Mail size={18} className="text-primary" />
                rereps@gmail.com
              </a>

              <a
                className="flex items-center gap-3 transition hover:text-white"
                href="tel:081319410250"
              >
                <Phone size={18} className="text-primary" />
                0813-1941-0250
              </a>

              <div className="flex items-center gap-3">
                <Clock3 size={18} className="text-primary" />
                <p>Setiap hari, 09.00 - 20.00 WIB</p>
              </div>

              <a
                className="inline-flex items-center gap-3 rounded-full border border-white/15 px-4 py-2 text-white transition hover:border-primary hover:bg-primary hover:text-black"
                href="https://instagram.com"
                target="_blank"
                rel="noreferrer"
              >
                <Instagram size={16} />
                Instagram Kami
              </a>
            </div>
          </div>
        </div>

        <div className="flex flex-col gap-3 pt-6 text-sm text-neutral-500 md:flex-row md:items-center md:justify-between">
          <p>&copy; 2026 ReRe Petshop. Semua hak dilindungi.</p>
          <p>Dibuat untuk pengalaman belanja pet shop yang lebih sederhana dan nyaman.</p>
        </div>
      </div>
    </footer>
  );
}
