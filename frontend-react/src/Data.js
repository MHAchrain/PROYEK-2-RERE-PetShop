import * as icons from 'lucide-react';
import { Truck, Headphones, ShieldCheck } from 'lucide-react';
// Assets
import examp from './assets/examp.jpeg';
import dummy from './assets/dummy.png';
import hero1 from './assets/ba1.png';
import hero2 from './assets/ba2.png';
import hero3 from './assets/ba3.png';
import hero4 from './assets/ba4.png';
import hero5 from './assets/ba5.png';

import profile_1 from './assets/profile_1.jpeg';
import profile_2 from './assets/profile_2.jpeg';
import profile_3 from './assets/profile_3.jpeg';

export const ListKategori = [
  { id: 1, nama: 'Makanan', icon: icons.Fish },
  { id: 2, nama: 'Mainan', icon: icons.Puzzle },
  { id: 3, nama: 'Aksesori', icon: icons.Tag },
  { id: 4, nama: 'Grooming', icon: icons.Scissors },
];

export const HeroSlides = [
  { id: 1, text: 'Pilihan Makanan Kucing Favorit', image: hero1 },
  { id: 2, text: 'Mainan Seru untuk Anjing Aktif', image: hero2 },
  { id: 3, text: 'Aksesori Lucu untuk Hewan Peliharaan', image: hero3 },
  { id: 4, text: 'Perawatan Grooming yang Nyaman', image: hero4 },
  { id: 5, text: 'Semua Kebutuhan Anabul Ada di Sini', image: hero5 },
];

export const Statistic = [
  {
    id: 1,
    value: '10.5k',
    label: 'Penjual aktif di situs kami',
    icon: icons.Store,
  },
  {
    id: 2,
    value: '33k',
    label: 'Penjualan produk bulanan',
    icon: icons.Banknote,
  },
  {
    id: 3,
    value: '45.5k',
    label: 'Pelanggan aktif di situs kami',
    icon: icons.Handbag,
  },
  {
    id: 4,
    value: '25k',
    label: 'Penjualan kotor tahunan',
    icon: icons.DollarSign,
  },
];

export const BenefitList = [
  {
    id: 1,
    icon: Truck,
    title: 'PENGIRIMAN GRATIS DAN CEPAT',
    desc: 'Gratis pengiriman untuk pesanan di atas Rp 200.000',
  },
  {
    id: 2,
    icon: Headphones,
    title: 'LAYANAN PELANGGAN 24/7',
    desc: 'Dukungan pelanggan yang ramah setiap saat',
  },
  {
    id: 3,
    icon: ShieldCheck,
    title: 'GARANSI UANG KEMBALI',
    desc: 'Pengembalian dana dapat diproses hingga 30 hari',
  },
];

export const branchList = [
  {
    id: 1,
    name: 'Petshop ReRe',
    address:
      'Jl. Kecubung 1 No.14, Kuta Baru, Kec. Ps. Kemis, Kabupaten Tangerang, Banten 15560',
    href: 'https://maps.app.goo.gl/KhHZDREz16k6FWgx8',
    hours: 'Setiap hari, 09.00 - 21.00',
    phone: '+62 813-1941-0250',
    // note: 'Cabang utama dengan koleksi produk harian paling lengkap dan konsultasi belanja langsung.',
  },
  {
    id: 2,
    name: 'Petshop Rumah Kucing ReRe',
    address: 'Bugel, Kec. Karawaci, Kota Tangerang, Banten',
    href: ' https://maps.app.goo.gl/qKCWPHzqdAmWaA5K6',
    hours: 'Setiap hari, 09.00 - 21.00',
    phone: '+62 813-1941-0250',
    // note: 'Fokus pada kebutuhan grooming, camilan, dan aksesoris favorit anabul.',
  },
  {
    id: 3,
    name: 'Petshop ReRe, Cilongok New',
    address:
      'Ds, Jl. Raya pasar Kemis Kp, Cilongok RGGV+W83 pos, RT.004/RW.04, Sukamantri, Kec. Ps. Kemis, Kabupaten Tangerang, Banten 15560',
    href: 'https://maps.app.goo.gl/VsBzfAZgBpQmtdvc7',
    hours: 'Setiap hari, 09.00 - 21.00',
    phone: '+62 813-1941-0250',
    // note: 'Cocok untuk belanja cepat dengan area toko yang nyaman dan stok produk pilihan.',
  },
  {
    id: 4,
    name: 'Petshop Rumah Kucing',
    address: 'Kuta Jaya, Kec. Ps. Kemis, Kabupaten Tangerang, Banten',
    href: 'https://maps.app.goo.gl/jmiutxKqxbPTThcm6',
    hours: 'Setiap hari, 09.00 - 21.00',
    phone: '+62 813-1941-0250',
    // note: 'Cocok untuk belanja cepat dengan area toko yang nyaman dan stok produk pilihan.',
  },
  {
    id: 5,
    name: 'Rumah Kucing',
    address:
      'Jl. Prabu Kian Santang No.18, RT.001/RW.012, Sangiang Jaya, Kec. Periuk, Kota Tangerang, Banten 15131',
    href: 'https://maps.app.goo.gl/yWVGt1LMVmMARdgt9',
    hours: 'Setiap hari, 09.00 - 21.00',
    phone: '+62 813-1941-0250',
    // note: 'Cocok untuk belanja cepat dengan area toko yang nyaman dan stok produk pilihan.',
  },
  {
    id: 6,
    name: 'Petshop ReRe, Sepatan',
    address: 'Pd. Jaya, Kec. Sepatan, Kabupaten Tangerang, Banten',
    href: 'https://maps.app.goo.gl/bJu4a27vJGebag4K6',
    hours: 'Setiap hari, 09.00 - 21.00',
    phone: '+62 813-1941-0250',
    // note: 'Cocok untuk belanja cepat dengan area toko yang nyaman dan stok produk pilihan.',
  },
  {
    id: 7,
    name: 'Petshop ReRe, Total Persada',
    address:
      'RHHM+497, Jl. Raya Villa Tangerang Indah, RT.004/RW.007, Gembor, Kec. Periuk, Kota Tangerang, Banten 15133',
    href: 'https://maps.app.goo.gl/Jm4AeZ2bVZXZpqPo9',
    hours: 'Setiap hari, 09.00 - 21.00',
    phone: '+62 813-1941-0250',
    // note: 'Cocok untuk belanja cepat dengan area toko yang nyaman dan stok produk pilihan.',
  },
];

export const groomingServices = [
  {
    id: 1,
    name: 'Grooming Basic',
    description:
      'Mandi dan perawatan dasar untuk hewan peliharaan Anda.',
    price: 150000,
    durationMinutes: 60,
    isActive: true,
  },
  {
    id: 2,
    name: 'Grooming Medium',
    description:
      'Mandi, perawatan, dan pemotongan bulu untuk hewan peliharaan Anda.',
    price: 250000,
    durationMinutes: 60,
    isActive: true,
  },
  {
    id: 3,
    name: 'Grooming Premium',
    description:
      'Perawatan lengkap termasuk mandi, pemotongan bulu, dan perawatan tambahan untuk hewan peliharaan Anda.',
    price: 350000,
    durationMinutes: 90,
    isActive: true,
  },
];

export const groomingSlots = [
  {
    date: '2026-09-27',
    time: '09:00',
    capacity: 1,
    booked: 0,
  },
  {
    date: '2026-09-27',
    time: '11:00',
    capacity: 1,
    booked: 0,
  },
  {
    date: '2026-09-27',
    time: '13:00',
    capacity: 1,
    booked: 1,
  },
  {
    date: '2026-09-27',
    time: '15:00',
    capacity: 1,
    booked: 0,
  },
  {
    date: '2026-09-27',
    time: '17:00',
    capacity: 1,
    booked: 1,
  },
];

// Dummy booking grooming akan ditambahkan di sini untuk pengembangan riwayat.
export const groomingBookings = [
  {
    id: 'GR-1001',
    userId: 13,
    serviceId: 1,
    serviceName: 'Grooming Basic',
    price: 150000,
    date: '2026-09-27',
    time: '09:00',
    petName: 'Mochi',
    petType: 'Kucing',
    petBreed: 'Persia',
    petSize: 'Kecil',
    petNote: 'Kulit agak sensitif',
    status: 'menunggu_pembayaran',
    createdAt: '2026-09-26T10:30:00.000Z',
  },
  {
    id: 'GR-1002',
    userId: 13,
    serviceId: 2,
    serviceName: 'Grooming Medium',
    price: 250000,
    date: '2026-09-27',
    time: '11:00',
    petName: 'Oreo',
    petType: 'Anjing',
    petBreed: 'Pomeranian',
    petSize: 'Kecil',
    petNote: '',
    status: 'terjadwal',
    createdAt: '2026-09-25T08:15:00.000Z',
  },
  {
    id: 'GR-1003',
    userId: 13,
    serviceId: 3,
    serviceName: 'Grooming Premium',
    price: 350000,
    date: '2026-09-20',
    time: '13:00',
    petName: 'Luna',
    petType: 'Kucing',
    petBreed: 'Anggora',
    petSize: 'Sedang',
    petNote: '',
    status: 'selesai',
    createdAt: '2026-09-19T07:00:00.000Z',
  },
  {
    id: 'GR-1004',
    userId: 13,
    serviceId: 4,
    serviceName: 'Grooming Premium',
    price: 350000,
    date: '2026-09-20',
    time: '13:00',
    petName: 'Luna',
    petType: 'Kucing',
    petBreed: 'Anggora',
    petSize: 'Sedang',
    petNote: '',
    status: 'dibatalkan',
    createdAt: '2026-09-19T07:00:00.000Z',
  },
];