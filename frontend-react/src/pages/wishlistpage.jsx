import ProductSection from "../components/section/productsection";
import Skeleton from "../components/ui/skeleton";
import WishlistCard from "../components/ui/wishlistcard";
import { useWishlistPage } from "../hooks/usewishlistpage";

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
    <div className="min-h-screen flex flex-col my-15 mx-20">
      <div className="flex items-center gap-5">
        <div className="bg-primary w-5 h-10 rounded-sm"></div>
        <p className="text-primary font-semibold">Produk Favorit ({wishlistCount})</p>
      </div>

      <div className="mt-10">
        {isLoading ? (
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
            {[...Array(4)].map((_, i) => (
              <Skeleton key={i} className="w-full h-64 rounded-lg" />
            ))}
          </div>
        ) : products.length > 0 ? (
          <div className="grid grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-6">
            {products.map((item) => (
              <WishlistCard
                key={item.id_produk}
                id={item.id_produk}
                nama={item.nama_produk}
                harga={item.harga}
                image={item.foto ? `http://127.0.0.1:8000/storage/${item.foto}` : ""}
                diskon={item.diskon}
                rating={item.rating}
                onRemove={removeWishlistItem}
                onAddedToCart={(productId) => removeWishlistItem(productId, false)}
                isRemoving={removingId === item.id_produk}
              />
            ))}
          </div>
        ) : (
          <p className="text-gray-500 text-center">
            Belum ada produk favorit. Jelajahi produk kami dan tambahkan ke favoritmu!
          </p>
        )}
      </div>

      <div className="mt-16 space-y-6">
        <div className="flex items-center gap-5">
          <div className="bg-black w-5 h-10 rounded-sm"></div>
          <p className="font-semibold text-gray-900">Just For You</p>
        </div>

        <ProductSection
          products={justForYouProducts}
          isLoading={isRecommendationLoading}
          onWishlistAdded={handleAddFromJustForYou}
        />
      </div>
    </div>
  );
}
