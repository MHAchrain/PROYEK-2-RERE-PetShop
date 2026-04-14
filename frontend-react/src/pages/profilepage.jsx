import { useState } from 'react';
import AccountLayout from '../components/layouts/accountlayout';
import ProfileSection from '../components/section/profilesection';
import AddressSection from '../components/section/addresssection';
import SecuritySection from '../components/section/securitysection';
import FAQSection from '../components/section/faqsection';
import Skeleton from '../components/ui/skeleton';

export default function ProfilePage () {
  const [activeTab, setActiveTab] = useState('profil');
  const [isLoading, setIsLoading] = useState(false);

  return (

    <div className="min-h-screen flex flex-col my-15 mx-20">

        <div className="flex items-center gap-5">
            <div className="bg-primary w-5 h-10 rounded-sm"></div>
            {isLoading ? (
                <Skeleton className="w-40 h-6" />
                ) : (
                <p className="text-primary font-semibold capitalize">
                    Profil
                </p>
            )}
        </div>

        <AccountLayout activeTab={activeTab} setActiveTab={setActiveTab}>
        {activeTab === 'profil' && <ProfileSection />}
        {activeTab === 'alamat' && <AddressSection />}
        {activeTab === 'keamanan' && <SecuritySection />}
        {activeTab === 'faq' && <FAQSection />}
        </AccountLayout>
    </div>
  );
};