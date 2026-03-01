import { useState } from "react";
import { useAuth } from "../context/authcontext";
import { useNavigate } from "react-router-dom";
import catImage from "../assets/dummy.png";
import Google from "../assets/google.svg";


export default function AuthPage() {
    const {login} = useAuth();

    const [isLogin, setIsLogin] = useState(true);
    const [name, setName] = useState("");
    const [email, setEmail] = useState("");
    const [password, setPassword] = useState("");
    const navigate = useNavigate();

    const handleSubmit = (e) =>{
        e.preventDefault();
    
        const endpoint = isLogin ? "login" : "register";

        console.log("Mode:", endpoint);
        console.log({name, email, password});
    
        const fakeUser = {
            name: isLogin ? "Ryu" : name,
            email: email
        };
        login(fakeUser, "dummy-token");
        navigate("/")





        // const response = await fetch(`http://localhost:5000/api/${endpoint}`, {
        //     method: "POST",
        //     headers: {
        //         "Content-Type" : "application/json",
        //     },
        //     body: JSON.stringify({ email, password }),
        // });
    
        // const data = await response.json();
    
        // if(response.ok){
        //     login(data.user, data.token);
        // }
    };

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
                            <input type="text" placeholder="Nama" value={name} onChange={(e) => setName(e.target.value)}
                            className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"/>
                        )}

                        <input type="text" placeholder="Email atau Nomor Telepon" value={email} onChange={(e) => setEmail(e.target.value)}
                        className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"/>
                        
                        <input type="password" placeholder="Kata Sandi" value={password} onChange={(e) => setPassword(e.target.value)}
                        className="w-full border-b border-gray-400 bg-transparent py-2 focus:outline-none focus:border-black"/>

                        <button type="submit" 
                        className="w-full bg-primary text-white py-3 rounded-md hover:bg-primary-700 transition cursor-pointer">
                            {isLogin ? "Masuk" : "Daftar"}
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