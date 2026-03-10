import { ListBarang } from '../../Data';
import ProductCard from './productcard';

export default function ProductSection({ visibleCount, isLoading }) {
  const displayedProducts = ListBarang.slice(0, visibleCount);

  return (
    <div className="grid grid-cols-2 md:grid-cols-3 md:max-w- lg:grid-cols-4 gap-6">
      {displayedProducts.map((item) => (
        <ProductCard key={item.id} {...item} />
      ))}
      {/* Loading skeleton */}
      {isLoading &&
        Array.from({ length: 4 }).map((_, i) => (
          <div key={i} className="animate-pulse bg-gray-200 h-64 rounded-lg" />
        ))}
    </div>
  );
}
