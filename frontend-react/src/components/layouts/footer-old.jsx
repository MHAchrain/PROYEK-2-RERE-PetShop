import { Facebook, X, Instagram, Linkedin, Send } from "lucide-react";
import {FaGooglePlay, FaApple} from "react-icons/fa";
import QrCode from "../../assets/Qr.png";

export default function FooterOld(){
    return(
        <footer className="bg-black text-gray-300 pt-16 pb-6 px-6 md:px-18">
            {/* Top Section */}

            <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-8">
                {/* Subs */}
                <div>
                    <h2 className="text-white text-xl font-semibold mb-4">
                        ReRe Petshop
                    </h2>
                    <h3 className="text-white font-medium mb-3">Berlangganan</h3>
                    <p className="text-sm mb-4">
                        Dapatkan Diskon 10% pada pemesanan pertama
                    </p>

                    <div className="flex items-center border border-gray-200 rounded-md overflow-hidden">
                        <input type="email" placeholder="Masukan Email Kamu"
                        className="bg-transparent px-4 py-2 w-full outline-none text-sm"/>
                        <button className="px-4 text-white hover:text-primary transition">
                            <Send size={18}/>
                        </button>
                    </div>
                </div>

                {/* Support */}
                <div>
                    <h3 className="text-white text-lg font-medium mb-4">Beri Dukungan</h3>
                    <p className="text-sm leading-6">
                        Jl. Kecubung 1 No.14, <br />
                        Kuta Baru, Kec. Ps. Kemis, <br />
                        Kabupaten Tangerang, Banten 15560
                    </p>
                    <p className="mt-4 text-sm">rereps@gmail.com</p>
                    <p className="mt-2 text-sm underline cursor-pointer">0813-1941-0250</p>
                </div>

                {/* Account */}
                <div>
                    <h3 className="text-white text-lg font-medium mb-4">Akun</h3>
                    <ul className="space-y-4 text-sm">
                        <li className="hover:text-white cursor-pointer">Akun Saya</li>
                        <li className="hover:text-white cursor-pointer">Masuk / Daftar</li>
                        <li className="hover:text-white cursor-pointer">Keranjang</li>
                        <li className="hover:text-white cursor-pointer">Daftar Keinginan</li>
                        <li className="hover:text-white cursor-pointer">Toko</li>
                    </ul>
                </div>

                {/* Quick Link */}
                <div>
                    <h3 className="text-white text-lg font-medium mb-4">Tautan Cepat</h3>
                    <ul className="space-y-4 text-sm">
                        <li className="hover:text-white cursor-pointer">Kebijakan Privasi</li>
                        <li className="hover:text-white cursor-pointer">Ketentuan Penggunaan</li>
                        <li className="hover:text-white cursor-pointer">FAQ</li>
                        <li className="hover:text-white cursor-pointer">Kontak</li>
                    </ul>
                </div>

                {/* Download App */}
                <div>
                    <h3 className="text-white font-medium mb-4 text-lg">Unduh Aplikasi</h3>
                    <p className="text-sm text-gray-400 mb-4">Hemat Rp 45.000 dengan Aplikasi (Hanya untuk Pengguna Baru)</p>

                    {/* QR Placeholder */}
                    <div className="flex items-center gap-4 mb-6">
                        <img src={QrCode} alt="QR-Code" className="w-24 h-24 object-cover bg-white"/>

                        <div className="flex flex-col gap-3">
                            <div className="flex items-center gap-3 border 
                            border-white rounded-lg p-1 cursor-pointer 
                            hover:bg-white hover:text-black transition-all 
                            duration-300">
                                <FaGooglePlay size={20}/>
                                <div className="leading-tight">
                                    <p className="text-[8px] uppercase">Get it on</p>
                                    <p className="text-sm font-semibold">Google Play</p>
                                </div>
                            </div>
                            
                            <div className="flex items-center gap-3 border 
                            border-white rounded-lg p-1 cursor-pointer 
                            hover:bg-white hover:text-black transition-all 
                            duration-300">
                                <FaApple size={20}/>
                                <div className="leading-tight">
                                    <p className="text-[8px] uppercase">Download on the</p>
                                    <p className="text-sm font-semibold">App Store</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* Social Icons */}
                    <div className="flex gap-6 mt-4 text-gray-300">
                        <Facebook size={20} className="hover:text-white cursor-pointer"/>
                        <X size={20} className="hover:text-white cursor-pointer"/>
                        <Instagram size={20} className="hover:text-white cursor-pointer"/>
                        <Linkedin size={20} className="hover:text-white cursor-pointer"/>
                    </div>
                </div>
            </div>

            <div className="border-t border-gray-800 mt-12 pt-6 text-center text-sm text-gray-500">
                Â© Copyright KicauMania 2026. All right reserved
            </div>
        </footer>
    )
}
