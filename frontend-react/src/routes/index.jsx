import { Routes, Route, Navigate, Outlet } from "react-router-dom";
import { useAuth } from "../context/authcontext";

// Import semua halaman dan layout yang dibutuhkan
import Home from "../pages/home";
import AuthPage from "../pages/authpage";
import MainLayout from "../components/layouts/mainlayout";
import CategoryPage from "../pages/categorypage";
import AboutPage from "../pages/aboutpage";
import NotFoundPage from "../pages/notfoundpage";
import ContactPage from "../pages/contactpage";
import ProductPage from "../pages/productpage";
import WishlistPage from "../pages/wishlistpage";
import GroomingPage from "../pages/groomingpage";
import CartPage from "../pages/cartpage";
import ProfilePage from "../pages/profilepage";
import OrderPage from "../pages/orderpage";

// Route yang butuh proteksi (harus login)
const ProtectedRoute = ({ token }) => {
        if (!token) {
            return <Navigate to="/auth" replace />;
        }
        return <Outlet />;
    };

export default function AppRoutes() {
    const { token } = useAuth();

    return(
        <Routes>
            <Route element={<MainLayout />}>
                <Route path="/" element={<Home />} />
                <Route path="/about" element={<AboutPage />} />
                <Route path="/contact" element={<ContactPage />} />
                <Route path="/category/:id" element={<CategoryPage/>} />
                <Route path="/product/:id" element={<ProductPage/>} />
                <Route path="/grooming" element={<GroomingPage/>} />
                <Route element={<ProtectedRoute token={token} />}>
                    <Route path="/wishlist" element={<WishlistPage/>} />
                    <Route path="/cart" element={<CartPage />} />
                    <Route path="/atur-akun" element={<ProfilePage />} />
                    <Route path="/pesanan" element={<OrderPage />} />
                    {/* Lu bisa tambah /pesanan, dsb di sini */}
                </Route>
                <Route path="*" element={<NotFoundPage/>} />
            </Route>
            <Route path="/auth" element={<AuthPage />} />
            <Route path="*" element={<NotFoundPage/>} />
        </Routes>
    )
}