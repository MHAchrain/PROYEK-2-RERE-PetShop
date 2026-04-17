import { useState, useEffect } from 'react';
import { MapPin, Plus, Home, X } from 'lucide-react';
import { useAuth } from "../../context/authcontext";
import api from "../../api/axios";
import toast from "react-hot-toast";

export default function AddressSection() {
    const { user, updateUser } = useAuth();
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [loading, setLoading] = useState(false);
    const [alamatInput, setAlamatInput] = useState("");

    const pelanggan = user?.pelanggan || user?.data?.pelanggan;

    // Set isi input sesuai alamat yang ada sekarang pas modal dibuka
    useEffect(() => {
        if (pelanggan?.alamat) {
            setAlamatInput(pelanggan.alamat);
        }
    }, [isModalOpen, pelanggan]);

    const handleUpdateAlamat = async (e) => {
        e.preventDefault();
        const tid = toast.loading("Memperbarui alamat...");
        setLoading(true);

        try {
            const res = await api.post("/pelanggan/update", {
                alamat: alamatInput
            });

            if (res.data.success) {
                toast.success("Alamat diperbarui!", { id: tid });
                updateUser(res.data.data); // Sync ke context & localstorage
                setIsModalOpen(false);
            }
        } catch (err) {
            toast.error("Gagal update alamat", { id: tid });
        } finally {
            setLoading(false);
        }
    };

    return (
        <div className="space-y-6 animate-in fade-in duration-500">
            <div>
                <h3 className="text-xl font-bold text-gray-800">Alamat Saya</h3>
                <p className="text-md text-gray-500">Kelola alamat pengiriman ReRe Petshop Anda</p>
            </div>

            <hr className="border-gray-100" />

            <div className="space-y-4">
                <div className="p-5 border-2 border-primary-100 bg-primary-50/30 rounded-2xl relative">
                    <div className="flex items-start gap-4">
                        <div className="p-2 bg-primary text-white rounded-lg"><Home size={20} /></div>
                        <div className="flex-1">
                            <div className="flex items-center gap-3 mb-1">
                                <span className="font-bold text-gray-800">Alamat Utama</span>
                            </div>
                            <p className="text-sm text-gray-700 font-semibold">{pelanggan?.nama} | {pelanggan?.no_hp}</p>
                            <p className="text-sm text-gray-500 mt-1">{pelanggan?.alamat || "Alamat belum diatur."}</p>
                        </div>
                    </div>
                    
                    <div className="absolute top-5 right-5">
                        <button 
                            onClick={() => setIsModalOpen(true)}
                            className="text-sm font-bold text-primary hover:underline"
                        >
                            Ubah
                        </button>
                    </div>
                </div>
            </div>

            {/* MODAL UBAH ALAMAT */}
            {isModalOpen && (
                <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm p-4">
                    <div className="bg-white rounded-2xl w-full max-w-md overflow-hidden shadow-2xl animate-in zoom-in duration-200">
                        <div className="flex justify-between items-center p-5 border-b border-gray-400">
                            <h3 className="font-bold">Ubah Alamat</h3>
                            <button onClick={() => setIsModalOpen(false)} className="text-gray-400 hover:text-gray-600">
                                <X size={20} />
                            </button>
                        </div>
                        <form onSubmit={handleUpdateAlamat} className="p-5 space-y-4">
                            <div>
                                <label className="text-sm font-semibold text-gray-600 mb-2 block">Alamat Lengkap</label>
                                <textarea 
                                    className="w-full border border-gray-400 rounded-xl p-3 text-sm focus:border-primary outline-none min-h-30 bg-gray-50"
                                    placeholder="Contoh: Jl. Kucing No. 1..."
                                    value={alamatInput}
                                    onChange={(e) => setAlamatInput(e.target.value)}
                                    required
                                />
                            </div>
                            <div className="flex gap-3">
                                <button 
                                    type="button"
                                    onClick={() => setIsModalOpen(false)}
                                    className="flex-1 py-2.5 border border-gray-400 rounded-lg font-bold text-gray-500"
                                >
                                    Batal
                                </button>
                                <button 
                                    type="submit"
                                    disabled={loading}
                                    className="flex-1 py-2.5 bg-primary text-white rounded-lg font-bold disabled:opacity-50"
                                >
                                    {loading ? "Menyimpan..." : "Simpan"}
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            )}
        </div>
    );
}