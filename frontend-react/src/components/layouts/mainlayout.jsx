import AnnounceBar from "./announcebar";
import Footer from "./footer";
import Navbar from "./navbar";
import { Outlet } from "react-router-dom";

export default function MainLayout() {
    return(
        <div className="min-h-screen flex flex-col">
        <>
            <AnnounceBar />
            <Navbar />
            <main className="flex-1">
                <Outlet />
            </main>
            <Footer/>
        </>
        </div>
    );
}