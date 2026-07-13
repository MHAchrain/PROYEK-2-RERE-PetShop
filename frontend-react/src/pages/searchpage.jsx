import ProductSection from '../components/section/productsection';
import { useSearchPage } from '../hooks/usesearchpage';
import SectionTitle from '../components/ui/sectiontitle';

export default function SearchPage() {
  const {
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
          <SectionTitle
            eyebrow="Pencarian"
            title={hasQuery ? `Hasil untuk "${submittedQuery}"` : 'Cari Produk'}
            description={
              isLoading
                ? 'Mencari produk...'
                : hasQuery
                  ? `${results.length} produk ditemukan.`
                  : 'Masukkan kata kunci untuk mulai mencari produk.'
            }
          />

          {errorMessage && (
            <div className="rounded-2xl border border-red-200 bg-red-50 px-5 py-4 text-sm text-red-600">
              {errorMessage}
            </div>
          )}

          {hasQuery && (
            <>
              <ProductSection products={results} isLoading={isLoading} />

              {!isLoading && !hasResults && !errorMessage && (
                <div className="rounded-[28px] border border-dashed border-gray-300 px-6 py-14 text-center">
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
          <SectionTitle
            eyebrow="Rekomendasi"
            title="Pilihan Untuk Kamu"
            description={
              isRecommendedLoading
                ? 'Memuat rekomendasi produk...'
                : 'Produk pilihan yang bisa kamu lihat sambil mencari produk lain.'
            }
          />

          <ProductSection products={recommendedProducts} isLoading={isRecommendedLoading} visibleCount={4} />
        </section>
      </div>
    </div>
  );
}
