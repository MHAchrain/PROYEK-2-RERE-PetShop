import { ArrowRight, CarFront, Store } from 'lucide-react';
import { Link } from 'react-router-dom';
import { groomingServices } from '../Data';
import GroomingHero from '../components/section/grooming/groominghero';
import GroomingServiceList from '../components/section/grooming/groomingservicelist';

const bookingSteps = [
  ['Pilih layanan', 'Tentukan paket grooming yang sesuai untuk anabul.'],
  ['Isi data hewan', 'Berikan informasi dasar agar salon siap menerima hewanmu.'],
  ['Pilih jadwal dan bayar', 'Pilih slot yang tersedia. Booking dikonfirmasi setelah pembayaran berhasil.'],
];

export default function GroomingPage() {
  return (
    <main className="min-h-screen grow px-4 py-8 md:px-8 md:py-10 lg:px-16 xl:px-20">
      <div className="mx-auto w-full max-w-7xl space-y-8">
        <GroomingHero />

        <section aria-labelledby="cara-booking-title">
          <div className="mx-auto max-w-2xl text-center">
            <p className="font-semibold text-primary">Mudah dan praktis</p>
            <h2 id="cara-booking-title" className="mt-2 text-3xl font-bold text-gray-900">
              Cara booking grooming
            </h2>
          </div>
          <div className="mt-8 grid gap-4 md:grid-cols-3">
            {bookingSteps.map(([title, description], index) => (
              <article key={title} className="rounded-2xl bg-gray-50 shadow-sm p-6">
                <span className="flex h-10 w-10 items-center justify-center rounded-full bg-primary/10 font-bold text-primary">
                  {index + 1}
                </span>
                <h3 className="mt-4 font-bold text-gray-900">{title}</h3>
                <p className="mt-2 text-sm leading-relaxed text-gray-600">{description}</p>
              </article>
            ))}
          </div>
        </section>

        <GroomingServiceList services={groomingServices} />

        <section aria-labelledby="metode-kunjungan-title">
          <div className="mx-auto max-w-2xl text-center">
            <p className="font-semibold text-primary">Pilih cara layanan</p>
            <h2 id="metode-kunjungan-title" className="mt-2 text-3xl font-bold text-gray-900">
              Bagaimana anabul datang?
            </h2>
            <p className="mt-3 text-gray-600">
              Untuk sekarang, booking online tersedia untuk kunjungan langsung ke toko.
            </p>
          </div>

          <div className="mx-auto mt-8 grid max-w-4xl gap-5 md:grid-cols-2">
            <article className="rounded-2xl border-2 border-gray-200 bg-white p-6 shadow-sm">
              <Store className="text-primary" size={28} />
              <h3 className="mt-4 text-xl font-bold text-gray-900">Datang ke toko</h3>
              <p className="mt-2 leading-relaxed text-gray-600">
                Bawa anabul ke toko pada jadwal grooming yang sudah dipilih.
              </p>
            </article>

            <article className="rounded-2xl border-2 border-gray-200 bg-white p-6 shadow-sm">
              <CarFront className="text-primary" size={28} />
              <h3 className="mt-4 text-xl font-bold text-gray-900">Antar-jemput</h3>
              <p className="mt-2 leading-relaxed text-gray-600">
                Opsi antar-jemput direncanakan. Detail jadwal dan biaya akan tersedia
                setelah alurnya siap.
              </p>
              <span className="mt-5 inline-flex rounded-full bg-gray-200 px-3 py-1 text-sm font-medium text-gray-600">
                Segera tersedia
              </span>
            </article>
          </div>
        </section>

        <section className="rounded-3xl bg-primary px-6 py-10 text-center text-white sm:px-10">
          <h2 className="text-2xl font-bold sm:text-3xl">Siap booking grooming?</h2>
          <p className="mx-auto mt-3 max-w-xl text-white/85">
            Pilih layanan dan jadwal yang cocok untuk anabulmu.
          </p>
          <Link
            to="/grooming/booking"
            className="mt-6 inline-flex items-center gap-2 rounded-lg bg-white px-6 py-3 font-semibold text-primary transition hover:bg-gray-100">
            Mulai booking <ArrowRight size={18} />
          </Link>
        </section>
      </div>
    </main>
  );
}
