import { Routes, Route } from "react-router-dom";
import Home from "../pages/home";
import AuthPage from "../pages/authpage";
import MainLayout from "../components/layouts/mainlayout";
export default function AppRoutes() {
    return(
        <Routes>
            <Route element={<MainLayout />}>
                <Route path="/" element={<Home />} />
            </Route>
            
            <Route path="/auth" element={<AuthPage />} />
        </Routes>
    )
}