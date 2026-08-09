import { MessageCircle, CheckCircle2, Clock, MapPin } from 'lucide-react';
import catbath from '../assets/catbat.jpg';
import { FaWhatsapp } from 'react-icons/fa';

export default function GroomingPage() {
  const whatsappNumber = '6281574814563';
  const message = encodeURIComponent(
    'Halo, saya ingin tanya tentang layanan grooming di ReRe Petshop!',
  );

  const services = [
    'Mandi Sehat & Shampoo Berkualitas',
    'Potong Kuku & Pembersihan Telinga',
    'Cukur Bulu (Style / Sanitasi)',
    'Pemberian Vitamin Kulit & Bulu',
  ];

  return (
    <div className="flex-1 flex flex-col py-10 px-6 md:px-20 mx-auto w-full">
      <div className="flex items-center gap-5 mb-10">
        <div className="bg-primary w-5 h-10 rounded-sm"></div>
        <p className="text-primary font-semibold text-lg">Layanan Grooming</p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
        <div className="space-y-6">
          <h1 className="text-4xl md:text-5xl font-bold text-gray-900 leading-tight">
            Berikan Perawatan <span className="text-primary">Terbaik</span>{' '}
            untuk Anabul kamu
          </h1>

          <p className="text-gray-600 text-lg leading-relaxed">
            Layanan grooming profesional kami dirancang untuk memastikan hewan
            peliharaan kamu tetap bersih, sehat, dan tampil menggemaskan. Kami
            menggunakan produk ramah hewan dan ditangani oleh tenaga
            berpengalaman yang ahli dalam perawatan hewan peliharaan.
          </p>

          <div className="grid grid-cols-1 md:grid-cols-2 gap-4 pt-4">
            {services.map((service, index) => (
              <div key={index} className="flex items-center gap-3">
                <CheckCircle2 className="text-primary" size={20} />
                <span className="text-gray-700 font-medium">{service}</span>
              </div>
            ))}
          </div>

          <div className="flex flex-wrap gap-6 pt-6">
            <div className="flex items-center gap-2 text-gray-500">
              <Clock size={18} />
              <span>09:00 - 18:00 WIB</span>
            </div>
            <div className="flex items-center gap-2 text-gray-500">
              <MapPin size={18} />
              <span>Tersedia layanan panggilan</span>
            </div>
          </div>

          <div className="pt-8">
            <a
              href={`https://wa.me/${whatsappNumber}?text=${message}`}
              target="_blank"
              rel="noopener noreferrer"
              className="inline-flex items-center gap-3 bg-[#25D366] text-white px-8 py-4 rounded-lg font-bold text-lg hover:bg-[#20ba5a] transition-all shadow-lg hover:shadow-xl active:scale-95">
              <FaWhatsapp size={24} />
              Hubungi via WhatsApp
            </a>
            <p className="text-sm text-gray-400 mt-3">
              *Konsultasi gratis & Booking jadwal
            </p>
          </div>
        </div>

        <div className="relative">
          <div className="aspect-square rounded-3xl bg-primary/10 overflow-hidden border-2 border-primary/20 flex items-center justify-center">
            <img
              src={catbath}
              alt="Layanan grooming"
              className="object-cover w-full h-full hover:scale-105 transition-transform duration-500"
            />
          </div>
          <div className="absolute -bottom-6 -left-6 bg-white p-6 rounded-2xl shadow-lg hidden md:block border border-gray-100">
            <p className="text-primary font-bold text-2xl leading-none">100%</p>
            <p className="text-gray-600 text-sm">Aman & Higienis</p>
          </div>
        </div>
      </div>
    </div>
  );
}
