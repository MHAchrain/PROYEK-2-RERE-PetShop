import { Statistic, BenefitList, branchList } from '../Data';
import examp from '../assets/dummy.png';
import { ArrowLeft, ArrowRight, Clock3, MapPin, Phone, Store } from 'lucide-react';
import { useEffect, useState } from 'react';
import Skeleton from '../components/ui/skeleton';
import SectionTitle from '../components/ui/sectiontitle';

export default function AboutPage() {
  const [isLoading, setIsLoading] = useState(true);
  const [currentBranchPage, setCurrentBranchPage] = useState(0);
  const [branchesPerPage, setBranchesPerPage] = useState(3);

  const branchPageCount = Math.ceil(branchList.length / branchesPerPage);
  const visibleBranches = branchList.slice(
    currentBranchPage * branchesPerPage,
    currentBranchPage * branchesPerPage + branchesPerPage
  );

  useEffect(() => {
    const timer = setTimeout(() => {
      setIsLoading(false);
    }, 2000);
    return () => clearTimeout(timer);
  }, []);

  useEffect(() => {
    if (currentBranchPage > branchPageCount - 1) {
      setCurrentBranchPage(0);
    }
  }, [branchPageCount, currentBranchPage]);

  useEffect(() => {
    const updateBranchesPerPage = () => {
      if (window.innerWidth < 768) {
        setBranchesPerPage(1);
        return;
      }

      if (window.innerWidth < 1280) {
        setBranchesPerPage(2);
        return;
      }

      setBranchesPerPage(3);
    };

    updateBranchesPerPage();
    window.addEventListener('resize', updateBranchesPerPage);

    return () => window.removeEventListener('resize', updateBranchesPerPage);
  }, []);

  return (
    <div className="min-h-screen px-4 py-8 md:px-8 md:py-10 lg:px-16 xl:px-20">
      <div className="mx-auto w-full max-w-7xl space-y-12">
        {isLoading ? (
          <div className="space-y-3">
            <Skeleton className="h-10 w-56" />
            <Skeleton className="h-4 w-full max-w-2xl" />
            <Skeleton className="h-4 w-full max-w-xl" />
          </div>
        ) : (
          <SectionTitle
            eyebrow="Tentang ReRe Petshop"
            title="Cerita Kami"
            description="Kami membangun pengalaman belanja pet shop yang terasa hangat, mudah dipahami, dan membantu pemilik hewan menemukan kebutuhan terbaik dalam satu tempat."
          />
        )}

        <div className="flex flex-col items-center gap-10 lg:flex-row lg:gap-16">
          <div className="w-full flex-1 space-y-6">
            {isLoading ? (
              <div className="space-y-4">
                <Skeleton className="h-12 w-1/2 bg-gray-200" />
                <Skeleton className="h-4 w-full bg-gray-200" />
                <Skeleton className="h-4 w-full bg-gray-200" />
                <Skeleton className="h-4 w-3/4 bg-gray-200" />
              </div>
            ) : (
              <>
                <h1 className="text-4xl font-bold text-gray-900 sm:text-5xl">Kenapa kami memulainya</h1>
                <p className="leading-relaxed text-gray-600">
                  Berawal dari kecintaan kami terhadap hewan peliharaan, kami menyadari bahwa menemukan produk dan layanan terbaik untuk mereka tidak selalu mudah. Banyak pemilik hewan harus mencari ke berbagai tempat hanya untuk memastikan kebutuhan si kesayangan terpenuhi.
                </p>
                <p className="leading-relaxed text-gray-600">
                  Dari situlah platform ini lahir, untuk menghadirkan kemudahan dalam satu genggaman. Kami menghubungkan para pecinta hewan dengan petshop terpercaya di sekitar mereka, menyediakan akses ke makanan berkualitas, vitamin, perlengkapan, hingga layanan grooming profesional.
                </p>
                <p className="text-gray-600">
                  Karena bagi kami, hewan peliharaan bukan sekadar teman. Mereka adalah keluarga yang pantas mendapatkan perhatian dan kasih sayang terbaik setiap hari.
                </p>
              </>
            )}
          </div>

          <div className="w-full flex-1">
            {isLoading ? (
              <Skeleton className="h-[28rem] w-full rounded-3xl bg-gray-200 animate-pulse" />
            ) : (
              <div className="relative group">
                <img src={examp} alt="Tentang ReRe Petshop" className="h-[28rem] w-full rounded-3xl object-cover shadow-2xl" />
              </div>
            )}
          </div>
        </div>

        <div className="grid grid-cols-1 gap-6 md:grid-cols-4">
          {isLoading
            ? [...Array(4)].map((_, i) => (
                <div key={i} className="rounded-3xl border border-gray-300 p-8 text-center">
                  <Skeleton className="mx-auto mb-4 h-16 w-16 rounded-full" />
                  <Skeleton className="mx-auto mb-2 h-6 w-1/2" />
                  <Skeleton className="mx-auto h-4 w-2/3" />
                </div>
              ))
            : Statistic.map((item) => {
                const Icon = item.icon;
                return (
                  <div
                    key={item.id}
                    className="group rounded-3xl border border-gray-200 bg-white p-8 text-center transition-all duration-150 hover:-translate-y-1 hover:border-primary/20 hover:bg-primary hover:text-white hover:shadow-lg"
                  >
                    <div className="mx-auto mb-4 flex h-16 w-16 items-center justify-center rounded-full bg-gray-300 transition-all duration-300 group-hover:bg-white/30">
                      <div className="flex h-12 w-12 items-center justify-center rounded-full bg-primary text-white transition-all duration-300 group-hover:bg-white group-hover:text-primary">
                        <Icon size={22} />
                      </div>
                    </div>

                    <h2 className="text-3xl font-bold">{item.value}</h2>
                    <p className="mt-2 text-sm">{item.label}</p>
                  </div>
                );
              })}
        </div>

        <div className="space-y-6">
          <SectionTitle
            eyebrow="Cabang Kami"
            title="Beberapa lokasi ReRe Petshop"
            description="Kami hadir di beberapa titik untuk memudahkan pelanggan menemukan produk, layanan grooming, dan bantuan belanja yang lebih dekat."
          />

          {!isLoading && branchList.length > branchesPerPage ? (
            <div className="flex flex-col gap-4 rounded-3xl border border-primary/10 bg-primary/5 p-4 sm:p-5">
              <div>
                <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary/70">Navigasi Cabang</p>
                <p className="mt-2 text-sm leading-relaxed text-gray-600">
                  Menampilkan {visibleBranches.length} cabang dari total {branchList.length} lokasi. Di HP ditampilkan satu per halaman
                  supaya alamat dan tombol arah lebih mudah dibaca dan ditekan.
                </p>
              </div>

              <div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between">
                <div className="rounded-full border border-primary/15 bg-white px-4 py-2 text-center text-sm font-semibold text-gray-700 sm:text-left">
                  Halaman {currentBranchPage + 1} dari {branchPageCount}
                </div>

                <div className="grid grid-cols-2 gap-2 sm:flex sm:items-center">
                  <button
                    type="button"
                    onClick={() => setCurrentBranchPage((prev) => (prev === 0 ? branchPageCount - 1 : prev - 1))}
                    className="inline-flex min-h-11 items-center justify-center gap-2 rounded-2xl border border-primary/15 bg-white px-4 text-sm font-semibold text-gray-700 shadow-sm transition hover:border-primary/30 hover:text-primary"
                    aria-label="Halaman cabang sebelumnya"
                  >
                    <ArrowLeft size={18} />
                    Sebelumnya
                  </button>

                  <button
                    type="button"
                    onClick={() => setCurrentBranchPage((prev) => (prev === branchPageCount - 1 ? 0 : prev + 1))}
                    className="inline-flex min-h-11 items-center justify-center gap-2 rounded-2xl border border-primary/15 bg-white px-4 text-sm font-semibold text-gray-700 shadow-sm transition hover:border-primary/30 hover:text-primary"
                    aria-label="Halaman cabang berikutnya"
                  >
                    Berikutnya
                    <ArrowRight size={18} />
                  </button>
                </div>
              </div>
            </div>
          ) : null}

          <div className="grid grid-cols-1 gap-6 md:grid-cols-2 xl:grid-cols-3">
            {isLoading
              ? [...Array(3)].map((_, i) => (
                  <div key={i} className="rounded-3xl border border-gray-200 bg-white p-6 shadow-sm">
                    <Skeleton className="h-12 w-12 rounded-2xl" />
                    <Skeleton className="mt-6 h-6 w-2/3" />
                    <Skeleton className="mt-3 h-4 w-full" />
                    <Skeleton className="mt-2 h-4 w-5/6" />
                    <Skeleton className="mt-6 h-20 w-full rounded-2xl" />
                  </div>
                ))
              : visibleBranches.map((branch) => (
                  <div
                    key={branch.id}
                    className="group rounded-3xl border border-gray-200 bg-white p-5 shadow-sm transition-all duration-200 hover:-translate-y-1 hover:border-primary/20 hover:shadow-lg sm:p-6"
                  >
                    <div className="flex h-14 w-14 items-center justify-center rounded-2xl bg-primary/10 text-primary">
                      <Store size={26} />
                    </div>

                    <h3 className="mt-5 text-lg font-semibold text-gray-900 sm:mt-6 sm:text-xl">{branch.name}</h3>
                    <p className="mt-2 text-sm leading-relaxed text-gray-500">{branch.note}</p>

                    <div className="mt-5 space-y-4 rounded-2xl border border-gray-100 bg-gray-50/80 p-4 sm:mt-6">
                      <div className="flex items-start gap-3">
                        <span className="mt-0.5 rounded-xl bg-primary/10 p-2 text-primary">
                          <MapPin size={16} />
                        </span>
                        <div>
                          <p className="text-xs font-semibold uppercase tracking-[0.16em] text-gray-400">Alamat</p>
                          <p className="mt-1 text-sm font-medium text-gray-700">{branch.address}</p>
                        </div>
                      </div>

                      <div className="flex items-start gap-3">
                        <span className="mt-0.5 rounded-xl bg-primary/10 p-2 text-primary">
                          <Clock3 size={16} />
                        </span>
                        <div>
                          <p className="text-xs font-semibold uppercase tracking-[0.16em] text-gray-400">Jam Operasional</p>
                          <p className="mt-1 text-sm font-medium text-gray-700">{branch.hours}</p>
                        </div>
                      </div>

                      <div className="flex items-start gap-3">
                        <span className="mt-0.5 rounded-xl bg-primary/10 p-2 text-primary">
                          <Phone size={16} />
                        </span>
                        <div>
                          <p className="text-xs font-semibold uppercase tracking-[0.16em] text-gray-400">Kontak</p>
                          <p className="mt-1 text-sm font-medium text-gray-700">{branch.phone}</p>
                        </div>
                      </div>
                    </div>

                    <a
                      href={branch.href || `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(branch.address)}`}
                      target="_blank"
                      rel="noreferrer"
                      className="mt-5 inline-flex min-h-11 w-full items-center justify-center gap-2 rounded-2xl bg-primary px-4 py-3 text-sm font-semibold text-white transition hover:bg-primary/90 sm:mt-6"
                    >
                      <MapPin size={16} />
                      Buka di Google Maps
                    </a>
                  </div>
                ))}
          </div>

          {!isLoading && branchList.length > branchesPerPage ? (
            <div className="flex flex-wrap justify-center gap-2">
              {Array.from({ length: branchPageCount }).map((_, index) => (
                <button
                  key={index}
                  type="button"
                  onClick={() => setCurrentBranchPage(index)}
                  aria-label={`Pindah ke halaman cabang ${index + 1}`}
                  className={`h-2.5 rounded-full transition-all ${
                    index === currentBranchPage ? 'w-8 bg-primary' : 'w-2.5 bg-primary/25 hover:bg-primary/50'
                  }`}
                />
              ))}
            </div>
          ) : null}
        </div>

        <div className="space-y-6">
          <SectionTitle
            eyebrow="Nilai Kami"
            title="Kenapa pelanggan nyaman bersama kami"
            description="Kami ingin tampil konsisten bukan hanya secara visual, tapi juga dalam layanan, kualitas produk, dan komunikasi."
          />

          <div className="grid grid-cols-1 gap-10 text-center md:grid-cols-3">
            {isLoading
              ? [...Array(3)].map((_, i) => (
                  <div key={i} className="space-y-4">
                    <Skeleton className="mx-auto h-16 w-16 rounded-full" />
                    <Skeleton className="mx-auto h-5 w-1/2" />
                    <Skeleton className="mx-auto h-4 w-3/4" />
                  </div>
                ))
              : BenefitList.map((item) => {
                  const Icon = item.icon;
                  return (
                    <div key={item.id} className="space-y-4 rounded-3xl border border-gray-200 bg-white px-6 py-8 text-center shadow-sm">
                      <div className="mx-auto flex h-16 w-16 items-center justify-center rounded-full bg-gray-300">
                        <div className="flex h-12 w-12 items-center justify-center rounded-full bg-primary text-white">
                          <Icon size={24} />
                        </div>
                      </div>

                      <h4 className="text-lg font-bold">{item.title}</h4>
                      <p className="text-sm text-gray-500">{item.desc}</p>
                    </div>
                  );
                })}
          </div>
        </div>
      </div>
    </div>
  );
}
