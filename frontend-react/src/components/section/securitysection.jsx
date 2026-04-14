import { ShieldCheck, Lock } from 'lucide-react';

export default function SecuritySection() {
    return (
        <div className="space-y-8 animate-in fade-in duration-500">
        <div>
            <h3 className="text-xl font-bold text-gray-800">Keamanan</h3>
            <p className="text-sm text-gray-500 mt-1">Demi keamanan akun, mohon jangan berikan password Anda ke orang lain</p>
        </div>

        <form className="max-w-md space-y-5">
            <div className="space-y-1 text-gray-700">
            <label className="text-sm font-semibold">Password Saat Ini</label>
            <div className="relative">
                <input type="password" underline="none" className="w-full pl-10 pr-4 py-2.5 bg-gray-50 border border-gray-200 rounded-lg focus:border-primary-500 transition-all outline-none" placeholder="••••••••" />
                <Lock className="absolute left-3 top-3 text-gray-400" size={18} />
            </div>
            </div>

            <div className="space-y-1 text-gray-700">
            <label className="text-sm font-semibold">Password Baru</label>
            <div className="relative">
                <input type="password" underline="none" className="w-full pl-10 pr-4 py-2.5 bg-gray-50 border border-gray-200 rounded-lg focus:border-primary-500 transition-all outline-none" placeholder="Minimal 8 karakter" />
                <Lock className="absolute left-3 top-3 text-gray-400" size={18} />
            </div>
            </div>

            <button type="submit" className="bg-primary text-white px-8 py-2.5 rounded-lg font-bold hover:bg-primary-700 shadow-lg shadow-primary-100 transition-all active:scale-95">
            Konfirmasi Password Baru
            </button>
        </form>
        </div>
    );
};