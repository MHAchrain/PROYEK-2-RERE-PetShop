export default function ProfileSection() {
    return (
        <div className="space-y-8 animate-in fade-in slide-in-from-bottom-2 duration-500">
            <div>
                <h3 className="text-xl font-bold text-gray-800">Profil Saya</h3>
                <p className="text-sm text-gray-500 mt-1">Kelola informasi profil Anda untuk mengontrol, mengamankan, dan menjaga akun</p>
            </div>
        
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-12">
                {/* Form Fields */}
                <form className="lg:col-span-2 space-y-5">
                    <div className="space-y-1">
                        <label className="text-sm font-semibold text-gray-700">Nama Lengkap</label>
                        <input 
                        type="text" 
                        className="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-lg outline-none focus:border-primary-500 focus:bg-white transition-all" 
                        placeholder="Masukkan nama Anda"
                        />
                    </div>
                    <div className="space-y-1">
                        <label className="text-sm font-semibold text-gray-700">Nomor Telepon</label>
                        <input 
                        type="text" 
                        className="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-lg outline-none focus:border-primary-500 focus:bg-white transition-all" 
                        placeholder="0812xxxx"
                        />
                    </div>
                    <button className="bg-primary text-white px-8 py-2.5 rounded-lg font-bold hover:bg-primary-600 shadow-lg shadow-primary-200 transition-all active:scale-95">
                        Simpan Perubahan
                    </button>
                </form>
            </div>
        </div>
    );
};