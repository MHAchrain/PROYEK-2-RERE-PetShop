import { getProducts } from '../../services/productservice';
import { useEffect, useState } from 'react';
import ProductCard from '../ui/productcard';
import Skeleton from '../ui/skeleton';

export default function ProductSection({ visibleCount = 8 }) {
  const BASE_URL = "http://127.0.0.1:8000/storage/";
  const [products, setProducts] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        setIsLoading(true);

        const data = await getProducts();
        setProducts(data);

      } catch (err) {
        console.error(err);
      } finally {
        setIsLoading(false);
      }
    };

    fetchProducts();
  }, []);

  const displayedProducts = products.slice(0, visibleCount);

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
            image={`${BASE_URL}${item.foto}`}
          />
        ))
      )}

    </div>
  );
}