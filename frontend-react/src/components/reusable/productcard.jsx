import { Heart, Eye, Star } from 'lucide-react';
import { Link } from 'react-router-dom';

export default function ProductCard({
  id,
  nama,
  harga,
  image, // GUNAKAN 'image' karena di ProductSection kamu tulisnya: image={...}
  diskon = 0,
  rating = 5,
}) {
  // 1. Pastikan angka aman
  const safeHarga = Number(harga) || 0;
  const safeDiskon = Number(diskon) || 0;
  const safeRating = Number(rating) || 5;

  const hasDiskon = safeDiskon > 0;
  const hargaFinal = hasDiskon
    ? safeHarga - (safeHarga * safeDiskon) / 100
    : safeHarga;

  // 2. Tentukan path detail. Cek App.jsx kamu pakai "/product/" atau "/produk/"?
  // Saya pakai "/product/" sesuai kode yang kamu kirim barusan.
  const detailPath = `/product/${id}`;

  return (
    <div className="relative group rounded-sm overflow-hidden transition-all duration-500 hover:scale-105">
      <div className="relative aspect-square overflow-hidden bg-[#F5F5F5] flex items-center justify-center">
        {/* Link Gambar */}
        <Link to={detailPath} className="block w-full h-full">
          <img
            src={imageSrc || "../assets/no-image.png"}
            alt={nama || "product"}
            loading="lazy"
            className="w-full h-full object-contain p-4 transition-transform duration-500 group-hover:scale-110"
            onError={(e) => {
              e.target.src = 'https://via.placeholder.com/150?text=No+Image';
            }}
          />
        </Link>

        {/* Badge Diskon */}
        {hasDiskon && (
          <div className="absolute top-3 left-3 bg-red-700 text-white text-xs px-3 py-1 rounded-md z-20">
            -{safeDiskon}%
          </div>
        )}

        {/* Tombol Aksi */}
        <div className="absolute top-3 right-3 flex flex-col gap-2 z-20 opacity-0 group-hover:opacity-100 transition-opacity duration-300">
          <button className="bg-white p-2 rounded-full shadow hover:bg-gray-200 transition text-black">
            <Heart size={18} />
          </button>
          <Link
            to={detailPath}
            className="bg-white p-2 rounded-full shadow hover:bg-gray-200 transition text-black">
            <Eye size={18} />
          </Link>
        </div>

        {/* Tombol Add to Cart */}
        <div className="absolute bottom-0 left-0 w-full translate-y-full group-hover:translate-y-0 transition-transform duration-300 z-20">
          <button className="w-full bg-black text-white py-3 font-medium">
            Add to Cart
          </button>
        </div>
      </div>

      {/* Info Produk */}
      <div className="pt-4 space-y-2 text-sm md:text-base">
        <Link to={detailPath} className="block">
          <h4 className="font-semibold truncate uppercase hover:text-primary transition">
            {nama}
          </h4>
        </Link>

        <div className="flex items-center gap-2">
          <p
            className={`font-semibold ${hasDiskon ? 'text-primary' : 'text-gray-800'}`}>
            Rp {Math.floor(hargaFinal).toLocaleString('id-ID')}
          </p>
          {hasDiskon && (
            <p className="text-gray-400 line-through text-sm">
              Rp {safeHarga.toLocaleString('id-ID')}
            </p>
          )}
        </div>

        {/* Star Rating */}
        <div className="flex gap-1">
          {[...Array(5)].map((_, i) => (
            <Star
              key={i}
              size={16}
              className={
                i < safeRating
                  ? 'fill-yellow-400 text-yellow-400'
                  : 'text-gray-300'
              }
            />
          ))}
        </div>
      </div>
    </div>
  );
}
