import { ArrowRight, CheckCircle2, Clock3, MapPin } from 'lucide-react';
import { Link } from 'react-router-dom';
import catBath from '../../../assets/catbat.jpg';
import Button from '../../ui/button';

const highlights = [
  'Perawatan sesuai kebutuhan anabul',
  'Produk yang nyaman untuk hewan',
  'Jadwal grooming bisa dipilih online',
];

export default function GroomingHero() {
  return (
    <section className="grid items-center gap-10 lg:grid-cols-2 lg:gap-16">
      <div>
        <p className="font-semibold text-primary">Layanan Grooming ReRe Petshop</p>
        <h1 className="mt-4 text-4xl font-bold leading-tight text-gray-900 md:text-5xl">
          Rawat anabul agar tetap <span className="text-primary">bersih dan nyaman</span>
        </h1>
        <p className="mt-5 max-w-xl text-lg leading-relaxed text-gray-600">
          Pilih layanan grooming, isi data hewan, lalu tentukan jadwal untuk
          kunjungan ke toko. Harga layanan ditampilkan sebelum booking.
        </p>

        <ul className="mt-6 space-y-3">
          {highlights.map((highlight) => (
            <li key={highlight} className="flex items-center gap-3 text-gray-700">
              <CheckCircle2 className="shrink-0 text-primary" size={20} />
              <span>{highlight}</span>
            </li>
          ))}
        </ul>

        <div className="mt-8 flex flex-wrap gap-4">
          <Button
            label='Booking Grooming'
            to='/grooming/booking'
            className='font-semibold'
          />
          <Button
            variant='outline'
            label='Lihat Layanan'
            href='#layanan-grooming'
            className='font-semibold'
            onClick={(event) => {
              event.preventDefault();
              document
                .getElementById('layanan-grooming')
                ?.scrollIntoView({ behavior: 'smooth', block: 'start' });
            }}
          />
        </div>

        <div className="mt-8 flex flex-wrap gap-x-6 gap-y-3 text-sm text-gray-500">
          <span className="inline-flex items-center gap-2">
            <Clock3 size={17} className="text-primary" />
            Jadwal berdasarkan slot tersedia
          </span>
          <span className="inline-flex items-center gap-2">
            <MapPin size={17} className="text-primary" />
            Kunjungan ke toko
          </span>
        </div>
      </div>

      <div className="relative mx-auto w-full max-w-xl">
        <div className="aspect-4/3 overflow-hidden rounded-3xl bg-primary/10 shadow-lg">
          <img
            src={catBath}
            alt="Kucing sedang mendapatkan perawatan grooming"
            className="h-full w-full object-cover"
          />
        </div>
        <div className="absolute -bottom-5 left-4 rounded-2xl bg-white p-4 shadow-lg sm:left-8 sm:p-5">
          <p className="font-bold text-gray-900">Booking lebih praktis</p>
          <p className="mt-1 text-sm text-gray-500">Pilih layanan dan waktu kunjungan</p>
        </div>
      </div>
    </section>
  );
}
