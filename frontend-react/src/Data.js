import * as icons from "lucide-react";
import { Truck, Headphones, ShieldCheck } from "lucide-react";
// Assets
import examp from "./assets/examp.jpeg";
import dummy from "./assets/dummy.png";
import hero1 from "./assets/ba1.png";
import hero2 from "./assets/ba2.png";
import hero3 from "./assets/ba3.png";
import profile_1  from "./assets/profile_1.jpeg"
import profile_2  from "./assets/profile_2.jpeg"
import profile_3  from "./assets/profile_3.jpeg"

export const ListBarang = [
  { id: 1, nama: "Bolt Ikan Ungu", harga: 20000, stok: 20, image: [examp, dummy], rating: 5},
  { id: 2, nama: "Bolt Donat Kuning", harga: 25000, stok: 20, image: [examp, dummy], diskon: 20, rating: 4},
  { id: 3, nama: "Bolt Salmon", harga: 30000, stok: 20, image: [examp, dummy], diskon: 35, rating: 4},
  { id: 4, nama: "CCH Hijau", harga: 18000, stok: 20, image: [examp, dummy], rating: 5},
  { id: 5, nama: "CCH Oren", harga: 22000, stok: 20, image: [examp, dummy], diskon: 15, rating: 4},
  { id: 6, nama: "Excel Ungu", harga: 27000, stok: 20, image: [examp, dummy], diskon: 25, rating: 5},
  { id: 7, nama: "Excel Pink", harga: 35000, stok: 20, image: [examp, dummy], rating: 4},
  { id: 8, nama: "Omega Tuna", harga: 40000, stok: 20, image: [examp, dummy], diskon: 5, rating: 5},
  { id: 9, nama: "Maxi", harga: 15000, stok: 20, image: [examp, dummy], rating: 4},
  { id: 10, nama: "Mr Puss Hijau", harga: 23000, stok: 20, image: [examp, dummy], diskon: 15, rating: 5},
  { id: 11, nama: "Felibite Ikan", harga: 28000, stok: 20, image: [examp, dummy], rating: 5},
  { id: 12, nama: "Amigo Tuna", harga: 26000, stok: 20, image: [examp, dummy], diskon: 12, rating: 5},
  { id: 13, nama: "Bolt Kitten Tuna", harga: 32000, stok: 20, image: [examp, dummy], rating: 4},
  { id: 14, nama: "Proplan Adult", harga: 50000, stok: 20, image: [examp, dummy], diskon: 8, rating: 5},
  { id: 15, nama: "Beauty Premium", harga: 45000, stok: 20, image: [examp, dummy], diskon: 22, rating: 4},
  { id: 16, nama: "Lezato Kitten", harga: 34000, stok: 20, image: [examp, dummy], rating: 5},
  { id: 17, nama: "Royal Puss Biru", harga: 37000, stok: 20, image: [examp, dummy], diskon: 15, rating: 4},
  { id: 18, nama: "Bolt Dog Merah", harga: 29000, stok: 20, image: [examp, dummy], diskon: 28, rating: 5},
  { id: 19, nama: "Oricat Adult Tuna", harga: 31000, stok: 20, image: [examp, dummy], rating: 4},
  { id: 20, nama: "Markotop Kuning", harga: 24000, stok: 20, image: [examp, dummy], diskon: 16, rating: 5},
  { id: 21, nama: "Nice Rabbit", harga: 19000, stok: 20, image: [examp, dummy], diskon: 25, rating: 4},
  { id: 22, nama: "RC Kitten", harga: 50000, stok: 20, image: [examp, dummy], rating: 5},
  { id: 23, nama: "Meo Adult Tuna", harga: 33000, stok: 20, image: [examp, dummy], diskon: 20, rating: 4},
  { id: 24, nama: "Proplan Kitten", harga: 48000, stok: 20, image: [examp, dummy], rating: 5},
  { id: 25, nama: "Bolt Dog Biru", harga: 30000, stok: 20, image: [examp, dummy], diskon: 32, rating: 4},
  { id: 26, nama: "Whiskas Kitten Tuna 85gr", harga: 6000, stok: 20, image: [examp, dummy], rating: 5},
  { id: 27, nama: "Whiskas Adult Tuna 85gr", harga: 5000, stok: 20, image: [examp, dummy], diskon: 10, rating: 4},
  { id: 28, nama: "Bio Creamy", harga: 17000, stok: 20, image: [examp, dummy], diskon: 20, rating: 5 },
  { id: 29, nama: "Royal Dog Kaleng", harga: 42000, stok: 20, image: [examp, dummy], rating: 5 },
  { id: 30, nama: "Susu Growsy", harga: 38000, stok: 20, image: [examp, dummy], diskon: 24, rating: 4 }
];

export const ListKategori = [
  { id: 1, nama: "Makanan", icon: icons.Fish },
  { id: 2, nama: "Mainan", icon: icons.Puzzle },
  { id: 3, nama: "Aksesori", icon: icons.Tag },
  { id: 4, nama: "Grooming", icon: icons.Scissors }
]

export const HeroSlides = [
  { id: 1, text: "Pilihan Makanan Kucing Favorit", image: hero1 },
  { id: 2, text: "Mainan Seru untuk Anjing Aktif", image: hero2 },
  { id: 3, text: "Aksesori Lucu untuk Hewan Peliharaan", image: hero3 },
  { id: 4, text: "Perawatan Grooming yang Nyaman", image: examp},
  { id: 5, text: "Semua Kebutuhan Anabul Ada di Sini", image: examp }
]

export const Statistic = [
  { id: 1, value: "10.5k", label: "Penjual aktif di situs kami", icon: icons.Store },
  { id: 2, value: "33k", label: "Penjualan produk bulanan", icon: icons.Banknote },
  { id: 3, value: "45.5k", label: "Pelanggan aktif di situs kami", icon: icons.Handbag },
  { id: 4, value: "25k", label: "Penjualan kotor tahunan", icon: icons.DollarSign },
]

export const TeamList = [
  {
    id: 1, 
    name: "MH Achrain", 
    role: "Pengembang Frontend", 
    image: profile_1, 
    instagram: "https://www.instagram.com/mhrain._?igsh=NnBvaWd4c3liOXNt",
    linkedin: "https://www.linkedin.com/in/muhammad-hikmaturrahman-achrain-02b3a0327?utm_source=share_via&utm_content=profile&utm_medium=member_android",
    github: "https://github.com/MHAchrain",
  },

  {
    id: 2, 
    name: "Sakhi Ardha Handaru", 
    role: "Pengembang Frontend", 
    image: profile_2,
    instagram: "https://www.instagram.com/mhrain._?igsh=NnBvaWd4c3liOXNt",
    linkedin: "https://www.linkedin.com/in/muhammad-hikmaturrahman-achrain-02b3a0327?utm_source=share_via&utm_content=profile&utm_medium=member_android",
    github: "https://github.com/MHAchrain",
  },

  {
    id: 3, 
    name: "Nabil Stani Syabana", 
    role: "Pengembang Frontend", 
    image: profile_3,
    instagram: "https://www.instagram.com/nstnsybn/",
    linkedin: "https://www.linkedin.com/in/nabilstanisyabana/",
    github: "https://github.com/nabilstanisyabana",
  },
];

export const BenefitList = [
  {
    id: 1,
    icon: Truck,
    title: "PENGIRIMAN GRATIS DAN CEPAT",
    desc: "Gratis pengiriman untuk pesanan di atas Rp 200.000",
  },
  {
    id: 2,
    icon: Headphones,
    title: "LAYANAN PELANGGAN 24/7",
    desc: "Dukungan pelanggan yang ramah setiap saat",
  },
  {
    id: 3,
    icon: ShieldCheck,
    title: "GARANSI UANG KEMBALI",
    desc: "Pengembalian dana dapat diproses hingga 30 hari",
  },
];

  export const branchList = [
    {
      id: 1,
      name: 'Petshop ReRe',
      address: 'Jl. Kecubung 1 No.14, Kuta Baru, Kec. Ps. Kemis, Kabupaten Tangerang, Banten 15560',
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
      address: 'Ds, Jl. Raya pasar Kemis Kp, Cilongok RGGV+W83 pos, RT.004/RW.04, Sukamantri, Kec. Ps. Kemis, Kabupaten Tangerang, Banten 15560',
      href: 'https://maps.app.goo.gl/VsBzfAZgBpQmtdvc7',
      hours: 'Setiap hari, 09.00 - 21.00',
      phone: '+62 813-1941-0250',
      // note: 'Cocok untuk belanja cepat dengan area toko yang nyaman dan stok produk pilihan.',
    },
    {
      id: 4,
      name: 'Petshop Rumah kucing',
      address: 'Kuta Jaya, Kec. Ps. Kemis, Kabupaten Tangerang, Banten',
      href: 'https://maps.app.goo.gl/jmiutxKqxbPTThcm6',
      hours: 'Setiap hari, 09.00 - 21.00',
      phone: '+62 813-1941-0250',
      // note: 'Cocok untuk belanja cepat dengan area toko yang nyaman dan stok produk pilihan.',
    },
    {
      id: 5,
      name: 'Rumah Kucing',
      address: 'Jl. Prabu Kian Santang No.18, RT.001/RW.012, Sangiang Jaya, Kec. Periuk, Kota Tangerang, Banten 15131',
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
      name: 'Petshop ReRe,Total Persada',
      address: 'RHHM+497, Jl. Raya Villa Tangerang Indah, RT.004/RW.007, Gembor, Kec. Periuk, Kota Tangerang, Banten 15133',
      href: 'https://maps.app.goo.gl/Jm4AeZ2bVZXZpqPo9',
      hours: 'Setiap hari, 09.00 - 21.00',
      phone: '+62 813-1941-0250',
      // note: 'Cocok untuk belanja cepat dengan area toko yang nyaman dan stok produk pilihan.',
    },
  ];
