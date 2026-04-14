import { MapPin, Plus, Home } from 'lucide-react';

export default function AddressSection() {
    return (
        <div className="space-y-6 animate-in fade-in duration-500">
            <div className="flex justify-between items-center">
                <div>
                    <h3 className="text-xl font-bold text-gray-800">Alamat Saya</h3>
                    <p className="text-sm text-gray-500">Kelola alamat pengiriman untuk pesanan Anda</p>
                </div>
                <button className=" flex items-center gap-2 bg-primary text-white px-4 py-2 rounded-lg text-sm hover:bg-primary-700 transition ">
                    <Plus size={18} /> Tambah Alamat
                </button>
            </div>

            <hr className="border-gray-100" />

            {/* List Alamat */}
            <div className="space-y-4">
                <div className="p-5 border-2 border-primary-100 bg-primary-50/30 rounded-2xl relative">
                    <div className="flex items-start gap-4">
                        <div className="p-2 bg-primary text-white rounded-lg">
                            <Home size={20} />
                        </div>
                        <div className="flex-1">
                            <div className="flex items-center gap-3 mb-1">
                                <span className="font-bold text-gray-800">Rumah Utama</span>
                                <span className="text-[10px] bg-primary text-white px-2 py-0.5 rounded-md uppercase font-bold">Utama</span>
                            </div>
                            <p className="text-sm text-gray-700 font-semibold">Budi Budiman | 08123456789</p>
                            <p className="text-sm text-gray-500 mt-1">Jl. Kucing Lucu No. 123, Blok C, Kec. Lohbener, Kab. Indramayu, Jawa Barat 45252</p>
                        </div>
                    </div>
                    <div className="absolute top-5 right-5 flex gap-4 text-sm font-bold text-primary">
                        <button className="hover:underline">Ubah</button>
                        <button className="text-gray-300">|</button>
                        <button className="hover:underline text-primary">Hapus</button>
                    </div>
                </div>
            </div>
        </div>
    );
};