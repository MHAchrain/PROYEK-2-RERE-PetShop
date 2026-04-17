import { useState } from "react";
import { useAuth } from "../context/authcontext";
import { useNavigate } from "react-router-dom";
import { useAuthForm } from "../hooks/useauthform";

import catImage from "../assets/dummy.png";
import Google from "../assets/google.svg";
import { Eye, EyeOff } from "lucide-react";

export default function AuthPage() {
  const { login } = useAuth();
  const navigate = useNavigate();
  const [authMode, setAuthMode] = useState("login");
  const [showPassword, setShowPassword] = useState(false);
  const [showNewPassword, setShowNewPassword] = useState(false);
  const {
    form,
    handleChange,
    handleSubmit,
    handleSendResetCode,
    resetForgotPasswordState,
    loading,
    sendingCode,
    verifyingCode,
    codeSent,
    codeVerified,
    remainingResetAttempts,
    resetLockMinutes,
    isLogin,
    isRegister,
    isForgotPassword,
    handleVerifyResetCode,
  } = useAuthForm(authMode, login, navigate, setAuthMode);

  const switchToMode = (mode) => {
    setAuthMode(mode);
    if (mode !== "forgot") {
      resetForgotPasswordState();
    }
  };

  return (
    <div className="min-h-screen flex flex-col md:flex-row">
      <div className="w-full md:w-1/2 h-64 md:h-screen">
        <img src={catImage} alt="Auth Visual" className="w-full h-full object-cover" />
      </div>

      <div className="w-full md:w-1/2 flex items-center justify-center px-6 py-10 md:py-0">
        <div className="w-full max-w-md">
          <h2 className="text-2xl md:text-3xl font-semibold mb-2">
            {isLogin ? "Selamat Datang" : isRegister ? "Buat Akun Baru" : "Lupa Password"}
          </h2>

          <p className="mb-8 text-sm md:text-base">
            {isLogin
              ? "Masuk untuk melanjutkan ke PetShop"
              : isRegister
                ? "Daftar untuk membuat akun baru"
                : "Masukkan email, kirim kode reset, lalu buat password baru"}
          </p>

          <form onSubmit={handleSubmit} className="space-y-6">
            {isRegister && (
              <input
                type="text"
                placeholder="Nama"
                value={form.name}
                onChange={(e) => handleChange("name", e.target.value)}
                className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"
              />
            )}

            {isRegister && (
              <input
                type="text"
                placeholder="Nomor Handphone"
                value={form.noHp}
                onChange={(e) => handleChange("noHp", e.target.value.replace(/[^0-9]/g, ""))}
                className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"
              />
            )}

            {isRegister && (
              <textarea
                placeholder="Alamat"
                value={form.alamat}
                onChange={(e) => handleChange("alamat", e.target.value)}
                className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"
              />
            )}

            <input
              type="email"
              placeholder="Email"
              value={form.email}
              onChange={(e) => handleChange("email", e.target.value)}
              className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"
            />

            {(isLogin || isRegister) && (
              <div className="relative w-full">
                <input
                  type={showPassword ? "text" : "password"}
                  placeholder="Kata Sandi"
                  value={form.password}
                  onChange={(e) => handleChange("password", e.target.value)}
                  className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-0 top-2 text-gray-500 hover:text-gray-700"
                >
                  {showPassword ? <EyeOff size={20} /> : <Eye size={20} />}
                </button>
              </div>
            )}

            {isLogin && (
              <div className="flex justify-end -mt-3">
                <button onClick={() => switchToMode("forgot")} className="underline cursor-pointer text-sm text-gray-600 hover:text-black">
                  Lupa password?
                </button>
              </div>
            )}

            {isRegister && (
              <div className="w-full">
                <input
                  type="password"
                  placeholder="Konfirmasi Password"
                  value={form.confirmPassword}
                  onChange={(e) => handleChange("confirmPassword", e.target.value)}
                  className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"
                />

                {form.confirmPassword && (
                  <p
                    className={`text-md mt-1 ${
                      form.password === form.confirmPassword ? "text-green-600" : "text-red-600"
                    }`}
                  >
                    {form.password === form.confirmPassword ? "Password cocok" : "Password tidak sama"}
                  </p>
                )}
              </div>
            )}

            {isForgotPassword && (
              <div className="space-y-4">
                <button
                  type="button"
                  onClick={handleSendResetCode}
                  disabled={sendingCode || resetLockMinutes > 0}
                  className={`w-full py-3 rounded-md text-white transition ${
                    sendingCode || resetLockMinutes > 0 ? "bg-gray-400 cursor-not-allowed" : "bg-primary hover:bg-primary-600"
                  }`}
                >
                  {sendingCode
                    ? "Mengirim..."
                    : resetLockMinutes > 0
                      ? `Coba lagi ${resetLockMinutes} menit`
                      : codeSent
                        ? "Kirim Ulang Kode Reset"
                        : "Kirim Kode Reset"}
                </button>

                {resetLockMinutes > 0 && (
                  <p className="text-sm text-red-600">
                    Terlalu banyak percobaan salah. Silakan coba lagi dalam {resetLockMinutes} menit.
                  </p>
                )}

                {codeSent && !codeVerified && (
                  <>
                    <input
                      type="text"
                      placeholder="Masukkan kode reset"
                      value={form.resetCode}
                      onChange={(e) => handleChange("resetCode", e.target.value.replace(/[^0-9]/g, ""))}
                      className="mt-4 w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"
                    />

                    <button
                      type="button"
                      onClick={handleVerifyResetCode}
                      disabled={verifyingCode}
                      className={`w-full py-3 rounded-md text-white transition ${
                        verifyingCode ? "bg-gray-400 cursor-not-allowed" : "bg-primary hover:bg-primary-600"
                      }`}
                    >
                      {verifyingCode ? "Memverifikasi..." : "Konfirmasi Kode"}
                    </button>

                    <p className="text-sm text-gray-500">
                      Sisa percobaan kode: {remainingResetAttempts}
                    </p>
                  </>
                )}

                {codeVerified && (
                  <>
                    <div className="relative w-full">
                      <input
                        type={showNewPassword ? "text" : "password"}
                        placeholder="Password Baru"
                        value={form.newPassword}
                        onChange={(e) => handleChange("newPassword", e.target.value)}
                        className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"
                      />
                      <button
                        type="button"
                        onClick={() => setShowNewPassword(!showNewPassword)}
                        className="absolute right-0 top-2 text-gray-500 hover:text-gray-700"
                      >
                        {showNewPassword ? <EyeOff size={20} /> : <Eye size={20} />}
                      </button>
                    </div>

                    <input
                      type="password"
                      placeholder="Konfirmasi Password Baru"
                      value={form.confirmNewPassword}
                      onChange={(e) => handleChange("confirmNewPassword", e.target.value)}
                      className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"
                    />
                  </>
                )}
              </div>
            )}

            {(!isForgotPassword || codeVerified) && (
              <button
                type="submit"
                disabled={loading}
                className={`w-full py-3 rounded-md text-white transition flex items-center justify-center gap-2 ${
                  loading ? "bg-gray-400 cursor-not-allowed" : "bg-primary hover:bg-primary-600"
                }`}
              >
                {loading && (
                  <span className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin"></span>
                )}
                {loading
                  ? "Loading..."
                  : isLogin
                    ? "Masuk"
                    : isRegister
                      ? "Daftar"
                      : "Reset Password"}
              </button>
            )}

            {!isForgotPassword && (
              <button
                type="button"
                className="w-full border-2 border-gray-400 py-3 rounded-md flex items-center justify-center gap-2 hover:bg-gray-200 transition cursor-pointer"
              >
                <img src={Google} alt="Google Logo" className="w-5" />
                {isLogin ? "Masuk dengan Google" : "Daftar dengan Google"}
              </button>
            )}
          </form>

          <div className="text-sm text-center mt-6 text-gray-600 space-y-2">
            {isLogin && (
              <p>
                Belum punya akun?
                <button onClick={() => switchToMode("register")} className="ml-2 underline cursor-pointer">
                  Daftar di sini
                </button>
              </p>
            )}

            {isRegister && (
              <p>
                Sudah punya akun?
                <button onClick={() => switchToMode("login")} className="ml-2 underline cursor-pointer">
                  Masuk di sini
                </button>
              </p>
            )}

            {isForgotPassword && (
              <p>
                Ingat password?
                <button onClick={() => switchToMode("login")} className="ml-2 underline cursor-pointer">
                  Kembali ke login
                </button>
              </p>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
