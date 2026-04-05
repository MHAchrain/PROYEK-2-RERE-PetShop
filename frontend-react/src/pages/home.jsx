<<<<<<< HEAD
import { useEffect, useState } from 'react';
import HeroSlider from '../components/section/heroslider';
=======
import { useState } from 'react';
import { ListBarang } from '../Data';
import HeroSlider from '../components/section/herosection';
>>>>>>> dev
import CategorySection from '../components/reusable/categorysection';
import ProductSection from '../components/reusable/productsection';

export default function Home() {
<<<<<<< HEAD
  const [produk, setProduk] = useState([]);
  const [visibleCount, setVisibleCount] = useState(4);
=======
  const [visibleCount, setVisibleCount] = useState(8);
>>>>>>> dev
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    fetch('http://127.0.0.1:8000/api/produk', {
      headers: {
        Accept: 'application/json',
      },
    })
      .then((res) => res.json())
      .then((data) => {
        setProduk(data.data ?? data);
      })
      .catch((err) => {
        console.error('Gagal ambil produk:', err);
      });
  }, []);

  const totalProduk = produk.length;
  const isShowingAll = visibleCount >= totalProduk && totalProduk > 0;

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

          <ProductSection
            products={produk}
            visibleCount={visibleCount}
            isLoading={isLoading}
          />

          {/* <div className="flex justify-center">
            <button
              onClick={handleClick}
              className="m-10 px-12 py-3 rounded-sm bg-primary text-white hover:bg-primary-700 transition">
              {isShowingAll ? 'Tampilkan Lebih Sedikit' : 'Lihat Semua'}
            </button>
          </div> */}
        </div>
      </div>
    </div>
  );
}
