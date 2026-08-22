import { useState, useRef } from 'react';
import { useAuth } from '../context/authcontext';
import { useNavigate } from 'react-router-dom';
import { useAuthForm } from '../hooks/useauthform';
import { useGoogleLogin } from '@react-oauth/google';
import toast from 'react-hot-toast';
import axios from 'axios';
import { FcGoogle } from 'react-icons/fc';
import catImage from '../assets/catcool.jpg';
import { Eye, EyeOff } from 'lucide-react';

export default function AuthPage() {
  const { login } = useAuth();
  const navigate = useNavigate();
  const [authMode, setAuthMode] = useState('login');
  const [showPassword, setShowPassword] = useState(false);
  const [showNewPassword, setShowNewPassword] = useState(false);
  const otpRefs = useRef([]);

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
    if (mode !== 'forgot') {
      resetForgotPasswordState();
    }
  };

  const handleOtpChange = (e, index) => {
    const val = e.target.value.replace(/[^0-9]/g, '');
    const currentCode = (form.resetCode || '').split('');

    while (currentCode.length <= index) {
      currentCode.push('');
    }

    currentCode[index] = val ? val[val.length - 1] : '';
    const updatedCode = currentCode.join('').slice(0, 6);

    handleChange('resetCode', updatedCode);

    if (val && index < 5) {
      otpRefs.current[index + 1]?.focus();
    }
  };

  const handleOtpKeyDown = (e, index) => {
    if (e.key === 'Backspace' && !form.resetCode?.[index] && index > 0) {
      otpRefs.current[index - 1]?.focus();
    }
  };

  const handleOtpPaste = (e) => {
    e.preventDefault();
    const pastedData = e.clipboardData
      .getData('text')
      .replace(/[^0-9]/g, '')
      .slice(0, 6);

    if (pastedData) {
      handleChange('resetCode', pastedData);
      const nextFocusIndex = Math.min(pastedData.length, 5);
      otpRefs.current[nextFocusIndex]?.focus();
    }
  };

  // Google Login
  const googleLogin = useGoogleLogin({
    onSuccess: async (response) => {
      try {
        const res = await axios.post(
          `${import.meta.env.VITE_API_URL}/api/auth/google`,
          { token: response.access_token },
        );

        login(res.data.data.user, res.data.token);
        toast.success('Login dengan Google berhasil!');
        navigate('/');
      } catch (error) {
        console.error('Google login failed:', error);
        toast.error('Login dengan Google gagal!');
      }
    },
    onError: () => {
      toast.error('Login dengan Google gagal!');
    },
  });

  return (
    <div className="min-h-screen flex flex-col md:flex-row">
      <div className="w-full md:w-1/2 h-64 md:h-screen">
        <img
          src={catImage}
          alt="Visual autentikasi"
          className="w-full h-full object-cover"
        />
      </div>

      <div className="w-full md:w-1/2 flex items-center justify-center px-6 py-10 md:py-0">
        <div className="w-full max-w-md">
          <h2 className="text-2xl md:text-3xl font-semibold mb-2">
            {isLogin
              ? 'Selamat Datang'
              : isRegister
                ? 'Buat Akun Baru'
                : 'Lupa Kata Sandi'}
          </h2>

          <p className="mb-8 text-sm md:text-base text-gray-600">
            {isLogin
              ? 'Masuk untuk melanjutkan ke ReRe Petshop'
              : isRegister
                ? 'Daftar untuk membuat akun baru'
                : codeVerified
                  ? 'Silakan buat kata sandi baru Anda'
                  : codeSent
                    ? 'Masukkan 6 digit kode yang dikirim ke email'
                    : 'Masukkan email untuk menerima kode reset kata sandi'}
          </p>

          <form onSubmit={handleSubmit} className="space-y-6">
            {/* REGISTER FIELDS */}
            {isRegister && (
              <>
                <input
                  type="text"
                  placeholder="Masukkan nama"
                  value={form.name}
                  onChange={(e) => handleChange('name', e.target.value)}
                  className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"
                />

                <input
                  type="text"
                  placeholder="Masukkan nomor handphone"
                  value={form.noHp}
                  onChange={(e) =>
                    handleChange('noHp', e.target.value.replace(/[^0-9]/g, ''))
                  }
                  className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"
                />

                <textarea
                  placeholder="Masukkan alamat"
                  value={form.alamat}
                  onChange={(e) => handleChange('alamat', e.target.value)}
                  className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"
                />
              </>
            )}

            {/* EMAIL FIELD UNTUK LOGIN & REGISTER */}
            {(isLogin || isRegister) && (
              <input
                type="email"
                placeholder="Masukkan email"
                value={form.email}
                onChange={(e) => handleChange('email', e.target.value)}
                className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"
              />
            )}

            {/* PASSWORD FIELD UNTUK LOGIN & REGISTER */}
            {(isLogin || isRegister) && (
              <div className="relative w-full">
                <input
                  type={showPassword ? 'text' : 'password'}
                  placeholder="Masukkan kata sandi"
                  value={form.password}
                  onChange={(e) => handleChange('password', e.target.value)}
                  className="w-full border-b border-gray-400 bg-transparent py-2 pr-8 focus:outline-none focus:border-black [&::-ms-reveal]:hidden [&::-ms-clear]:hidden"
                />
                <button
                  type="button"
                  onClick={() => setShowPassword(!showPassword)}
                  className="absolute right-0 top-2.5 text-gray-500 hover:text-gray-700">
                  {showPassword ? <EyeOff size={18} /> : <Eye size={18} />}
                </button>
              </div>
            )}

            {isLogin && (
              <div className="flex justify-end -mt-3">
                <button
                  type="button"
                  onClick={() => switchToMode('forgot')}
                  className="underline cursor-pointer text-sm text-gray-600 hover:text-primary transition">
                  Lupa kata sandi?
                </button>
              </div>
            )}

            {isRegister && (
              <div className="w-full">
                <input
                  type="password"
                  placeholder="Konfirmasi kata sandi"
                  value={form.confirmPassword}
                  onChange={(e) =>
                    handleChange('confirmPassword', e.target.value)
                  }
                  className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black [&::-ms-reveal]:hidden [&::-ms-clear]:hidden"
                />

                {form.confirmPassword && (
                  <p
                    className={`text-md mt-1 ${
                      form.password === form.confirmPassword
                        ? 'text-green-600'
                        : 'text-red-600'
                    }`}>
                    {form.password === form.confirmPassword
                      ? 'Kata sandi cocok'
                      : 'Kata sandi tidak sama'}
                  </p>
                )}
              </div>
            )}

            {/* FLOW STEP BY STEP LUPA KATA SANDI */}
            {isForgotPassword && (
              <div className="space-y-6">
                {/* STEP 1: INPUT EMAIL & KIRIM KODE */}
                {!codeSent && (
                  <>
                    <input
                      type="email"
                      placeholder="Masukkan email"
                      value={form.email}
                      onChange={(e) => handleChange('email', e.target.value)}
                      className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"
                    />

                    <button
                      type="button"
                      onClick={handleSendResetCode}
                      disabled={sendingCode || resetLockMinutes > 0}
                      className={`w-full py-3 rounded-md text-white font-semibold transition ${
                        sendingCode || resetLockMinutes > 0
                          ? 'bg-gray-400 cursor-not-allowed'
                          : 'bg-primary hover:bg-primary-600'
                      }`}>
                      {sendingCode ? 'Mengirim...' : 'Kirim Kode Reset'}
                    </button>

                    {resetLockMinutes > 0 && (
                      <p className="text-sm text-red-600 text-center">
                        Terlalu banyak percobaan. Coba lagi dalam{' '}
                        {resetLockMinutes} menit.
                      </p>
                    )}
                  </>
                )}

                {/* STEP 2: VERIFIKASI 6 KOTAK OTP */}
                {codeSent && !codeVerified && (
                  <div className="space-y-5">
                    <p className="text-sm text-gray-600 text-center">
                      Kode verifikasi telah dikirim ke{' '}
                      <span className="font-semibold text-black">
                        {form.email}
                      </span>
                    </p>

                    <div
                      className="flex justify-between gap-2"
                      onPaste={handleOtpPaste}>
                      {[...Array(6)].map((_, index) => (
                        <input
                          key={index}
                          type="text"
                          inputMode="numeric"
                          maxLength={1}
                          ref={(el) => (otpRefs.current[index] = el)}
                          value={form.resetCode?.[index] || ''}
                          onChange={(e) => handleOtpChange(e, index)}
                          onKeyDown={(e) => handleOtpKeyDown(e, index)}
                          className="w-12 h-12 text-center text-xl font-bold border border-gray-300 rounded-md focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary bg-white shadow-sm"
                        />
                      ))}
                    </div>

                    <div className="flex justify-between items-center text-xs text-gray-500">
                      <span>Sisa percobaan: {remainingResetAttempts}</span>
                      <button
                        type="button"
                        onClick={handleSendResetCode}
                        disabled={sendingCode || resetLockMinutes > 0}
                        className="hover:text-primary underline cursor-pointer disabled:text-gray-400">
                        {sendingCode
                          ? 'Mengirim ulang...'
                          : 'Kirim ulang kode?'}
                      </button>
                    </div>

                    {resetLockMinutes > 0 && (
                      <p className="text-sm text-red-600 text-center">
                        Terlalu banyak percobaan salah. Coba lagi dalam{' '}
                        {resetLockMinutes} menit.
                      </p>
                    )}

                    <button
                      type="button"
                      onClick={handleVerifyResetCode}
                      disabled={verifyingCode}
                      className={`w-full py-3 rounded-md text-white font-semibold transition ${
                        verifyingCode
                          ? 'bg-gray-400 cursor-not-allowed'
                          : 'bg-primary hover:bg-primary-600'
                      }`}>
                      {verifyingCode ? 'Memverifikasi...' : 'Konfirmasi Kode'}
                    </button>
                  </div>
                )}

                {/* STEP 3: INPUT KATA SANDI BARU */}
                {codeVerified && (
                  <div className="space-y-4">
                    <div className="relative w-full">
                      <input
                        type={showNewPassword ? 'text' : 'password'}
                        placeholder="Masukkan kata sandi baru"
                        value={form.newPassword}
                        onChange={(e) =>
                          handleChange('newPassword', e.target.value)
                        }
                        className="w-full border-b border-gray-400 bg-transparent py-2 pr-8 focus:outline-none focus:border-black [&::-ms-reveal]:hidden [&::-ms-clear]:hidden"
                      />
                      <button
                        type="button"
                        onClick={() => setShowNewPassword(!showNewPassword)}
                        className="absolute right-0 top-2.5 text-gray-500 hover:text-gray-700">
                        {showNewPassword ? (
                          <EyeOff size={18} />
                        ) : (
                          <Eye size={18} />
                        )}
                      </button>
                    </div>

                    <input
                      type="password"
                      placeholder="Konfirmasi kata sandi baru"
                      value={form.confirmNewPassword}
                      onChange={(e) =>
                        handleChange('confirmNewPassword', e.target.value)
                      }
                      className="w-full border-b border-gray-400 bg-transparent py-2 pr-8 focus:outline-none focus:border-black [&::-ms-reveal]:hidden [&::-ms-clear]:hidden"
                    />
                  </div>
                )}
              </div>
            )}

            {/* TOMBOL SUBMIT */}
            {(!isForgotPassword || codeVerified) && (
              <button
                type="submit"
                disabled={loading}
                className={`w-full py-3 rounded-md text-white transition flex items-center justify-center gap-2 ${
                  loading
                    ? 'bg-gray-400 cursor-not-allowed'
                    : 'bg-primary font-semibold hover:bg-primary-600'
                }`}>
                {loading && (
                  <span className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin"></span>
                )}
                {loading
                  ? 'Memproses...'
                  : isLogin
                    ? 'Masuk'
                    : isRegister
                      ? 'Daftar'
                      : 'Simpan Kata Sandi Baru'}
              </button>
            )}
          </form>

          {/* GOOGLE LOGIN DIVIDER */}
          {isLogin && (
            <>
              <div className="relative my-6">
                <div className="absolute inset-0 flex items-center">
                  <div className="w-full border-t border-gray-300"></div>
                </div>
                <div className="relative flex justify-center text-sm">
                  <span className="px-2 bg-white text-gray-500">atau</span>
                </div>
              </div>

              <button
                type="button"
                onClick={googleLogin}
                disabled={loading}
                className="w-full py-3 rounded-md border border-gray-300 bg-white text-gray-700 font-semibold transition flex items-center justify-center gap-3 hover:bg-gray-50 disabled:opacity-60 disabled:cursor-not-allowed">
                {loading ? (
                  <div className="w-5 h-5 border-2 border-gray-300 border-t-blue-600 rounded-full animate-spin" />
                ) : (
                  <FcGoogle size={20} />
                )}
                <span>{loading ? 'Memproses...' : 'Masuk dengan Google'}</span>
              </button>
            </>
          )}

          {/* FOOTER SWITCH MODE */}
          <div className="text-sm text-center mt-6 text-gray-600 space-y-2">
            {isLogin && (
              <p>
                Belum punya akun?
                <button
                  type="button"
                  onClick={() => switchToMode('register')}
                  className="ml-2 underline hover:text-primary cursor-pointer transition">
                  Daftar di sini
                </button>
              </p>
            )}

            {isRegister && (
              <p>
                Sudah punya akun?
                <button
                  type="button"
                  onClick={() => switchToMode('login')}
                  className="ml-2 underline hover:text-primary cursor-pointer transition">
                  Masuk di sini
                </button>
              </p>
            )}

            {isForgotPassword && (
              <p>
                Ingat kata sandi?
                <button
                  type="button"
                  onClick={() => switchToMode('login')}
                  className="ml-2 underline hover:text-primary cursor-pointer transition">
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
