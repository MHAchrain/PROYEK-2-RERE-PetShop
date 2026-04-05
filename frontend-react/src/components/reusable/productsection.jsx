import ProductCard from './productcard';

export default function ProductSection({
  products = [],
  visibleCount = 4,
  isLoading = false,
}) {
  const displayedProducts = Array.isArray(products)
    ? products.slice(0, visibleCount)
    : [];

  return (
    <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
      {displayedProducts.map((item) => (
        <ProductCard
          key={item.id_produk}
          id={item.id_produk}
          nama={item.nama_produk}
          harga={item.harga}
          foto={item.foto}
          diskon={0}
          rating={5}
        />
      ))}

      {isLoading &&
        Array.from({ length: 4 }).map((_, i) => (
          <div key={i} className="animate-pulse bg-gray-200 h-64 rounded-lg" />
        ))}
    </div>
  );
}
