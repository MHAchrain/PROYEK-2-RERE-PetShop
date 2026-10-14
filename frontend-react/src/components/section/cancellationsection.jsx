import { Package } from "lucide-react";

export default function CancellationSection() {
    return (
        <div className="animate-in fade-in slide-in-from-bottom-2 duration-500 py-10 text-center">
            <div className="bg-gray-50 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-4">
                <Package size={32} className="text-gray-300" />
            </div>
            <h3 className="font-bold text-gray-800">Tidak ada pembatalan</h3>
            <p className="text-sm text-gray-400 mt-1 text-balance">Belum ada pesanan yang dibatalkan.</p>
        </div>
    );
}