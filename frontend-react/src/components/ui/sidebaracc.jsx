import { User, MapPin, ShieldCheck, HelpCircle } from "lucide-react";

export default function SidebarAcc({ activeTab, setActiveTab }) {
  const menuSidebar = [
    { id: "profil", label: "Profil Saya", icon: <User size={18} /> },
    { id: "alamat", label: "Alamat", icon: <MapPin size={18} /> },
    { id: "keamanan", label: "Keamanan", icon: <ShieldCheck size={18} /> },
    { id: "faq", label: "FAQ", icon: <HelpCircle size={18} /> },
  ];

  return (
    <div className="w-full lg:w-72">
      <div className="rounded-[28px] border border-white/70 bg-white/90 p-3 shadow-[0_12px_40px_rgba(15,23,42,0.06)] backdrop-blur-sm">
        <div className="mb-3 px-2">
          <p className="text-xs font-semibold uppercase tracking-[0.18em] text-primary/70">Navigasi Akun</p>
          <p className="mt-1 text-sm text-gray-500">Pilih menu yang ingin kamu kelola.</p>
        </div>

        <div className="grid grid-cols-2 gap-2 sm:grid-cols-4 lg:grid-cols-1">
          {menuSidebar.map((item) => (
            <button
              key={item.id}
              type="button"
              onClick={() => setActiveTab(item.id)}
              className={`w-full rounded-2xl px-4 py-3 text-left transition-all ${
                activeTab === item.id
                  ? "bg-primary text-white shadow-lg shadow-primary/20"
                  : "text-gray-500 hover:bg-gray-100"
              }`}
            >
              <div className="flex items-center gap-3">
                <span className={activeTab === item.id ? "text-white" : "text-primary"}>{item.icon}</span>
                <span className="text-sm font-semibold leading-tight">{item.label}</span>
              </div>
            </button>
          ))}
        </div>
      </div>
    </div>
  );
}
