import { useState, useEffect } from 'react';
import { getProducts } from '../services/productservice';
import HeroSlider from '../components/section/herosection';
import CategorySection from '../components/section/categorysection';
import ProductSection from '../components/section/productsection';
import LoadMoreButton from '../components/ui/loadmorebutton';
import SectionTitle from '../components/ui/sectiontitle';

export default function Home() {
  const [products, setProducts] = useState([]);
  const [visibleCount, setVisibleCount] = useState(8);
  const [isLoading, setIsLoading] = useState(true);
  const [isBtnLoading, setIsBtnLoading] = useState(false);

  useEffect(() => {
    const fetchData = async () => {
      try {
        const data = await getProducts();
        setProducts(Array.isArray(data) ? data : []);
      } catch (err) {
        console.error('Gagal load produk:', err);
      } finally {
        setIsLoading(false);
      }
    };
    fetchData();
  }, []);

  const toggleVisible = () => {
    if (visibleCount < products.length) {
      setIsBtnLoading(true);
      setTimeout(() => {
        setVisibleCount(products.length);
        setIsBtnLoading(false);
      }, 800);
    } else {
      setVisibleCount(8);
      document.getElementById('today-section')?.scrollIntoView({ behavior: 'smooth' });
    }
  };

  return (
    <div className="min-h-screen space-y-10">
      <HeroSlider />
      <CategorySection />
      <div id="today-section" className="px-4 py-4 md:px-8 lg:px-16 xl:px-20">
        <div className="mx-auto w-full max-w-7xl space-y-6">
          <SectionTitle
            eyebrow="Pilihan Hari Ini"
            title="Rekomendasi Produk"
            description="Produk pilihan untuk kebutuhan harian anabul, mulai dari pakan, vitamin, sampai perlengkapan favorit."
          />

          <ProductSection products={products.slice(0, visibleCount)} isLoading={isLoading} />

          <LoadMoreButton
            onClick={toggleVisible}
            isLoading={isBtnLoading}
            isShowingAll={visibleCount >= (products?.length || 0)}
            totalData={products?.length || 0}
          />
        </div>
      </div>
    </div>
  );
}
