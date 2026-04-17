import ProductCard from "../ui/productcard";
import Skeleton from "../ui/skeleton";
import { SearchX } from "lucide-react";
import { getStorageUrl } from "../../utils/appconfig";

export default function ProductSectionByCategory({ products = [], isLoading }) {
  return (
    <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
      {isLoading ? (
        [...Array(8)].map((_, i) => (
          <Skeleton key={i} className="w-full h-64 rounded-lg" />
        ))
      ) : products.length > 0 ? (
        products.map((item) => (
          <ProductCard
            key={item.id_produk}
            id={item.id_produk}
            nama={item.nama_produk}
            harga={item.harga}
            image={getStorageUrl(item.foto)}
            products={item}
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
