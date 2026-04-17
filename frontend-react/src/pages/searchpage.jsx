import ProductSection from "../components/section/productsection";
import { useSearchPage } from "../hooks/usesearchpage";

export default function SearchPage() {
  const {
    searchInput,
    setSearchInput,
    submitSearch,
    submittedQuery,
    results,
    recommendedProducts,
    isLoading,
    isRecommendedLoading,
    errorMessage,
  } = useSearchPage();

  const hasQuery = Boolean(submittedQuery);
  const hasResults = results.length > 0;

  return (
    <div className="min-h-screen px-4 py-10 md:px-10 lg:px-20">
      <div className="mx-auto space-y-10">

        <section className="space-y-5">
          <div className="flex items-center gap-5 mb-16">
            <div className="bg-primary w-5 h-10 rounded-sm"></div>
            {isLoading ? (
              <div className="space-y-0">
                <p className="text-primary font-bold text-xl capitalize">Hasil pencarian untuk "{submittedQuery}"</p>
                <p className="text-sm text-gray-500">Mencari produk...</p>
              </div>
            ) : (
              <div className="space-y-0">
                <p className="text-primary font-bold text-xl capitalize">
                  {hasQuery ? `Hasil pencarian untuk "${submittedQuery}"` : 'Hasil pencarian untuk ""'}
                </p>
                <p className="text-sm text-gray-500">
                  {hasQuery
                    ? `${results.length} produk ditemukan`
                    : "Masukkan kata kunci untuk mulai mencari produk."}
                </p>
              </div>
            )}
          </div>

          {errorMessage && (
            <div className="rounded-2xl border border-red-200 bg-red-50 px-5 py-4 text-sm text-red-600">
              {errorMessage}
            </div>
          )}

          {hasQuery && (
            <>
              <ProductSection products={results} isLoading={isLoading} />

              {!isLoading && !hasResults && !errorMessage && (
                <div className="rounded-3xl border border-dashed border-gray-300 px-6 py-14 text-center">
                  <p className="text-lg font-semibold text-gray-800">
                    Produk untuk kata kunci "{submittedQuery}" belum ditemukan
                  </p>
                  <p className="mt-2 text-sm text-gray-500">
                    Coba gunakan nama produk yang lebih singkat atau kata kunci yang berbeda.
                  </p>
                </div>
              )}
            </>
          )}
        </section>

        <section className="space-y-5">
          <div className="flex items-center gap-5 mb-16">
            <div className="bg-black w-5 h-10 rounded-sm"></div>
            {isRecommendedLoading ? (
              <div className="space-y-0">
                <p className="text-black font-bold text-xl capitalize">Rekomendasi untuk Kamu</p>
                <p className="text-sm text-gray-500">Memuat rekomendasi produk...</p>
              </div>
            ) : (
              <div className="space-y-0">
                <p className="text-black font-bold text-xl capitalize">Rekomendasi untuk Kamu</p>
                <p className="text-sm text-gray-500">
                  Produk pilihan yang bisa kamu lihat sambil mencari produk lain.
                </p>
              </div>
            )}
          </div>

          <ProductSection
            products={recommendedProducts}
            isLoading={isRecommendedLoading}
            visibleCount={4}
          />
        </section>
      </div>
    </div>
  );
}
