import { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';
import {
  getProductById,
  getProductsByCategory,
} from '../services/productservice';
import ProductSection from '../components/section/productsection';
import ProductGallerySection from '../components/section/productgallerysection';
import ProductDetailSection from '../components/section/productdetailsection';
import Skeleton from '../components/ui/skeleton';
import { getStorageUrl } from '../utils/appconfig';
import SectionTitle from '../components/ui/sectiontitle';
import noImage from '../assets/no-image.png';

export default function ProductPage() {
  const { id } = useParams();
  const [product, setProduct] = useState(null);
  const [relatedProducts, setRelatedProducts] = useState([]);
  const [visibleCount] = useState(4);
  const [isLoading, setIsLoading] = useState(false);
  const [isRelatedLoading, setIsRelatedLoading] = useState(false);

  useEffect(() => {
    // Otomatis scroll ke posisi paling atas saat halaman detail produk dibuka
    window.scrollTo({ top: 0, left: 0, behavior: 'instant' });

    const fetch = async () => {
      try {
        setIsLoading(true);

        const data = await getProductById(id);
        const currentProductId = Number(data.id_produk);

        // Prioritaskan foto_base64 jika tersedia
        const rawImage =
          data.foto_base64 || (data.foto ? getStorageUrl(data.foto) : noImage);

        const mapped = {
          id: data.id_produk,
          idKategori: data.id_kategori,
          name: data.nama_produk,
          price: Number(data.harga),
          stock: Number(data.stok) || 0,
          description: data.deskripsi,
          images: Array.isArray(rawImage) ? rawImage : [rawImage],
          foto_base64: data.foto_base64,
          foto: data.foto,
        };

        setProduct(mapped);

        if (data.id_kategori) {
          setIsRelatedLoading(true);
          const categoryProducts = await getProductsByCategory(
            data.id_kategori,
          );
          const similarProducts = Array.isArray(categoryProducts)
            ? categoryProducts.filter(
                (item) => Number(item.id_produk) !== currentProductId,
              )
            : [];

          setRelatedProducts(similarProducts);
        } else {
          setRelatedProducts([]);
        }
      } catch (err) {
        console.error(err);
      } finally {
        setIsLoading(false);
        setIsRelatedLoading(false);
      }
    };

    fetch();
  }, [id]);

  if (!product && !isLoading) {
    return <p className="mt-20 text-center">Produk tidak ditemukan</p>;
  }

  return (
    <div className="min-h-screen px-4 py-8 md:px-8 md:py-10 lg:px-16 xl:px-20">
      <div className="mx-auto mb-20 w-full max-w-7xl space-y-10">
        {isLoading ? (
          <div className="space-y-3">
            <Skeleton className="h-10 w-40" />
            <Skeleton className="h-4 w-full max-w-xl" />
          </div>
        ) : (
          <SectionTitle
            eyebrow="Produk"
            title={product?.name || 'Detail Produk'}
            description="Lihat detail produk, stok yang tersedia, dan informasi penting sebelum menambahkannya ke keranjang."
          />
        )}

        <div className="grid gap-12 md:grid-cols-2 lg:gap-20">
          <ProductGallerySection product={product} isLoading={isLoading} />
          <ProductDetailSection product={product} isLoading={isLoading} />
        </div>

        <div className="w-full space-y-5">
          <SectionTitle
            eyebrow="Rekomendasi"
            title="Produk Serupa"
            description="Produk lain dari kategori yang sama untuk membantu kamu membandingkan pilihan."
          />

          <ProductSection
            products={relatedProducts}
            visibleCount={visibleCount}
            isLoading={isRelatedLoading}
          />

          {!isRelatedLoading && relatedProducts.length === 0 ? (
            <div className="rounded-[28px] border border-dashed border-gray-300 px-6 py-12 text-center">
              <p className="text-lg font-semibold text-gray-800">
                Belum ada produk serupa untuk ditampilkan
              </p>
              <p className="mt-2 text-sm text-gray-500">
                Coba lihat kategori lain atau kembali ke halaman utama untuk
                menemukan produk lain yang cocok.
              </p>
            </div>
          ) : null}
        </div>
      </div>
    </div>
  );
}
