import { useParams } from 'react-router-dom';
import { useEffect, useState } from 'react';
import { getCategoriesById } from '../services/categoryservice';
import { getProductsByCategory } from '../services/productservice';
import ProductSectionByCategory from '../components/section/productbycategorysection';
import NotFoundPage from './notfoundpage';
import Skeleton from '../components/ui/skeleton';
import LoadMoreButton from '../components/ui/loadmorebutton';
import SectionTitle from '../components/ui/sectiontitle';

export default function CategoryPage() {
  const { id } = useParams();

  const [products, setProducts] = useState([]);
  const [category, setCategory] = useState(null);
  const [isLoading, setIsLoading] = useState(true);
  const [notFound, setNotFound] = useState(false);
  const [visibleCount, setVisibleCount] = useState(8);
  const [isBtnLoading, setIsBtnLoading] = useState(false);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setIsLoading(true);
        const [categoryData, productsData] = await Promise.all([
          getCategoriesById(id),
          getProductsByCategory(id),
        ]);

        setCategory(categoryData);
        setProducts(productsData);
      } catch (err) {
        console.error(err);
        setNotFound(true);
      } finally {
        setIsLoading(false);
      }
    };
    fetchData();
    setVisibleCount(8);
  }, [id]);

  const toggleVisible = () => {
    if (visibleCount < products.length) {
      setIsBtnLoading(true);
      setTimeout(() => {
        setVisibleCount(products.length);
        setIsBtnLoading(false);
      }, 800);
    } else {
      setVisibleCount(8);
      window.scrollTo({ top: 500, behavior: 'smooth' });
    }
  };

  if (notFound) {
    return <NotFoundPage />;
  }

  return (
    <div className="min-h-screen px-4 py-8 md:px-8 md:py-10 lg:px-16 xl:px-20">
      <div className="mx-auto w-full max-w-7xl space-y-6">
        {isLoading ? (
          <div className="space-y-3">
            <Skeleton className="h-10 w-40" />
            <Skeleton className="h-4 w-full max-w-xl" />
          </div>
        ) : (
          <SectionTitle
            eyebrow="Kategori"
            title={category?.nama_kategori || 'Produk Kategori'}
            description="Jelajahi pilihan produk yang sudah kami kelompokkan supaya lebih cepat menemukan kebutuhan anabul."
          />
        )}

        <ProductSectionByCategory products={products.slice(0, visibleCount)} isLoading={isLoading} />

        <LoadMoreButton
          onClick={toggleVisible}
          isLoading={isBtnLoading}
          isShowingAll={visibleCount >= products.length}
          totalData={products.length}
        />
      </div>
    </div>
  );
}
