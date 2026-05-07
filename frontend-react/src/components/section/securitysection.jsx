import { Eye, EyeOff, LockKeyhole, ShieldCheck, Sparkles } from "lucide-react";
import { useAuth } from "../../context/authcontext";
import { useSecurityForm } from "../../hooks/usesecurityform";

export default function SecuritySection() {
  const { updateUser } = useAuth();
  const {
    isLoading,
    showPassword,
    setShowPassword,
    showConfirmPassword,
    setShowConfirmPassword,
    pwdData,
    handleChange,
    handleSubmit,
  } = useSecurityForm({ updateUser });

  const passwordLength = pwdData.password.length;
  const isPasswordStrong = passwordLength >= 8;
  const isPasswordMatch =
    pwdData.password_confirmation.length > 0 && pwdData.password === pwdData.password_confirmation;

  return (
    <div className="space-y-6 animate-in fade-in duration-500">
      <div className="flex flex-col gap-4 rounded-[28px] border border-primary/10 bg-[linear-gradient(135deg,rgba(249,115,22,0.08)_0%,rgba(255,255,255,1)_55%,rgba(248,250,252,1)_100%)] p-5 sm:p-6 lg:flex-row lg:items-start lg:justify-between">
        <div>
          <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary/70">Keamanan Akun</p>
          <h3 className="mt-2 text-2xl font-bold text-gray-900">Perbarui kata sandi Anda</h3>
          <p className="mt-2 max-w-2xl text-sm leading-relaxed text-gray-600">
            Jaga akun tetap aman dengan kata sandi yang kuat dan unik. Ubah secara berkala untuk mengurangi risiko akses tidak sah.
          </p>
        </div>

        <div className="grid gap-3 sm:grid-cols-2 lg:w-[20rem] lg:grid-cols-1">
          <div className="rounded-2xl border border-white/80 bg-white/80 px-4 py-3 shadow-sm">
            <p className="text-xs font-semibold uppercase tracking-[0.16em] text-gray-400">Panjang Kata Sandi</p>
            <p className="mt-2 text-sm font-semibold text-gray-800">
              {passwordLength > 0 ? `${passwordLength} karakter` : "Belum diisi"}
            </p>
          </div>

          <div className="rounded-2xl border border-white/80 bg-white/80 px-4 py-3 shadow-sm">
            <p className="text-xs font-semibold uppercase tracking-[0.16em] text-gray-400">Status Konfirmasi</p>
            <p className={`mt-2 text-sm font-semibold ${isPasswordMatch ? "text-emerald-600" : "text-gray-800"}`}>
              {pwdData.password_confirmation.length === 0
                ? "Menunggu konfirmasi"
                : isPasswordMatch
                  ? "Kata sandi cocok"
                  : "Belum cocok"}
            </p>
          </div>
        </div>
      </div>

      <form onSubmit={handleSubmit} className="space-y-5">
        <div className="grid gap-5 xl:grid-cols-[minmax(0,1fr)_18rem]">
          <div className="space-y-5 rounded-[28px] border border-gray-100 bg-gray-50/60 p-5 sm:p-6">
            <div>
              <h4 className="text-lg font-bold text-gray-900">Form Ubah Kata Sandi</h4>
              <p className="mt-1 text-sm text-gray-500">Masukkan kata sandi baru dan konfirmasi dengan benar sebelum disimpan.</p>
            </div>

            <div className="space-y-1">
              <label className="text-sm font-semibold text-gray-700">Kata Sandi Baru</label>
              <div className="relative">
                <input
                  type={showPassword ? "text" : "password"}
                  placeholder="Masukkan kata sandi baru"
                  value={pwdData.password}
                  onChange={(e) => handleChange("password", e.target.value)}
                  className="w-full rounded-2xl border border-gray-200 bg-white px-4 py-3 pr-12 outline-none transition-all focus:border-primary focus:ring-4 focus:ring-primary/10"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 transition-colors hover:text-primary"
                >
                  {showPassword ? <EyeOff size={20} /> : <Eye size={20} />}
                </button>
              </div>
              <p className={`text-xs font-medium ${passwordLength === 0 ? "text-gray-400" : isPasswordStrong ? "text-emerald-600" : "text-amber-600"}`}>
                {passwordLength === 0
                  ? "Gunakan minimal 6 karakter."
                  : isPasswordStrong
                    ? "Bagus, panjang kata sandi sudah kuat."
                    : "Saran: gunakan 8 karakter atau lebih agar lebih aman."}
              </p>
            </div>

            <div className="space-y-1">
              <label className="text-sm font-semibold text-gray-700">Konfirmasi Kata Sandi Baru</label>
              <div className="relative">
                <input
                  type={showConfirmPassword ? "text" : "password"}
                  placeholder="Konfirmasi kata sandi baru"
                  value={pwdData.password_confirmation}
                  onChange={(e) => handleChange("password_confirmation", e.target.value)}
                  className="w-full rounded-2xl border border-gray-200 bg-white px-4 py-3 pr-12 outline-none transition-all focus:border-primary focus:ring-4 focus:ring-primary/10"
                />
                <button
                  type="button"
                  onClick={() => setShowConfirmPassword(!showConfirmPassword)}
                  className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 transition-colors hover:text-primary"
                >
                  {showConfirmPassword ? <EyeOff size={20} /> : <Eye size={20} />}
                </button>
              </div>
              <p
                className={`text-xs font-medium ${
                  pwdData.password_confirmation.length === 0
                    ? "text-gray-400"
                    : isPasswordMatch
                      ? "text-emerald-600"
                      : "text-rose-500"
                }`}
              >
                {pwdData.password_confirmation.length === 0
                  ? "Konfirmasi kata sandi Anda di sini."
                  : isPasswordMatch
                    ? "Konfirmasi kata sandi sudah sesuai."
                    : "Konfirmasi kata sandi belum cocok."}
              </p>
            </div>
          </div>

          <div className="space-y-4 rounded-[28px] border border-gray-100 bg-white p-5 shadow-sm sm:p-6">
            <div>
              <h4 className="text-lg font-bold text-gray-900">Tips Keamanan</h4>
              <p className="mt-2 text-sm leading-relaxed text-gray-500">
                Ikuti beberapa langkah sederhana ini supaya akun Anda tetap aman.
              </p>
            </div>

            <div className="space-y-3">
              <div className="flex items-start gap-3 rounded-2xl border border-gray-100 bg-gray-50/70 px-4 py-3">
                <span className="mt-0.5 rounded-xl bg-primary/10 p-2 text-primary">
                  <LockKeyhole size={18} />
                </span>
                <div>
                  <p className="text-sm font-semibold text-gray-800">Gunakan kata sandi unik</p>
                  <p className="mt-1 text-xs leading-relaxed text-gray-500">Jangan gunakan kata sandi yang sama dengan akun lain.</p>
                </div>
              </div>

              <div className="flex items-start gap-3 rounded-2xl border border-gray-100 bg-gray-50/70 px-4 py-3">
                <span className="mt-0.5 rounded-xl bg-primary/10 p-2 text-primary">
                  <ShieldCheck size={18} />
                </span>
                <div>
                  <p className="text-sm font-semibold text-gray-800">Perbarui secara berkala</p>
                  <p className="mt-1 text-xs leading-relaxed text-gray-500">Mengganti password rutin membantu mengurangi risiko keamanan.</p>
                </div>
              </div>

              <div className="flex items-start gap-3 rounded-2xl border border-gray-100 bg-gray-50/70 px-4 py-3">
                <span className="mt-0.5 rounded-xl bg-primary/10 p-2 text-primary">
                  <Sparkles size={18} />
                </span>
                <div>
                  <p className="text-sm font-semibold text-gray-800">Buat kombinasi kuat</p>
                  <p className="mt-1 text-xs leading-relaxed text-gray-500">Campurkan huruf, angka, dan simbol bila memungkinkan.</p>
                </div>
              </div>
            </div>

            <button
              type="submit"
              disabled={isLoading}
              className="inline-flex w-full items-center justify-center rounded-2xl bg-primary px-6 py-3 text-sm font-bold text-white transition-all hover:-translate-y-0.5 hover:shadow-lg hover:shadow-primary/20 disabled:cursor-not-allowed disabled:opacity-50"
            >
              {isLoading ? "Memproses..." : "Perbarui Kata Sandi"}
            </button>
          </div>
        </div>
      </form>
    </div>
  );
}
