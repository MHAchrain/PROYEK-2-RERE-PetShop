import React, { useState } from "react";

export  default function OrderPage() {
  // Default langsung ke 'semua'
  const [activeTab, setActiveTab] = useState("semua");

  const tabs = [
    { id: "semua", label: "Pesanan" },
    { id: "pembatalan", label: "Pembatalan" },
    { id: "ulasan", label: "Ulasan" },
  ];

  return (
    <div className="max-w-5xl mx-auto py-10 px-6 min-h-screen">
      <h1 className="text-2xl font-bold mb-8 text-gray-800">Riwayat Belanja</h1>

      {/* Tab Navigasi Horizontal */}
      <div className="flex gap-10 border-b border-gray-100 mb-8 overflow-x-auto">
        {tabs.map((tab) => (
          <button
            key={tab.id}
            onClick={() => setActiveTab(tab.id)}
            className={`pb-4 text-sm font-bold transition-all whitespace-nowrap relative ${
              activeTab === tab.id ? "text-primary-600" : "text-gray-400 hover:text-gray-600"
            }`}
          >
            {tab.label}
            {/* Garis bawah aktif yang lebih smooth */}
            {activeTab === tab.id && (
              <div className="absolute bottom-0 left-0 w-full h-0.5 bg-primary-600 animate-in slide-in-from-left duration-300" />
            )}
          </button>
        ))}
      </div>

      {/* Area Konten */}
      <div className="bg-white rounded-2xl p-2 min-h-100">
        {activeTab === "semua" && <section className="animate-in fade-in duration-500"> {/* Map data pesanan lu */} </section>}
        {activeTab === "pembatalan" && <section className="animate-in fade-in duration-500"> {/* Map data pembatalan */} </section>}
        {activeTab === "ulasan" && <section className="animate-in fade-in duration-500"> {/* Map data ulasan */} </section>}
      </div>
    </div>
  );
};