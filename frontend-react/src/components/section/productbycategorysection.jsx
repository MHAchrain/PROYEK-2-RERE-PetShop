import { useEffect, useState } from "react";
import { getProductsByCategory } from "../../services/productservice";
import ProductCard from "../ui/productcard";
import Skeleton from "../ui/skeleton";
import { SearchX } from "lucide-react";

export default function ProductSectionByCategory({ categoryId, visibleCount = 8 }) {
  const BASE_URL = "http://127.0.0.1:8000/storage/";
  const [products, setProducts] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    if (!categoryId) return;

    const fetchProducts = async () => {
      try {
        setIsLoading(true);

        const data = await getProductsByCategory(categoryId);
        console.log("API RESULT:", data);

        // 🔥 penting: pastiin array
        setProducts(data?.produks || []);

      } catch (err) {
        console.error("Error fetch category:", err);
        setProducts([]);
      } finally {
        setIsLoading(false);
      }
    };

    fetchProducts();
  }, [categoryId]);

  const displayedProducts = products.slice(0, visibleCount);

  return (
    <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
      {isLoading ? (
        [...Array(visibleCount)].map((_, i) => (
          <Skeleton key={i} className="w-full h-64 rounded-lg" />
        ))
      ) : displayedProducts.length > 0 ? (
        displayedProducts.map((item) => (
          <ProductCard
            key={item.id_produk}
            id={item.id_produk}
            nama={item.nama_produk}
            harga={item.harga}
            image={`${BASE_URL}${item.foto}`}
          />
        ))
      ) : (
          <div className="col-span-full flex flex-col items-center justify-center py-20 bg-gray-50/50">
            <div className="bg-gray-100 p-4 rounded-full mb-4">
              <SearchX size={48} className="text-gray-400" />
            </div>
            <h3 className="text-xl font-semibold text-gray-800">Produk Tidak Ditemukan</h3>
            <p className="text-gray-500 mt-2 max-w-xs text-center">
              Maaf, kami tidak bisa menemukan produk yang Anda cari. Coba gunakan kata kunci lain.
            </p>
          </div>
      )}
    </div>
  );
}