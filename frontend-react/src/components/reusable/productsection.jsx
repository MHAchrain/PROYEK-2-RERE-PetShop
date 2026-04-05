import { useEffect, useState } from 'react';
import { getProducts } from '../../services/productservice';
import ProductCard from './productcard';

export default function ProductSection({ visibleCount = 8 }) {
  // 1. Pastikan BASE_URL mengarah ke folder storage
  const BASE_URL = 'http://127.0.0.1:8000/storage/';
  const [products, setProducts] = useState([]);
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const fetchProducts = async () => {
      try {
        setIsLoading(true);
        const data = await getProducts();
        // 2. Gunakan data.data karena Laravel membungkusnya dalam objek
        setProducts(data.data ?? data);
      } catch (err) {
        console.error(err);
      } finally {
        setIsLoading(false);
      }
    };
    fetchProducts();
  }, []);

  const displayedProducts = Array.isArray(products)
    ? products.slice(0, visibleCount)
    : [];

  return (
    <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
      {isLoading ? (
        <p>Loading...</p>
      ) : (
        displayedProducts.map((item) => (
          <ProductCard
            key={item.id_produk || item.id}
            id={item.id_produk || item.id}
            nama={item.nama_produk}
            harga={item.harga}
            // 3. Gabungkan URL dengan kolom 'foto' dari database
            image={
              item.foto
                ? `${BASE_URL}${item.foto}`
                : 'https://via.placeholder.com/150'
            }
          />
        ))
      )}
    </div>
  );
}
