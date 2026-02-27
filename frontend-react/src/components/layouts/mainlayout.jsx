import AnnounceBar from "./announcebar";
import Navbar from "./navbar";
import { Outlet } from "react-router-dom";

export default function MainLayout() {
    return(
        <>
            <AnnounceBar />
            <Navbar />
            <Outlet />
        </>
    );
}