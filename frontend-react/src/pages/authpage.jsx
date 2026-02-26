import { useState } from "react";
import catImage from "../assets/dummy.png";
import Google from "../assets/google.svg";

export default function AuthPage() {
    const [isLogin, setIsLogin] = useState(true);
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

                    <form className="space-y-6">
                        {! isLogin && (
                            <input type="text" placeholder="Nama"
                            className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"/>
                        )}

                        <input type="text" placeholder="Email atau Nomor Telepon"
                        className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"/>
                        
                        <input type="password" placeholder="Kata Sandi"
                        className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"/>

                        <button type="submit" 
                        className="w-full bg-red-700 text-white py-3 rounded-md hover:bg-red-500 transition">
                            {isLogin ? "Masuk" : "Daftar"}
                        </button>

                        <button type="button" className="w-full border-2 border-gray-400 py-3 rounded-md flex items-center justify-center gap-2 hover:bg-gray-200 transition">
                            <img src={Google} alt="Google Logo" className="w-5" />
                            {isLogin ? "Masuk dengan Google" : "Daftar dengan Google"}
                        </button>
                    </form>

                    <p className="text-sm text-center mt-6 text-gray-600">
                        {isLogin ? "Belum punya akun?" : "Sudah punya akun?"}
                        <button onClick={() => setIsLogin(!isLogin)} className="ml-2 underline">
                            {isLogin ? "Daftar di sini" : "Masuk di sini"}
                        </button>
                    </p>
                </div>
            </div>
        </div>
    )
}