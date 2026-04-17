import { Heart, Star } from 'lucide-react';
import { Link, useNavigate } from 'react-router-dom';
import axios from "../../api/axios";
import toast from "react-hot-toast";
import { useAuth } from "../../context/authcontext";
import { useCart } from "../../context/cartcontext";
import { wishlistService } from '../../services/wishlistservice';

export default function ProductCard({
  id,
  nama,
  harga,
  image,
  diskon,
  rating,
}) {

  const imageSrc = Array.isArray(image) ? image[0] : image;
  const safeHarga = Number(harga) || 0;
  const safeDiskon = Number(diskon) || 0;
  const safeRating = Number(rating) || 0;
  const navigate = useNavigate();

  const hasDiskon = safeDiskon > 0;

  const hargaFinal = hasDiskon
    ? safeHarga - (safeHarga * safeDiskon) / 100
    : safeHarga;

  const { token, user } = useAuth();
  const { setCart } = useCart();

  const handleAddToCart = async (e) => {
    e.stopPropagation();

    try {
      const res = await axios.post(
        "http://127.0.0.1:8000/api/cart/add",
        {
          id_produk: id,
          qty: 1,
        },
        {
          headers: {
            Authorization: `Bearer ${token}`,
          },
        }
      );

      setCart((prev) => {
        if (!prev || !prev.items) {
          return res.data.data;
        }

        const existing = prev.items.find(i => i.id_produk === id);

        let newItems;

        if (existing) {
          newItems = prev.items.map(i =>
            i.id_produk === id ? { ...i, qty: i.qty + 1 } : i
          );
        } else {
          newItems = [...prev.items, { id_produk: id, qty: 1 }];
        }

        return {
          ...prev,
          items: newItems,
        };
      });

      toast.success("Berhasil masuk ke keranjang 🛒");
    } catch (error) {
      toast.error("Gagal masuk ke keranjang");
      console.log("ERROR:", error.response?.data || error.message);
    }
  };

  return (
    <div
      className="relative group rounded-sm overflow-hidden 
        transition-all duration-500 hover:scale-105">
      {/* IMAGE WRAPPER */}
      <div className="relative aspect-square overflow-hidden">
        {/* Clickable Area */}
        <Link to={`/product/${id}`} className="block w-full h-full">
          <img
            src={imageSrc || "../assets/no-image.png"}
            alt={nama || "product"}
            loading="lazy"
            className="w-full h-full object-cover transition-transform duration-500 group-hover:scale-110"
          />
        </Link>

        {/* Discount Badge */}
        {hasDiskon && (
          <div className="absolute top-3 left-3 bg-red-700 text-white text-xs px-3 py-1 rounded-md z-20">
            -{diskon}%
          </div>
        )}

        {/* Right Icons */}
        <div className="absolute top-3 right-3 flex flex-col gap-2 z-20">
          <button
            onClick={async (e) => {
              e.stopPropagation();
console.log("ID DIKIRIM:", id);
              if (!user) {
                toast.error("Login dulu buat tambah ke wishlist");
                navigate("/auth");
                return;
              }

              try {
                await wishlistService.add(id);

                toast.success("Berhasil ditambahkan ke wishlist ❤️");
              } catch (error) {
                console.error(error);
                console.log("ERROR ASLI:", error.response?.data);
                toast.error("Gagal menambahkan ke wishlist");
              }
            }}
            className="bg-white p-2 rounded-full shadow hover:bg-gray-200 transition"
          >
            <Heart size={18} />
          </button>
        </div>

        {/* Add To Cart */}
        <div
          className="absolute bottom-0 left-0 w-full 
            translate-y-full group-hover:translate-y-0
            transition-transform duration-300 z-20">

          <button
            onClick={handleAddToCart}
            className="w-full bg-black text-white py-3 font-medium transition-all
             hover:bg-primary
             active:bg-primary-600 active:scale-[0.98]">
            Add to Cart
          </button>

        </div>

      </div>

      {/* PRODUCT INFO */}
      <Link
        to={`/product/${id}`}
        className="block pt-4 space-y-2 text-sm md:text-base">
        <h4 className="font-semibold truncate">{nama}</h4>

        <div className="flex items-center gap-2">
          <p
            className={`font-semibold ${hasDiskon ? 'text-primary' : 'text-gray-800'}`}>
            Rp {hargaFinal.toLocaleString('id-ID')}
          </p>

          {hasDiskon && (
            <p className="text-gray-400 line-through text-sm">
              Rp {harga.toLocaleString('id-ID')}
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
