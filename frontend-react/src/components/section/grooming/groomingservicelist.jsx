import { ArrowRight, Check } from 'lucide-react';
import { Link } from 'react-router-dom';

const formatPrice = (price) =>
  new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    maximumFractionDigits: 0,
  }).format(Number(price));

export default function GroomingServiceList({ services = [] }) {
  const activeServices = services.filter((service) => service.isActive);

  return (
    <section id="layanan-grooming" className="scroll-mt-24">
      <div className="mx-auto max-w-2xl text-center">
        <p className="font-semibold text-primary">Pilih perawatannya</p>
        <h2 className="mt-2 text-3xl font-bold text-gray-900">Layanan grooming</h2>
        <p className="mt-3 leading-relaxed text-gray-600">
          Harga berikut adalah harga layanan. Pilih paket saat mulai booking;
          jadwal yang penuh tidak bisa dipilih.
        </p>
      </div>

      <div className="mt-8 grid gap-5 md:grid-cols-2 xl:grid-cols-3">
        {activeServices.map((service) => (
          <article
            key={service.id}
            className="flex h-full flex-col rounded-2xl border border-gray-200 bg-white p-6 shadow-sm transition hover:-translate-y-1 hover:shadow-md">
            <div className="flex-1">
              <h3 className="text-xl font-bold text-gray-900">{service.name}</h3>
              <p className="mt-3 min-h-12 leading-relaxed text-gray-600">
                {service.description}
              </p>
              <ul className="mt-5 space-y-2 text-sm text-gray-600">
                <li className="flex items-center gap-2">
                  <Check size={16} className="shrink-0 text-primary" />
                  Durasi sekitar {service.durationMinutes} menit
                </li>
                <li className="flex items-center gap-2">
                  <Check size={16} className="shrink-0 text-primary" />
                  Satu hewan untuk satu slot grooming
                </li>
              </ul>
            </div>

            <div className="mt-6 border-t border-gray-100 pt-5">
              <p className="text-sm text-gray-500">Harga layanan</p>
              <p className="mt-1 text-2xl font-bold text-primary">
                {formatPrice(service.price)}
              </p>
              {/* <Link
                to="/grooming/booking"
                className="mt-5 inline-flex w-full items-center justify-center gap-2 rounded-lg bg-primary px-4 py-3 font-semibold text-white transition hover:opacity-90">
                Pilih layanan <ArrowRight size={17} />
              </Link> */}
            </div>
          </article>
        ))}
      </div>
    </section>
  );
}
