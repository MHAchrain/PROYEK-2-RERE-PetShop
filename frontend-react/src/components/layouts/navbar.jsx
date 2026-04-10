import { Link } from "react-router-dom";
import {
  Heart,
  ShoppingCart,
  User,
  Search,
  Package,
  XCircle,
  Star,
  LogOut,
  Menu,
  X,
} from "lucide-react";
import { useAuth } from "../../context/authcontext";
import { useState, useEffect, useRef } from "react";
import { useNavigate } from "react-router-dom";
import logo from "../../assets/logorere.png";
import { useCart } from "../../context/cartcontext";

export default function Navbar() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const { cart } = useCart();
  const [open, setOpen] = useState(false); // dropdown user
  const [mobileOpen, setMobileOpen] = useState(false); // mobile menu
  const dropdownRef = useRef(null);

  // Close dropdown kalau klik luar
  useEffect(() => {
    function handleClickOutside(e) {
      if (dropdownRef.current && !dropdownRef.current.contains(e.target)) {
        setOpen(false);
      }
    }

    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  //buat page items
  const menuItems = [
    { name: "Beranda", path: "/"},
    { name: "Kontak", path: "/contact"},
    { name: "Tentang Kami", path: "/about"},
  ];

  const totalQty = cart?.items?.reduce((sum, item) => {
    return sum + (item.qty || 0);
  }, 0);

  return (
    <nav className="w-full border-b border-gray-200 bg-white z-50 sticky top-0">
      <div className="max-w-7xl mx-auto px-6">
        <div className="flex items-center justify-between h-20">

          {/* Logo */}
          <Link to="/" className="flex items-center gap-2">
            <img src={logo} alt="Logo" className="h-12 w-auto" />
          </Link>

          {/* Desktop Menu */}
          <div className="hidden md:flex items-center gap-12 text-sm font-medium">
            {menuItems.map((item) => (
              <Link 
              key={item.name} 
              to={item.path}
              className="relative group">
                <span className="relative z-10">{item.name}</span>
                <span className="absolute left-0 -bottom-1 h-0.5 w-0 
                              bg-gray-700 transition-all duration-300 
                              group-hover:w-full"></span>
              </Link>
            ))}
          </div>

          {/* Right Section */}
          <div className="flex items-center gap-4 md:gap-8">

            {/* Desktop Search */}
            <div className="hidden md:flex items-center rounded-md px-4 py-2 bg-gray-100">
              <input
                type="text"
                placeholder="What are you looking for?"
                className="bg-transparent outline-none text-sm w-48"
              />
              <Search size={18} className="text-gray-500" />
            </div>

            {user ? (
              <>
                <Heart
                  onClick={() => navigate('/wishlist')}
                  className="cursor-pointer hover:text-primary-600 transition" 
                  size={20} />

                <div 
                  className="relative cursor-pointer group" 
                  onClick={() => navigate('/cart')}
                >
                  <ShoppingCart size={20} className="group-hover:text-primary transition-colors"/>

                  {totalQty > 0 && (
                    <span className="absolute -top-2 -right-2 bg-primary text-white text-xs px-1.5 rounded-full">
                      {totalQty}
                    </span>
                  )}
                </div>

                {/* User Dropdown */}
                <div className="relative" ref={dropdownRef}>
                  <button
                    onClick={() => setOpen(!open)}
                    className="p-2 transition"
                  >
                    <User
                      className="cursor-pointer hover:text-primary-600 transition"
                      size={20}
                    />
                  </button>

                  <div
                    className={`absolute right-0 top-full mt-3 w-56
                    backdrop-blur-xl bg-white/20
                    border border-white/30 shadow-xl rounded-xl
                    transition-all duration-200 z-50
                    ${
                      open
                        ? "opacity-100 translate-y-0 pointer-events-auto"
                        : "opacity-0 translate-y-2 pointer-events-none"
                    }`}
                  >
                    <div className=" text-white bg-black/30 rounded-xl">

                      {[
                        { icon: <User size={18} />, label: "Atur Akun" },
                        { icon: <Package size={18} />, label: "Pesanan" },
                        { icon: <XCircle size={18} />, label: "Pembatalan" },
                        { icon: <Star size={18} />, label: "Ulasan" },
                      ].map((item) => (
                        <Link
                          key={item.label}
                          className="flex items-center gap-3 px-4 py-3 w-full hover:bg-white/20 transition rounded-lg"
                        >
                          {item.icon}
                          <span>{item.label}</span>
                        </Link>
                      ))}

                      <button
                        onClick={logout}
                        className="w-full flex items-center gap-3 px-4 py-3 hover:bg-primary/30 transition rounded-lg"
                      >
                        <LogOut size={18} />
                        <span>Keluar</span>
                      </button>
                    </div>
                  </div>
                </div>
              </>
            ) : (
              <Link
                to="/auth"
                className="hidden md:block px-4 py-2 bg-primary text-white rounded-md hover:opacity-90 transition"
              >
                Masuk
              </Link>
            )}

            {/* Hamburger */}
            <button
              className="md:hidden"
              onClick={() => setMobileOpen(!mobileOpen)}
            >
              {mobileOpen ? <X size={24} /> : <Menu size={24} />}
            </button>
          </div>
        </div>
      </div>

      {/* Mobile Menu */}
      <div
        className={`md:hidden overflow-hidden transition-all duration-300 bg-white border-t border-gray-200 ${
          mobileOpen ? "max-h-96 py-4" : "max-h-0"
        }`}
      >
        <div className="flex flex-col gap-4 px-6 text-sm font-medium">
          {/* Mobile Search */}
          <div className="flex items-center rounded-md px-4 py-2 bg-gray-100 mt-2">
            <input
              type="text"
              placeholder="What are you looking for?"
              className="bg-transparent outline-none text-sm w-full"
            />
            <Search size={18} className="text-gray-500" />
          </div>
          {menuItems.map((item) => (
            <Link
              key={item.name}
              to={item.path}
              onClick={() => setMobileOpen(false)}
              className="py-2 hover:text-primary hover:font-semibold"
            >
              {item.name}
            </Link>
          ))}
          {!user && (
            <Link
              to="/auth"
              onClick={() => setMobileOpen(false)}
              className="px-4 py-2 bg-primary text-white rounded-md text-center"
            >
              Masuk
            </Link>
          )}
        </div>
      </div>
    </nav>
  );
}