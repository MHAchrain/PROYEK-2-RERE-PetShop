import SidebarAcc from "../ui/sidebaracc";

export default function AccountLayout({ children, activeTab, setActiveTab }) {
  return (
    <div className="rounded-4xl border border-gray-200 bg-[linear-gradient(180deg,#fffdf8_0%,#f8fafc_100%)] p-3 shadow-sm sm:p-4 lg:p-5">
      <div className="mx-auto flex flex-col gap-4 lg:flex-row lg:items-start lg:gap-6">
        <SidebarAcc activeTab={activeTab} setActiveTab={setActiveTab} />

        <div className="min-h-128 flex-1 rounded-[28px] border border-white/70 bg-white p-5 shadow-[0_18px_60px_rgba(15,23,42,0.06)] sm:p-6 lg:p-8">
          {children}
        </div>
      </div>
    </div>
  );
}
