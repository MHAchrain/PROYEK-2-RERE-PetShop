import { useState } from "react";
import { useAuth } from "../context/authcontext";
import { useNavigate } from "react-router-dom";
import { useAuthForm } from "../hooks/useauthform";

import catImage from "../assets/dummy.png";
import Google from "../assets/google.svg";
import { Eye, EyeOff } from "lucide-react";

export default function AuthPage() {
    const {login} = useAuth();
    const navigate = useNavigate();
    const [isLogin, setIsLogin] = useState(true);
    const [showPassword, setShowPassword] = useState(false);
    const { form, handleChange, handleSubmit, loading } =
        useAuthForm(isLogin, login, navigate, setIsLogin);

    return (
        <div className="min-h-screen flex flex-col md:flex-row">
            {/* Left side: Image */}
            <div className="w-full md:w-1/2 h-64 md:h-screen">
                <img src={catImage} alt="Auth Visual" className="w-full h-full object-cover" />
            </div>

            {/* Right side: Form */}
            <div className="w-full md:w-1/2 flex items-center justify-center px-6 py-10 md:py-0">
                <div className="w-full max-w-md">
                    <h2 className="text-2xl md:text-3xl font-semibold mb-2">
                        {isLogin ? "Selamat Datang" : "Buat Akun Baru"}
                    </h2>
                    
                    <p className="mb-8 text-sm md:text-base">
                        {isLogin ? "Masuk untuk melanjutkan ke PetShop" : "Daftar untuk membuat akun baru"}
                    </p>

                    <form onSubmit={handleSubmit} className="space-y-6">
                        {! isLogin && (
                            <input type="text" placeholder="Nama" value={form.name} onChange={(e) => handleChange("name", e.target.value)}
                            className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"/>
                        )}

                        {!isLogin && (
                            <input
                                type="text"
                                placeholder="Nomor Handphone"
                                value={form.noHp}
                                onChange={(e) =>
                                    handleChange(
                                        "noHp",
                                        e.target.value.replace(/[^0-9]/g, "")
                                    )
                                }
                                className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"
                            />
                        )}

                        {!isLogin && (
                            <textarea
                                placeholder="Alamat"
                                value={form.alamat}
                                onChange={(e) => handleChange("alamat", e.target.value)}
                                className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"
                            />
                        )}

                        <input
                            type={isLogin ? "email" : "email"}
                            placeholder={isLogin ? "Email" : "Email"}
                            value={form.email}
                            onChange={(e) => handleChange("email", e.target.value)}
                            className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"
                        />
                        
                        <div className="relative w-full">
                            <input type={showPassword ? "text" : "password"} placeholder="Kata Sandi" value={form.password} onChange={(e) => handleChange("password", e.target.value)}
                            className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"/>
                            <button
                                type="button"
                                onClick={() => setShowPassword(!showPassword)}
                                className="absolute right-0 top-2 text-gray-500 hover:text-gray-700"
                            >
                                {showPassword ? <EyeOff size={20} /> : <Eye size={20} />}
                            </button>
                        </div>

                        {!isLogin && (
                            <div className="w-full">
                                <input
                                    type="password"
                                    placeholder="Konfirmasi Password"
                                    value={form.confirmPassword}
                                    onChange={(e) => handleChange("confirmPassword", e.target.value)}
                                    className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"
                                />

                                {form.confirmPassword && (
                                    <p className={`text-md mt-1 ${
                                        form.password === form.confirmPassword
                                            ? "text-green-600"
                                            : "text-red-600"
                                    }`}>
                                        {form.password === form.confirmPassword
                                            ? "Password cocok ✔"
                                            : "Password tidak sama ❌"}
                                    </p>
                                )}
                            </div>
                        )}

                        <button
                            type="submit"
                            disabled={loading}
                            className={`w-full py-3 rounded-md text-white transition flex items-center justify-center gap-2 ${
                                loading
                                ? "bg-gray-400 cursor-not-allowed"
                                : "bg-primary hover:bg-primary-600"
                            }`}
                            >
                                {loading && (
                                    <span className="w-5 h-5 border-2 border-white border-t-transparent rounded-full animate-spin"></span>
                                )}
                                {loading ? "Loading..." : isLogin ? "Masuk" : "Daftar"}
                        </button>

                        <button type="button" className="w-full border-2 border-gray-400 py-3 rounded-md flex items-center 
                        justify-center gap-2 hover:bg-gray-200 transition cursor-pointer">
                            <img src={Google} alt="Google Logo" className="w-5" />
                            {isLogin ? "Masuk dengan Google" : "Daftar dengan Google"}
                        </button>
                    </form>

                    <p className="text-sm text-center mt-6 text-gray-600">
                        {isLogin ? "Belum punya akun?" : "Sudah punya akun?"}
                        <button onClick={() => setIsLogin(!isLogin)} className="ml-2 underline cursor-pointer">
                            {isLogin ? "Daftar di sini" : "Masuk di sini"}
                        </button>
                    </p>
                </div>
            </div>
        </div>
    )
}