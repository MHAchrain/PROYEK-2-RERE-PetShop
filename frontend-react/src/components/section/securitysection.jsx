import { Eye, EyeOff } from "lucide-react";
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

  return (
    <div className="space-y-6 animate-in fade-in duration-500">
      <div>
        <h3 className="text-xl font-bold text-gray-800">Keamanan Akun</h3>
        <p className="text-sm text-gray-500">
          Ubah kata sandi Anda secara berkala untuk menjaga keamanan akun.
        </p>
      </div>

      <form onSubmit={handleSubmit} className="max-w-md space-y-5">
        <div className="space-y-1">
          <label className="text-sm font-semibold text-gray-700">Kata Sandi Baru</label>
          <div className="relative">
            <input
              type={showPassword ? "text" : "password"}
              placeholder="Masukkan kata sandi baru"
              value={pwdData.password}
              onChange={(e) => handleChange("password", e.target.value)}
              className="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-lg outline-none focus:border-primary transition-all pr-12"
            />
            <button
              type="button"
              onClick={() => setShowPassword(!showPassword)}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-primary transition-colors"
            >
              {showPassword ? <EyeOff size={20} /> : <Eye size={20} />}
            </button>
          </div>
        </div>

        <div className="space-y-1">
          <label className="text-sm font-semibold text-gray-700">Konfirmasi Kata Sandi Baru</label>
          <div className="relative">
            <input
              type={showConfirmPassword ? "text" : "password"}
              placeholder="Konfirmasi kata sandi baru"
              value={pwdData.password_confirmation}
              onChange={(e) => handleChange("password_confirmation", e.target.value)}
              className="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-lg outline-none focus:border-primary transition-all pr-12"
            />
            <button
              type="button"
              onClick={() => setShowConfirmPassword(!showConfirmPassword)}
              className="absolute right-3 top-1/2 -translate-y-1/2 text-gray-400 hover:text-primary transition-colors"
            >
              {showConfirmPassword ? <EyeOff size={20} /> : <Eye size={20} />}
            </button>
          </div>
        </div>

        <button
          type="submit"
          disabled={isLoading}
          className="bg-primary text-white px-8 py-2.5 rounded-lg font-bold hover:shadow-lg disabled:opacity-50 transition-all w-full md:w-auto"
        >
          {isLoading ? "Memproses..." : "Update Password"}
        </button>
      </form>
    </div>
  );
}
