import { useState } from 'react';
import { ListBarang } from '../Data';
import HeroSlider from '../components/section/herosection';
import CategorySection from '../components/reusable/categorysection';
import ProductSection from '../components/reusable/productsection';

export default function Home() {
  const [visibleCount, setVisibleCount] = useState(8);
  const [isLoading, setIsLoading] = useState(false);

  const totalProduk = ListBarang.length;
  const isShowingAll = visibleCount === totalProduk;

  const handleClick = () => {
    if (!isShowingAll) {
      setIsLoading(true);

      setTimeout(() => {
        setVisibleCount(totalProduk);
        setIsLoading(false);
      }, 1200);
    } else {
      setVisibleCount(8);
    }
  };

  return (
    <div className="space-y-5 mb-20">
      <HeroSlider />
      <CategorySection />
      <div className="flex justify-center px-4">
        <div className="max-w-6xl w-full space-y-4">
          <div className="flex items-center gap-5">
            <div className="bg-primary w-5 h-10 rounded-sm"></div>
            <p className="text-primary font-semibold">Hari ini</p>
          </div>

          <h2 className="text-2xl font-bold">Rekomendasi</h2>

          <ProductSection visibleCount={visibleCount} isLoading={isLoading} />

          <div className="flex justify-center">
            <button
              onClick={handleClick}
              className="m-10 px-12 py-3 rounded-sm bg-primary text-white hover:bg-primary-700 transition">
              {isShowingAll ? 'Tampilkan Lebih Sedikit' : 'Lihat Semua'}
            </button>
          </div>
        </div>
      </div>
    </div>
  );
}
