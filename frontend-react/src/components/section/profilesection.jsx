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
      <div>
        <h3 className="text-xl font-bold text-gray-800">Profil Saya</h3>
        <p className="text-sm text-gray-500">Kelola informasi dasar akun Rere Petshop Anda.</p>
      </div>

      <form onSubmit={handleSubmit} className="max-w-2xl space-y-5">
        <div className="space-y-1 opacity-60">
          <label className="text-sm font-semibold text-gray-700">Email (Tidak bisa diubah)</label>
          <input
            type="text"
            value={akunUser?.email || ""}
            disabled
            className="w-full px-4 py-2.5 bg-gray-100 border border-gray-200 rounded-lg cursor-not-allowed"
          />
        </div>

        <div className="space-y-1">
          <label className="text-sm font-semibold text-gray-700">Nama Lengkap</label>
          <input
            type="text"
            name="nama"
            value={formData.nama}
            onChange={handleChange}
            className="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-lg outline-none focus:border-primary transition-all"
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
            className="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-lg outline-none focus:border-primary transition-all"
          />
        </div>

        <button
          type="submit"
          disabled={isLoading}
          className="bg-primary text-white px-8 py-2.5 rounded-lg font-bold hover:shadow-lg disabled:opacity-50 transition-all"
        >
          {isLoading ? "Menyimpan..." : "Simpan Perubahan"}
        </button>
      </form>
    </div>
  );
}
