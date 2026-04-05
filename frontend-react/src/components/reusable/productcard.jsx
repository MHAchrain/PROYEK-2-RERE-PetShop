import { Heart, Eye, Star } from 'lucide-react';
import { Link } from 'react-router-dom';

export default function ProductCard({
  id,
  nama,
  harga,
  foto,
  diskon = 0,
  rating = 5,
}) {

  const imageSrc = Array.isArray(image) ? image[0] : image;
  const safeHarga = Number(harga) || 0;
  const safeDiskon = Number(diskon) || 0;
  const safeRating = Number(rating) || 0;

<<<<<<< HEAD
  const imageUrl = foto
    ? `http://127.0.0.1:8000/storage/${foto}`
    : 'https://via.placeholder.com/300x300?text=No+Image';
=======
  const hasDiskon = safeDiskon > 0;

  const hargaFinal = hasDiskon
    ? safeHarga - (safeHarga * safeDiskon) / 100
    : safeHarga;
>>>>>>> dev

  return (
    <div
      className="relative group rounded-sm overflow-hidden 
      transition-all duration-500 hover:scale-105">
      <div className="relative aspect-square overflow-hidden">
        <Link to={`/product/${id}`} className="block w-full h-full">
          <img
<<<<<<< HEAD
            src={imageUrl}
            alt={nama}
=======
            src={imageSrc || "/no-image.png"}
            alt={nama || "product"}
>>>>>>> dev
            loading="lazy"
            className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
          />
        </Link>

        {hasDiskon && (
          <div className="absolute top-3 left-3 bg-red-700 text-white text-xs px-3 py-1 rounded-md z-20">
            -{diskon}%
          </div>
        )}

        <div className="absolute top-3 right-3 flex flex-col gap-2 z-20">
          <button
            onClick={(e) => {
              e.stopPropagation();
              console.log('wishlist');
            }}
            className="bg-white p-2 rounded-full shadow hover:bg-gray-200 transition">
            <Heart size={18} />
          </button>

          <button
            onClick={(e) => {
              e.stopPropagation();
              console.log('quick view');
            }}
            className="bg-white p-2 rounded-full shadow hover:bg-gray-200 transition">
            <Eye size={18} />
          </button>
        </div>

        <div
          className="absolute bottom-0 left-0 w-full 
          translate-y-full group-hover:translate-y-0
          transition-transform duration-300 z-20">
          <button
            onClick={(e) => {
              e.stopPropagation();
              console.log('add to cart');
            }}
            className="w-full bg-black text-white py-3 font-medium transition">
            Add to Cart
          </button>
        </div>
      </div>

      <Link
        to={`/product/${id}`}
        className="block pt-4 space-y-2 text-sm md:text-base">
        <h4 className="font-semibold truncate">{nama}</h4>

        <div className="flex items-center gap-2">
          <p
            className={`font-semibold ${hasDiskon ? 'text-primary' : 'text-gray-800'}`}>
            Rp {Number(hargaFinal).toLocaleString('id-ID')}
          </p>

          {hasDiskon && (
            <p className="text-gray-400 line-through text-sm">
              Rp {Number(harga).toLocaleString('id-ID')}
            </p>
          )}
        </div>

        <div className="flex gap-1">
          {[...Array(rating)].map((_, i) => (
            <Star
              key={i}
              size={16}
              className="fill-yellow-400 text-yellow-400"
            />
          ))}
        </div>
      </Link>
    </div>
  );
}
