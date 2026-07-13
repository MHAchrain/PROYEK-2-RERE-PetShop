import { Phone, Mail } from 'lucide-react';
import { useEffect, useState } from 'react';
import Skeleton from '../components/ui/skeleton';
import SectionTitle from '../components/ui/sectiontitle';

export default function ContactPage() {
  const [isLoading, setIsLoading] = useState(true);

  useEffect(() => {
    const timer = setTimeout(() => {
      setIsLoading(false);
    }, 2000);
    return () => clearTimeout(timer);
  }, []);

  return (
    <div className="min-h-screen px-4 py-8 md:px-8 md:py-10 lg:px-16 xl:px-20">
      <div className="mx-auto w-full max-w-7xl space-y-8">
        {isLoading ? (
          <div className="space-y-3">
            <Skeleton className="h-10 w-40 bg-gray-200" />
            <Skeleton className="h-4 w-full max-w-2xl bg-gray-200" />
          </div>
        ) : (
          <SectionTitle
            eyebrow="Kontak"
            title="Hubungi Kami"
            description="Kalau ada pertanyaan soal produk, pesanan, atau grooming, tim ReRe Petshop siap membantu dengan jawaban yang cepat dan jelas."
          />
        )}

        <div className="grid grid-cols-1 gap-8 lg:grid-cols-3">
          <div className="h-fit space-y-10 rounded-3xl bg-gray-50 p-8 shadow-sm">
            <div>
              {isLoading ? (
                <div className="mb-4 flex items-center gap-4">
                  <Skeleton className="h-10 w-10 rounded-full bg-gray-200" />
                  <Skeleton className="h-6 w-32 bg-gray-200" />
                </div>
              ) : (
                <div className="mb-4 flex items-center gap-4">
                  <div className="flex h-10 w-10 items-center justify-center rounded-full bg-primary text-white">
                    <Phone size={18} />
                  </div>
                  <h3 className="text-lg font-semibold">Hubungi Kami</h3>
                </div>
              )}

              {isLoading ? (
                <div className="space-y-3">
                  <Skeleton className="h-4 w-full bg-gray-100" />
                  <Skeleton className="h-4 w-3/4 bg-gray-100" />
                </div>
              ) : (
                <>
                  <p className="mb-3 text-sm text-gray-600">
                    Hubungi kami saat jam operasional untuk informasi stok, pesanan, dan layanan grooming.
                  </p>
                  <p className="text-sm font-medium">
                    Nomor Telepon: <span className="text-primary underline">0813-1941-0250</span>
                  </p>
                </>
              )}
            </div>

            <hr />

            <div>
              {isLoading ? (
                <div className="mb-4 flex items-center gap-4">
                  <Skeleton className="h-10 w-10 rounded-full bg-gray-200" />
                  <Skeleton className="h-6 w-40 bg-gray-200" />
                </div>
              ) : (
                <div className="mb-4 flex items-center gap-4">
                  <div className="flex h-10 w-10 items-center justify-center rounded-full bg-primary text-white">
                    <Mail size={18} />
                  </div>
                  <h3 className="text-lg font-semibold">Tulis Kepada Kami</h3>
                </div>
              )}

              {isLoading ? (
                <div className="space-y-3">
                  <Skeleton className="h-4 w-full bg-gray-100" />
                  <Skeleton className="h-4 w-1/2 bg-gray-100" />
                </div>
              ) : (
                <>
                  <p className="mb-3 text-sm text-gray-600">
                    Isi formulir berikut dan kami akan menghubungi kamu kembali secepat mungkin.
                  </p>
                  <div className="space-y-2">
                    <p className="text-sm">Email Utama: <span className="font-medium">rereps@gmail.com</span></p>
                    <p className="text-sm">Alamat Toko: <span className="font-medium">Jl. Kecubung 1 No.14, Tangerang</span></p>
                  </div>
                </>
              )}
            </div>
          </div>

          <div className="rounded-3xl bg-gray-50 p-8 shadow-sm lg:col-span-2">
            {isLoading ? (
              <div className="space-y-6">
                <div className="grid grid-cols-1 gap-4 md:grid-cols-3">
                  <Skeleton className="h-12 w-full rounded-md bg-gray-100" />
                  <Skeleton className="h-12 w-full rounded-md bg-gray-100" />
                  <Skeleton className="h-12 w-full rounded-md bg-gray-100" />
                </div>
                <Skeleton className="h-40 w-full rounded-md bg-gray-100" />
                <div className="flex justify-end">
                  <Skeleton className="h-12 w-40 rounded-md bg-gray-100" />
                </div>
              </div>
            ) : (
              <form action="" className="space-y-6">
                <div className="grid grid-cols-1 gap-4 md:grid-cols-3">
                  <input
                    type="text"
                    placeholder="Masukkan nama"
                    className="rounded-2xl border border-gray-200 bg-gray-100 px-4 py-3 outline-none focus:ring-2 focus:ring-primary"
                  />

                  <input
                    type="email"
                    placeholder="Masukkan email"
                    className="rounded-2xl border border-gray-200 bg-gray-100 px-4 py-3 outline-none focus:ring-2 focus:ring-primary"
                  />

                  <input
                    type="number"
                    placeholder="Masukkan nomor telepon"
                    className="rounded-2xl border border-gray-200 bg-gray-100 px-4 py-3 outline-none focus:ring-2 focus:ring-primary"
                  />
                </div>

                <textarea
                  rows="6"
                  placeholder="Masukkan pesan kamu di sini"
                  className="w-full resize-none rounded-2xl border border-gray-200 bg-gray-100 px-4 py-3 outline-none focus:ring-2 focus:ring-primary"
                ></textarea>

                <div className="flex justify-end">
                  <button type="submit" className="rounded-2xl bg-primary px-8 py-3 text-white transition hover:bg-primary-600">
                    Kirim Pesan
                  </button>
                </div>
              </form>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
