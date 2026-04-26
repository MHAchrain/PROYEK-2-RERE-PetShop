import { Trash2, Star } from "lucide-react";
import { Link } from "react-router-dom";
import toast from "../../utils/toast.jsx";
import { useAddToCart } from "../../hooks/useaddtocart";
import noImage from "../../assets/no-image.png";

export default function WishlistCard({
  id,
  nama,
  harga,
  image,
  diskon,
  rating,
  onRemove,
  onAddedToCart,
  isRemoving = false,
}) {
  const safeHarga = Number(harga) || 0;
  const safeDiskon = Number(diskon) || 0;
  const safeRating = Number(rating) || 0;
  const { addToCart } = useAddToCart();
  const hasDiskon = safeDiskon > 0;
  const hargaFinal = hasDiskon
    ? safeHarga - (safeHarga * safeDiskon) / 100
    : safeHarga;

  const handleAddToCart = async (e) => {
    e.stopPropagation();

    const result = await addToCart({
      productId: id,
      requireAuth: true,
      onSuccess: async () => onAddedToCart?.(id),
    });

    if (result.ok) {
      toast.success("Berhasil masuk ke keranjang");
    } else if (result.reason !== "auth_required") {
      toast.error("Gagal masuk ke keranjang");
    }
  };

  return (
    <div className="relative group rounded-sm overflow-hidden transition-all duration-500 hover:scale-105">
      <div className="relative aspect-square overflow-hidden">
        {hasDiskon && (
          <div className="absolute top-3 left-3 z-20 rounded-md bg-primary px-3 py-1 text-xs text-white">
            -{safeDiskon}%
          </div>
        )}

        <div className="absolute top-3 right-3 flex flex-col gap-2 z-20">
          <button
            type="button"
            onClick={(e) => {
              e.stopPropagation();
              onRemove?.(id);
            }}
            disabled={isRemoving}
            className="bg-white p-2 rounded-full shadow hover:bg-gray-200 transition disabled:cursor-not-allowed disabled:opacity-60"
          >
            <Trash2 size={18} className="text-red-500" />
          </button>
        </div>

        <Link to={`/product/${id}`} className="block w-full h-full">
          <img
            src={image || noImage}
            alt={nama || "product"}
            loading="lazy"
            onError={(event) => {
              event.currentTarget.onerror = null;
              event.currentTarget.src = noImage;
            }}
            className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
          />
        </Link>

        <div className="absolute bottom-0 left-0 w-full translate-y-full group-hover:translate-y-0 transition-transform duration-300 z-20">
          <button
            type="button"
            onClick={handleAddToCart}
            className="w-full bg-primary py-3 font-medium text-white transition-all hover:bg-primary-600 active:scale-[0.98]"
          >
            Tambah ke Keranjang
          </button>
        </div>
      </div>

      <Link to={`/product/${id}`} className="block pt-4 space-y-2 text-sm md:text-base">
        <h4 className="font-semibold truncate">{nama}</h4>

        <div className="flex items-center gap-2">
          <p className={`font-semibold ${hasDiskon ? "text-primary" : "text-gray-800"}`}>
            Rp {hargaFinal.toLocaleString("id-ID")}
          </p>

          {hasDiskon && (
            <p className="text-gray-400 line-through text-sm">
              Rp {safeHarga.toLocaleString("id-ID")}
            </p>
          )}
        </div>

        <div className="flex gap-1">
          {[...Array(safeRating)].map((_, i) => (
            <Star key={i} size={16} className="fill-yellow-400 text-yellow-400" />
          ))}
        </div>
      </Link>
    </div>
  );
}
