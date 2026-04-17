import { useState, useEffect } from 'react';
import { getProducts } from '../services/productservice';
import HeroSlider from '../components/section/herosection';
import CategorySection from '../components/section/categorysection';
import ProductSection from '../components/section/productsection';
import LoadMoreButton from '../components/ui/loadmorebutton';

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
        console.error("Gagal load produk:", err);
      } finally {
        setIsLoading(false);
      }
    };
    fetchData();
  }, []);

  const toggleVisible = () => {
    console.log("Tombol diklik!"); // Tambahin ini buat tes
    console.log("Visible saat ini:", visibleCount);
    console.log("Total produk:", products.length);
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
      <div id="today-section" className="flex justify-center px-4">
        <div className="max-w-6xl w-full space-y-4">
          <div className="flex items-center gap-5">
            <div className="bg-primary w-5 h-10 rounded-sm"></div>
            <p className="text-primary font-semibold capitalize">Hari ini</p>
          </div>

          <h2 className="text-2xl font-bold">Rekomendasi</h2>

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
