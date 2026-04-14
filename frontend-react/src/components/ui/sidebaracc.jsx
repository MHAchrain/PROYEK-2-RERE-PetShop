import { User, MapPin, ShieldCheck, HelpCircle } from 'lucide-react';

export default function SidebarAcc({ activeTab, setActiveTab }) {
  const menuSidebar = [
    { id: 'profil', label: 'Profil Saya', icon: <User size={18} /> },
    { id: 'alamat', label: 'Alamat', icon: <MapPin size={18} /> },
    { id: 'keamanan', label: 'Keamanan', icon: <ShieldCheck size={18} /> },
    { id: 'faq', label: 'FAQ', icon: <HelpCircle size={18} /> },
  ];

  return (
    <div className="w-full md:w-64 space-y-2">
      <div className="flex flex-col gap-1">
        {menuSidebar.map((item) => (
          <button
            key={item.id}
            onClick={() => setActiveTab(item.id)}
            className={`w-full flex items-center gap-3 px-4 py-3 rounded-xl transition-all ${
              activeTab === item.id 
              ? "bg-white shadow-sm text-primary font-semibold" 
              : "text-gray-500 hover:bg-gray-100"
            }`}
          >
            {item.icon}
            <span className="text-sm">{item.label}</span>
          </button>
        ))}
      </div>
    </div>
  );
};

