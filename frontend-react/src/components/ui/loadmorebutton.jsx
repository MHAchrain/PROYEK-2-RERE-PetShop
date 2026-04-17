import React from "react";

export default function LoadMoreButton({ 
    onClick, 
    isLoading, 
    isShowingAll, 
    totalData, 
    threshold = 8 
    }){
    // Kalau data sedikit (dibawah batas), tombol nggak usah muncul
    if (totalData <= threshold) return null;

    return (
        <div className="flex justify-center w-full">
        <button
            onClick={onClick}
            disabled={isLoading}
            className="m-10 px-12 py-3 rounded-md bg-primary text-white hover:bg-primary-600 
                    transition-all active:scale-95 font-bold shadow-lg shadow-primary/20 
                    flex items-center justify-center min-w-50 disabled:opacity-70"
        >
            {isLoading ? (
            <div className="w-5 h-5 border-2 border-white/30 border-t-white rounded-full animate-spin" />
            ) : (
            isShowingAll ? 'Tampilkan Lebih Sedikit' : 'Lihat Semua'
            )}
        </button>
        </div>
    );
}