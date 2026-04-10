import { Routes, Route } from "react-router-dom";
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

export default function AppRoutes() {
    return(
        <Routes>
            <Route element={<MainLayout />}>
                <Route path="/" element={<Home />} />
                <Route path="/about" element={<AboutPage />} />
                <Route path="/contact" element={<ContactPage />} />
                <Route path="/category/:id" element={<CategoryPage/>} />
                <Route path="/product/:id" element={<ProductPage/>} />
                <Route path="/wishlist" element={<WishlistPage/>} />
                <Route path="/grooming" element={<GroomingPage/>} />
                <Route path="/cart" element={<CartPage/>} />

                {/* Taro di paling bawah */}
                <Route path="*" element={<NotFoundPage/>} />
            </Route>
            
            <Route path="/auth" element={<AuthPage />} />
            
            {/* Taro di paling bawah */}
            <Route path="*" element={<NotFoundPage/>} />
        </Routes>
    )
}