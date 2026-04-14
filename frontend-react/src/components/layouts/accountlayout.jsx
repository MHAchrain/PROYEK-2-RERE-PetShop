import SidebarAcc from '../ui/sidebaracc';

export default function AccountLayout({ children, activeTab, setActiveTab }) {
  return (
    <div className="min-h-screen bg-gray-50/50 py-10 px-4">
      <div className="mx-auto flex flex-col md:flex-row gap-8">
        {/* Sidebar di kiri */}
        <SidebarAcc activeTab={activeTab} setActiveTab={setActiveTab} />

        {/* Konten di kanan */}
        <div className="max-w-6xl flex-1 bg-white rounded-2xl shadow-sm border border-gray-100 p-6 md:p-10 min-h-125">
          {children}
        </div>
      </div>
    </div>
  );
};