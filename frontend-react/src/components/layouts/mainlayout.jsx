import AnnounceBar from "./announcebar";
import Footer from "./footer";
import Navbar from "./navbar";
import { Outlet } from "react-router-dom";
import { useAuth } from "../../context/authcontext";
import PageLoader from "../pageloader";

export default function MainLayout() {
    const { loading } = useAuth();
    return(
        <div className="min-h-screen flex flex-col">
            {loading && <PageLoader />}
            <AnnounceBar />
            <Navbar />
            <main className="grow flex flex-col">
                <Outlet />
            </main>
            <Footer/>
        </div>
    );
}