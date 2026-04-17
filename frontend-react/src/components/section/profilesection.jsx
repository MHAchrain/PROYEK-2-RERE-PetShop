import { useState, useEffect } from "react";
import { useAuth } from "../../context/authcontext";
import api from "../../api/axios";
import toast from "react-hot-toast";

export default function ProfileSection() {
    const { user, updateUser } = useAuth();
    const [isLoading, setIsLoading] = useState(false);
    
    const [formData, setFormData] = useState({
        nama: "",
        no_hp: "",
    });

    useEffect(() => {
        if (user) {
            const p = user.pelanggan || user.data?.pelanggan;
            const u = user.user || user.data?.user || user;

            setFormData({
                nama: p?.nama || u?.name || "",
                no_hp: p?.no_hp || "",
            });
        }
    }, [user]);

    const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        const toastId = toast.loading("Menyimpan perubahan...");
        setIsLoading(true);

        try {
                const dataToUpdate = {
                nama: formData.nama,
                no_hp: formData.no_hp,
            };
            const res = await api.post("/pelanggan/update", dataToUpdate);

            if (res.data.success) {
                toast.success("Profil berhasil diperbarui!", { id: toastId });
                updateUser(res.data.data);
            }
        } catch (error) {
            console.error("Error Detail:", error.response?.data);
            toast.error(error.response?.data?.message || "Gagal update profil", { id: toastId });
        } finally {
            setIsLoading(false);
        }
    };

    return (
        <div className="space-y-6 animate-in fade-in duration-500">
            <div>
                <h3 className="text-xl font-bold text-gray-800">Profil Saya</h3>
                <p className="text-sm text-gray-500">Kelola informasi dasar akun Rere Petshop Anda.</p>
            </div>

            <form onSubmit={handleSubmit} className="max-w-2xl space-y-5">
                <div className="space-y-1 opacity-60">
                    <label className="text-sm font-semibold text-gray-700">Email (Tidak bisa diubah)</label>
                    <input 
                        type="text" 
                        value={user?.user?.email || user?.email || ""} 
                        disabled 
                        className="w-full px-4 py-2.5 bg-gray-100 border border-gray-200 rounded-lg cursor-not-allowed" 
                    />
                </div>

                <div className="space-y-1">
                    <label className="text-sm font-semibold text-gray-700">Nama Lengkap</label>
                    <input 
                        type="text" 
                        name="nama"
                        // Gunakan formData.nama yang udah kita set di useEffect
                        value={formData.nama} 
                        onChange={handleChange}
                        className="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-lg outline-none focus:border-primary transition-all" 
                    />
                </div>

                <div className="space-y-1">
                    <label className="text-sm font-semibold text-gray-700">Nomor Telepon</label>
                    <input 
                        type="text" 
                        name="no_hp"
                        value={formData.no_hp} 
                        onChange={handleChange}
                        className="w-full px-4 py-2.5 bg-gray-50 border border-gray-200 rounded-lg outline-none focus:border-primary transition-all" 
                    />
                </div>

                <button 
                    type="submit"
                    disabled={isLoading} 
                    className="bg-primary text-white px-8 py-2.5 rounded-lg font-bold hover:shadow-lg disabled:opacity-50 transition-all"
                >
                    {isLoading ? "Menyimpan..." : "Simpan Perubahan"}
                </button>
            </form>
        </div>
    );
}