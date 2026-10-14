import ProductCard from '../ui/productcard';
import Skeleton from '../ui/skeleton';
import { getStorageUrl } from '../../utils/appconfig';

export default function ProductSection({ products = [], isLoading, visibleCount, onWishlistAdded }) {
  const displayedProducts =
    typeof visibleCount === "number" ? products.slice(0, visibleCount) : products;

  return (
    <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">

      {isLoading ? (
        [...Array(8)].map((_, i) => (
          <Skeleton key={i} className="w-full h-64 rounded-lg" />
        ))
      ) : (
        displayedProducts.map((item) => (
          <ProductCard
            key={item.id_produk}
            id={item.id_produk}
            nama={item.nama_produk}
            harga={item.harga}
            image={getStorageUrl(item.foto)}
            diskon={item.diskon}
            rating={item.rating}
            stok={item.stok}
            product={item}
            onWishlistAdded={onWishlistAdded}
          />
        ))
      )}

    </div>
  );
}
