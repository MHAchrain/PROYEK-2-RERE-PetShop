import { Heart, PackageCheck, PackageX, Star } from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';
import toast from '../../utils/toast.jsx';
import { useAuth } from '../../context/authcontext';
import { wishlistService } from '../../services/wishlistservice';
import { useAddToCart } from '../../hooks/useaddtocart';
import noImage from '../../assets/no-image.png';
import NgrokImage from './NgrokImage';

export default function ProductCard({
  id,
  nama,
  harga,
  image,
  diskon,
  rating,
  stok,
  product,
  onWishlistAdded,
}) {
  const imageSrc = Array.isArray(image) ? image[0] : image;
  const safeHarga = Number(harga) || 0;
  const safeDiskon = Number(diskon) || 0;
  const safeRating = Number(rating) || 0;
  const safeStock = Number(stok ?? product?.stok ?? product?.stock ?? 0) || 0;
  const isOutOfStock = safeStock < 1;
  const navigate = useNavigate();
  const { user } = useAuth();
  const { addToCart } = useAddToCart();

  const hasDiskon = safeDiskon > 0;
  const hargaFinal = hasDiskon
    ? safeHarga - (safeHarga * safeDiskon) / 100
    : safeHarga;

  const handleAddToCart = async (e) => {
    e.stopPropagation();

    if (isOutOfStock) {
      toast.error('Stok produk sedang habis');
      return;
    }

    const result = await addToCart({ productId: id, requireAuth: true });

    if (result.ok) {
      toast.success('Berhasil masuk ke keranjang');
    } else if (result.reason !== 'auth_required') {
      toast.error('Gagal masuk ke keranjang');
    }
  };

  const handleAddToWishlist = async (e) => {
    e.stopPropagation();

    if (!user) {
      toast.error('Masuk dulu buat tambah ke wishlist');
      navigate('/auth');
      return;
    }

    try {
      await wishlistService.add(id);
      onWishlistAdded?.(
        product ?? {
          id_produk: id,
          nama_produk: nama,
          harga,
          foto: image,
          diskon,
          rating,
          stok: safeStock,
        },
      );
      toast.success('Berhasil ditambahkan ke wishlist');
    } catch (error) {
      console.error(error);
      toast.error('Gagal menambahkan ke wishlist');
    }
  };

  return (
    <div
      className={`relative group overflow-hidden rounded-sm transition-all duration-500 ${
        isOutOfStock ? 'opacity-80 grayscale-[35%]' : 'hover:scale-105'
      }`}>
      <div className="relative aspect-square overflow-hidden">
        <Link to={`/product/${id}`} className="block w-full h-full">
          <NgrokImage
            src={imageSrc || noImage}
            alt={nama || 'produk'}
            className={`w-full h-full object-cover transition-transform duration-500 ${
              isOutOfStock ? '' : 'group-hover:scale-110'
            }`}
          />
        </Link>

        <div className="absolute top-3 left-3 z-20 flex flex-col gap-2">
          {hasDiskon && !isOutOfStock && (
            <div className="rounded-md bg-primary px-3 py-1 text-xs text-white">
              -{safeDiskon}%
            </div>
          )}

          {isOutOfStock && (
            <div className="inline-flex items-center gap-1 rounded-md bg-gray-900 px-3 py-1 text-xs font-semibold text-white shadow">
              <PackageX size={13} />
              Habis
            </div>
          )}
        </div>

        <div className="absolute top-3 right-3 flex flex-col gap-2 z-20">
          <button
            type="button"
            onClick={handleAddToWishlist}
            className="bg-white p-2 rounded-full shadow hover:bg-gray-200 transition">
            <Heart size={18} />
          </button>
        </div>

        <div className="absolute bottom-0 left-0 w-full translate-y-full group-hover:translate-y-0 transition-transform duration-300 z-20">
          <button
            type="button"
            onClick={handleAddToCart}
            disabled={isOutOfStock}
            className={`w-full py-3 font-semibold text-white transition-all active:scale-[0.98] ${
              isOutOfStock
                ? 'cursor-not-allowed bg-gray-500'
                : 'bg-primary hover:bg-primary-600'
            }`}>
            {isOutOfStock ? 'Stok Habis' : 'Tambah ke Keranjang'}
          </button>
        </div>
      </div>

      <Link
        to={`/product/${id}`}
        className="block pt-4 space-y-2 text-sm md:text-base">
        <h4 className="font-semibold truncate">{nama}</h4>

        <div className="flex flex-wrap items-center justify-between gap-2">
          <div className="flex flex-wrap items-center gap-2">
            <p
              className={`font-semibold ${hasDiskon ? 'text-primary' : 'text-gray-800'}`}>
              Rp {hargaFinal.toLocaleString('id-ID')}
            </p>

            {hasDiskon && (
              <p className="text-gray-400 line-through text-sm">
                Rp {safeHarga.toLocaleString('id-ID')}
              </p>
            )}
          </div>

          <span
            className={`inline-flex items-center gap-1 rounded-full px-2.5 py-1 text-[11px] font-semibold ${
              isOutOfStock
                ? 'bg-rose-50 text-rose-600 ring-1 ring-rose-100'
                : 'bg-emerald-50 text-emerald-700 ring-1 ring-emerald-100'
            }`}>
            {isOutOfStock ? <PackageX size={13} /> : <PackageCheck size={13} />}
            {isOutOfStock ? 'Habis' : `${safeStock} stok`}
          </span>
        </div>

        <div className="flex gap-1">
          {[...Array(safeRating)].map((_, i) => (
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
