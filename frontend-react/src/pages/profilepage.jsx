import { useState } from "react";
import AccountLayout from "../components/layouts/accountlayout";
import ProfileSection from "../components/section/profilesection";
import AddressSection from "../components/section/addresssection";
import SecuritySection from "../components/section/securitysection";
import FAQSection from "../components/section/faqsection";
import Skeleton from "../components/ui/skeleton";

export default function ProfilePage() {
  const [activeTab, setActiveTab] = useState("profil");
  const [isLoading] = useState(false);

  return (
    <div className="min-h-screen px-4 py-8 sm:px-6 lg:px-10 xl:px-16">
      <div className="mx-auto max-w-7xl">
        <div className="mb-8 flex items-center gap-4 sm:gap-5">
          <div className="h-10 w-3 rounded-sm bg-primary sm:w-4" />
          {isLoading ? (
            <Skeleton className="h-6 w-40" />
          ) : (
            <div>
              <p className="text-xl font-bold capitalize text-primary sm:text-2xl">Profil</p>
            </div>
          )}
        </div>

        <AccountLayout activeTab={activeTab} setActiveTab={setActiveTab}>
          {activeTab === "profil" && <ProfileSection />}
          {activeTab === "alamat" && <AddressSection />}
          {activeTab === "keamanan" && <SecuritySection />}
          {activeTab === "faq" && <FAQSection />}
        </AccountLayout>
      </div>
    </div>
  );
}
