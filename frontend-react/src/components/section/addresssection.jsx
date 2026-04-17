import { Home, MapPinned, NotebookPen, Phone, X } from "lucide-react";
import { useAuth } from "../../context/authcontext";
import { useAddressSection } from "../../hooks/useaddresssection";

export default function AddressSection() {
  const { user, updateUser } = useAuth();
  const {
    pelanggan,
    isModalOpen,
    setIsModalOpen,
    loading,
    alamatInput,
    setAlamatInput,
    handleUpdateAlamat,
  } = useAddressSection({ user, updateUser });

  return (
    <div className="space-y-6 animate-in fade-in duration-500">
      <div className="flex flex-col gap-4 rounded-[28px] border border-primary/10 bg-[linear-gradient(135deg,rgba(249,115,22,0.08)_0%,rgba(255,255,255,1)_55%,rgba(248,250,252,1)_100%)] p-5 sm:p-6 lg:flex-row lg:items-start lg:justify-between">
        <div>
          <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary/70">Alamat Pengiriman</p>
          <h3 className="mt-2 text-2xl font-bold text-gray-900">Kelola alamat utama Anda</h3>
          <p className="mt-2 max-w-2xl text-sm leading-relaxed text-gray-600">
            Pastikan alamat selalu benar dan lengkap agar proses pengiriman berjalan lebih cepat dan minim kendala.
          </p>
        </div>

        <div className="grid gap-3 sm:grid-cols-2 lg:w-[20rem] lg:grid-cols-1">
          <div className="rounded-2xl border border-white/80 bg-white/80 px-4 py-3 shadow-sm">
            <p className="text-xs font-semibold uppercase tracking-[0.16em] text-gray-400">Penerima</p>
            <p className="mt-2 text-sm font-semibold text-gray-800">{pelanggan?.nama || "Belum diisi"}</p>
          </div>

          <div className="rounded-2xl border border-white/80 bg-white/80 px-4 py-3 shadow-sm">
            <p className="text-xs font-semibold uppercase tracking-[0.16em] text-gray-400">Nomor Telepon</p>
            <p className="mt-2 text-sm font-semibold text-gray-800">{pelanggan?.no_hp || "Belum diisi"}</p>
          </div>
        </div>
      </div>

      <div className="grid gap-5 xl:grid-cols-[minmax(0,1fr)_18rem]">
        <div className="rounded-[28px] border border-gray-100 bg-gray-50/60 p-5 sm:p-6">
          <div className="flex flex-col gap-4 sm:flex-row sm:items-start sm:justify-between">
            <div className="flex items-start gap-4">
              <div className="rounded-2xl bg-primary p-3 text-white shadow-sm">
                <Home size={22} />
              </div>

              <div>
                <p className="text-xs font-semibold uppercase tracking-[0.16em] text-primary/70">Alamat Utama</p>
                <h4 className="mt-2 text-lg font-bold text-gray-900">Alamat pengiriman aktif</h4>
                <p className="mt-1 text-sm text-gray-500">Alamat ini digunakan sebagai tujuan utama saat checkout.</p>
              </div>
            </div>

            <button
              type="button"
              onClick={() => setIsModalOpen(true)}
              className="inline-flex items-center justify-center rounded-2xl border border-primary/20 bg-white px-4 py-3 text-sm font-bold text-primary transition hover:border-primary/40 hover:bg-primary/5"
            >
              Ubah Alamat
            </button>
          </div>

          <div className="mt-6 rounded-[24px] border border-gray-100 bg-white p-5 shadow-sm">
            <div className="grid gap-4 sm:grid-cols-2">
              <div className="flex items-start gap-3 rounded-2xl border border-gray-100 bg-gray-50/70 px-4 py-3">
                <span className="mt-0.5 rounded-xl bg-primary/10 p-2 text-primary">
                  <MapPinned size={18} />
                </span>
                <div>
                  <p className="text-xs font-semibold uppercase tracking-[0.16em] text-gray-400">Alamat Lengkap</p>
                  <p className="mt-2 text-sm leading-relaxed text-gray-700">
                    {pelanggan?.alamat || "Alamat belum diatur. Tambahkan alamat supaya checkout lebih cepat."}
                  </p>
                </div>
              </div>

              <div className="space-y-3">
                <div className="flex items-start gap-3 rounded-2xl border border-gray-100 bg-gray-50/70 px-4 py-3">
                  <span className="mt-0.5 rounded-xl bg-primary/10 p-2 text-primary">
                    <NotebookPen size={18} />
                  </span>
                  <div>
                    <p className="text-xs font-semibold uppercase tracking-[0.16em] text-gray-400">Penerima</p>
                    <p className="mt-2 text-sm font-semibold text-gray-800">{pelanggan?.nama || "Belum diisi"}</p>
                  </div>
                </div>

                <div className="flex items-start gap-3 rounded-2xl border border-gray-100 bg-gray-50/70 px-4 py-3">
                  <span className="mt-0.5 rounded-xl bg-primary/10 p-2 text-primary">
                    <Phone size={18} />
                  </span>
                  <div>
                    <p className="text-xs font-semibold uppercase tracking-[0.16em] text-gray-400">Kontak</p>
                    <p className="mt-2 text-sm font-semibold text-gray-800">{pelanggan?.no_hp || "Belum diisi"}</p>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        <div className="rounded-[28px] border border-gray-100 bg-white p-5 shadow-sm sm:p-6">
          <h4 className="text-lg font-bold text-gray-900">Catatan Alamat</h4>
          <p className="mt-2 text-sm leading-relaxed text-gray-500">
            Tulis alamat selengkap mungkin, termasuk nama jalan, nomor rumah, RT/RW, kecamatan, dan patokan bila perlu.
          </p>

          <div className="mt-6 rounded-2xl border border-dashed border-primary/20 bg-primary/5 px-4 py-4">
            <p className="text-xs font-semibold uppercase tracking-[0.16em] text-primary/70">Status Alamat</p>
            <p className="mt-2 text-sm font-medium text-gray-700">
              {pelanggan?.alamat ? "Alamat utama sudah tersedia." : "Alamat belum diatur."}
            </p>
          </div>

          <button
            type="button"
            onClick={() => setIsModalOpen(true)}
            className="mt-6 inline-flex w-full items-center justify-center rounded-2xl bg-primary px-6 py-3 text-sm font-bold text-white transition-all hover:-translate-y-0.5 hover:shadow-lg hover:shadow-primary/20"
          >
            {pelanggan?.alamat ? "Perbarui Alamat" : "Tambah Alamat"}
          </button>
        </div>
      </div>

      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/45 p-4 backdrop-blur-sm">
          <div className="w-full max-w-lg overflow-hidden rounded-[28px] bg-white shadow-2xl animate-in zoom-in duration-200">
            <div className="flex items-center justify-between border-b border-gray-100 px-5 py-4 sm:px-6">
              <div>
                <p className="text-xs font-semibold uppercase tracking-[0.16em] text-primary/70">Edit Alamat</p>
                <h3 className="mt-1 text-lg font-bold text-gray-900">Perbarui alamat pengiriman</h3>
              </div>

              <button
                type="button"
                onClick={() => setIsModalOpen(false)}
                className="rounded-full p-2 text-gray-400 transition hover:bg-gray-100 hover:text-gray-600"
              >
                <X size={20} />
              </button>
            </div>

            <form onSubmit={handleUpdateAlamat} className="space-y-5 p-5 sm:p-6">
              <div>
                <label className="mb-2 block text-sm font-semibold text-gray-700">Alamat Lengkap</label>
                <textarea
                  className="min-h-36 w-full rounded-2xl border border-gray-200 bg-gray-50 px-4 py-3 text-sm outline-none transition-all focus:border-primary focus:ring-4 focus:ring-primary/10"
                  placeholder="Contoh: Jl. Kucing No. 1, RT 01/RW 02, Kecamatan ..."
                  value={alamatInput}
                  onChange={(e) => setAlamatInput(e.target.value)}
                  required
                />
                <p className="mt-2 text-xs text-gray-400">Gunakan alamat lengkap agar kurir mudah menemukan lokasi Anda.</p>
              </div>

              <div className="flex flex-col-reverse gap-3 sm:flex-row sm:justify-end">
                <button
                  type="button"
                  onClick={() => setIsModalOpen(false)}
                  className="inline-flex items-center justify-center rounded-2xl border border-gray-200 px-4 py-3 text-sm font-bold text-gray-700 transition hover:border-gray-300 hover:bg-gray-50"
                >
                  Batal
                </button>
                <button
                  type="submit"
                  disabled={loading}
                  className="inline-flex items-center justify-center rounded-2xl bg-primary px-4 py-3 text-sm font-bold text-white transition hover:bg-primary/90 disabled:cursor-not-allowed disabled:opacity-50"
                >
                  {loading ? "Menyimpan..." : "Simpan Alamat"}
                </button>
              </div>
            </form>
          </div>
        </div>
      )}
    </div>
  );
}
