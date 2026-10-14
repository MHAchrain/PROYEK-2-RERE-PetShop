import { useAuth } from "../../context/authcontext";
import { useProfileForm } from "../../hooks/useprofileform";

export default function ProfileSection() {
  const { user, updateUser } = useAuth();
  const { akunUser, formData, isLoading, handleChange, handleSubmit } = useProfileForm({
    user,
    updateUser,
  });

  return (
    <div className="space-y-6 animate-in fade-in duration-500">
      <div className="flex flex-col gap-4 rounded-[28px] border border-primary/10 bg-[linear-gradient(135deg,rgba(249,115,22,0.08)_0%,rgba(255,255,255,1)_55%,rgba(248,250,252,1)_100%)] p-5 sm:p-6 lg:flex-row lg:items-start lg:justify-between">
        <div>
          <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary/70">Profil Saya</p>
          <h3 className="mt-2 text-2xl font-bold text-gray-900">Kelola informasi akun kamu</h3>
          <p className="mt-2 max-w-2xl text-sm leading-relaxed text-gray-600">
            Pastikan nama dan nomor telepon selalu terbaru agar proses belanja dan pengiriman berjalan lebih lancar.
          </p>
        </div>

        <div className="grid grid-cols-1 gap-3 sm:grid-cols-2 lg:w-[20rem] lg:grid-cols-1">
          <div className="rounded-2xl border border-white/80 bg-white/80 px-4 py-3 shadow-sm">
            <p className="text-xs font-semibold uppercase tracking-[0.16em] text-gray-400">Email Akun</p>
            <p className="mt-2 break-all text-sm font-semibold text-gray-800">{akunUser?.email || "-"}</p>
          </div>

          <div className="rounded-2xl border border-white/80 bg-white/80 px-4 py-3 shadow-sm">
            <p className="text-xs font-semibold uppercase tracking-[0.16em] text-gray-400">Nomor Telepon</p>
            <p className="mt-2 text-sm font-semibold text-gray-800">{formData.no_hp || "Belum diisi"}</p>
          </div>
        </div>
      </div>

      <form onSubmit={handleSubmit} className="space-y-5">
        <div className="grid gap-5 xl:grid-cols-[minmax(0,1fr)_18rem]">
          <div className="space-y-5 rounded-[28px] border border-gray-100 bg-gray-50/60 p-5 sm:p-6">
            <div>
              <h4 className="text-lg font-bold text-gray-900">Informasi Dasar</h4>
              <p className="mt-1 text-sm text-gray-500">Data ini digunakan untuk identitas akun dan kontak utama kamu.</p>
            </div>

            <div className="space-y-1 opacity-70">
              <label className="text-sm font-semibold text-gray-700">Email (Tidak bisa diubah)</label>
              <input
                type="text"
                value={akunUser?.email || ""}
                disabled
                className="w-full cursor-not-allowed rounded-2xl border border-gray-200 bg-white px-4 py-3 text-sm text-gray-500 outline-none"
              />
            </div>

            <div className="space-y-1">
              <label className="text-sm font-semibold text-gray-700">Nama Lengkap</label>
              <input
                type="text"
                name="nama"
                value={formData.nama}
                onChange={handleChange}
                placeholder="Masukkan nama lengkap"
                className="w-full rounded-2xl border border-gray-200 bg-white px-4 py-3 outline-none transition-all focus:border-primary focus:ring-4 focus:ring-primary/10"
              />
            </div>

            <div className="space-y-1">
              <label className="text-sm font-semibold text-gray-700">Nomor Telepon</label>
              <input
                type="text"
                name="no_hp"
                value={formData.no_hp}
                onChange={handleChange}
                inputMode="numeric"
                autoComplete="tel"
                placeholder="08xxxxxxxxxx"
                className="w-full rounded-2xl border border-gray-200 bg-white px-4 py-3 outline-none transition-all focus:border-primary focus:ring-4 focus:ring-primary/10"
              />
            </div>
          </div>

          <div className="rounded-[28px] border border-gray-100 bg-white p-5 shadow-sm sm:p-6">
            <h4 className="text-lg font-bold text-gray-900">Simpan Perubahan</h4>
            <p className="mt-2 text-sm leading-relaxed text-gray-500">
              Setelah diperbarui, data profil ini akan dipakai untuk kebutuhan akun dan belanja berikutnya.
            </p>

            <div className="mt-6 rounded-2xl border border-dashed border-primary/20 bg-primary/5 px-4 py-4">
              <p className="text-xs font-semibold uppercase tracking-[0.16em] text-primary/70">Status Form</p>
              <p className="mt-2 text-sm font-medium text-gray-700">
                {isLoading ? "Perubahan sedang disimpan..." : "Siap untuk diperbarui."}
              </p>
            </div>

            <button
              type="submit"
              disabled={isLoading}
              className="mt-6 inline-flex w-full items-center justify-center rounded-2xl bg-primary px-6 py-3 text-sm text-white transition-all hover:-translate-y-0.5 hover:shadow-lg hover:shadow-primary/20 disabled:cursor-not-allowed disabled:opacity-50"
            >
              {isLoading ? "Menyimpan..." : "Simpan Perubahan"}
            </button>
          </div>
        </div>
      </form>
    </div>
  );
}
