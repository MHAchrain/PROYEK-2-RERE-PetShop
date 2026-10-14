import ProductSection from '../components/section/productsection';
import Skeleton from '../components/ui/skeleton';
import WishlistCard from '../components/ui/wishlistcard';
import { useWishlistPage } from '../hooks/usewishlistpage';
import { getStorageUrl } from '../utils/appconfig';
import SectionTitle from '../components/ui/sectiontitle';

export default function WishlistPage() {
  const {
    products,
    wishlistCount,
    isLoading,
    removingId,
    justForYouProducts,
    isRecommendationLoading,
    removeWishlistItem,
    handleAddFromJustForYou,
  } = useWishlistPage();

  return (
    <div className="min-h-screen px-4 py-8 md:px-8 md:py-10 lg:px-16 xl:px-20">
      <div className="mx-auto w-full max-w-7xl space-y-10">
        <SectionTitle
          eyebrow="Favorit"
          title={`Produk Favorit (${wishlistCount})`}
          description="Simpan produk yang ingin kamu lihat lagi nanti, lalu pindahkan ke keranjang saat sudah siap belanja."
        />

        <div className="mt-10">
          {isLoading ? (
            <div className="grid grid-cols-2 gap-6 md:grid-cols-3 lg:grid-cols-4">
              {[...Array(4)].map((_, i) => (
                <Skeleton key={i} className="h-64 w-full rounded-lg" />
              ))}
            </div>
          ) : products.length > 0 ? (
            <div className="grid grid-cols-2 gap-6 md:grid-cols-3 lg:grid-cols-4">
              {products.map((item) => (
                <WishlistCard
                  key={item.id_produk}
                  id={item.id_produk}
                  nama={item.nama_produk}
                  harga={item.harga}
                  image={item.foto_base64 || getStorageUrl(item.foto)}
                  diskon={item.diskon}
                  rating={item.rating}
                  onRemove={removeWishlistItem}
                  onAddedToCart={(productId) =>
                    removeWishlistItem(productId, false)
                  }
                  isRemoving={removingId === item.id_produk}
                />
              ))}
            </div>
          ) : (
            <p className="text-center text-gray-500">
              Belum ada produk favorit. Jelajahi produk kami dan tambahkan item
              yang kamu suka ke daftar ini.
            </p>
          )}
        </div>

        <div className="mt-16 space-y-6">
          <SectionTitle
            eyebrow="Rekomendasi"
            title="Pilihan Untuk Kamu"
            description="Produk yang mungkin cocok berdasarkan item yang sudah kamu simpan."
          />

          <ProductSection
            products={justForYouProducts}
            isLoading={isRecommendationLoading}
            onWishlistAdded={handleAddFromJustForYou}
          />
        </div>
      </div>
    </div>
  );
}
