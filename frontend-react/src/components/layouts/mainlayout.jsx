import AnnounceBar from "./announcebar";
import Footer from "./footer";
import Navbar from "./navbar";
import PromoPopup from "./promopopup";
import { Outlet } from "react-router-dom";
import { useAuth } from "../../context/authcontext";
import PageLoader from "../pageloader";

export default function MainLayout() {
    const { loading } = useAuth();
    return(
        <div className="min-h-screen flex flex-col">
            {loading && <PageLoader />}
            <div className="print:hidden">
                <PromoPopup />
            </div>
            <div className="print:hidden">
                <AnnounceBar />
            </div>
            <div className="print:hidden">
                <Navbar />
            </div>
            <main className="grow flex flex-col print:block">
                <Outlet />
            </main>
            <div className="print:hidden">
                <Footer/>
            </div>
        </div>
    );
}
