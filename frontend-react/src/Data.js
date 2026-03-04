import * as icons from "lucide-react";
import examp from "../src/assets/examp.jpeg";
import dummy from "../src/assets/dummy.png";
import profile_1  from "./assets/profile_1.jpeg"
import profile_2  from "./assets/profile_2.jpeg"
import profile_3  from "./assets/profile_3.jpeg"
import { Truck, Headphones, ShieldCheck } from "lucide-react";

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
  { id: 1, nama: "Food", icon: icons.Fish },
  { id: 2, nama: "Toys", icon: icons.Puzzle },
  { id: 3, nama: "Accessories", icon: icons.Tag },
  { id: 4, nama: "Grooming", icon: icons.Scissors }
]

export const HeroSlides = [
  { id: 1, text: "Promo Makanan Kucing!", image: examp },
  { id: 2, text: "Diskon Mainan Anjing!", image: examp },
  { id: 3, text: "Aksesoris Lucu untuk Hewan Peliharaan!", image: examp },
  { id: 4, text: "Perawatan Grooming Terbaik!", image: examp},
  { id: 5, text: "Semua Kebutuhan Hewan Peliharaan Ada di Sini!", image: examp }
]

export const Statistic = [
  { id: 1, value: "10.5k", label: "Sellers active our site", icon: icons.Store },
  { id: 2, value: "33k", label: "Monthly Product Sale", icon: icons.Banknote },
  { id: 3, value: "45.5k", label: "Customer active in our site", icon: icons.Handbag },
  { id: 4, value: "25k", label: "Annual gross sale in our site", icon: icons.DollarSign },
]

export const TeamList = [
  {
    id: 1, 
    name: "MH Achrain", 
    role: "Frontend Developer", 
    image: profile_1, 
    instagram: "https://www.instagram.com/mhrain._?igsh=NnBvaWd4c3liOXNt",
    linkedin: "https://www.linkedin.com/in/muhammad-hikmaturrahman-achrain-02b3a0327?utm_source=share_via&utm_content=profile&utm_medium=member_android",
    github: "https://github.com/MHAchrain",
  },

  {
    id: 2, 
    name: "Sakhi Ardha Handaru", 
    role: "Frontend Developer", 
    image: profile_2,
    instagram: "https://www.instagram.com/mhrain._?igsh=NnBvaWd4c3liOXNt",
    linkedin: "https://www.linkedin.com/in/muhammad-hikmaturrahman-achrain-02b3a0327?utm_source=share_via&utm_content=profile&utm_medium=member_android",
    github: "https://github.com/MHAchrain",
  },

  {
    id: 3, 
    name: "Nabil Stani Syabana", 
    role: "Frontend Developer", 
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
    title: "FREE AND FAST DELIVERY",
    desc: "Free delivery for all orders over $140",
  },
  {
    id: 2,
    icon: Headphones,
    title: "24/7 CUSTOMER SERVICE",
    desc: "Friendly 24/7 customer support",
  },
  {
    id: 3,
    icon: ShieldCheck,
    title: "MONEY BACK GUARANTEE",
    desc: "We return money within 30 days",
  },
];
