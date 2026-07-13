import { Link, useLocation, useNavigate } from "react-router-dom";
import { Heart, ShoppingCart, User, Search, Package, LogOut, Menu, X } from "lucide-react";
import { useAuth } from "../../context/authcontext";
import logo from "../../assets/logorere.png";
import { useCart } from "../../context/cartcontext";
import { accountMenuItems, menuItems } from "../../constants/navbaritems";
import { useNavbarState } from "../../hooks/usenavbarstate";
import { useNavbarSearch } from "../../hooks/usenavbarsearch";

export default function Navbar() {
  const { user, logout } = useAuth();
  const navigate = useNavigate();
  const location = useLocation();
  const { cart } = useCart();
  const { open, setOpen, mobileOpen, setMobileOpen, dropdownRef } = useNavbarState();
  const {
    desktopQuery,
    setDesktopQuery,
    mobileQuery,
    setMobileQuery,
    handleDesktopSubmit,
    handleMobileSubmit,
  } = useNavbarSearch(setMobileOpen);

  const totalQty = cart?.items?.reduce((sum, item) => sum + (item.qty || 0), 0);

  return (
    <nav className="w-full border-b border-gray-200 bg-white z-50 sticky top-0 shadow-sm">
      <div className="max-w-7xl mx-auto px-6">
        <div className="flex items-center justify-between h-20">
          <Link to="/" className="flex items-center gap-2">
            <img src={logo} alt="Logo" className="h-12 w-auto" />
          </Link>

          <div className="hidden md:flex items-center gap-12 text-sm font-medium">
            {menuItems.map((item) => {
              const isActive = location.pathname === item.path;

              return (
                <Link
                  key={item.name}
                  to={item.path}
                  className={`relative group transition-colors duration-300 ${
                    isActive ? "text-primary" : "text-gray-600 hover:text-black"
                  }`}
                >
                  <span className="relative z-10">{item.name}</span>
                  <span
                    className={`absolute left-0 -bottom-1 h-0.5 bg-current transition-all duration-300 ${
                      isActive ? "w-full" : "w-0 group-hover:w-full"
                    }`}
                  ></span>
                </Link>
              );
            })}
          </div>

          <div className="flex items-center gap-4 md:gap-8">
            <form
              onSubmit={handleDesktopSubmit}
              className="hidden md:flex items-center rounded-md px-4 py-2 bg-gray-100"
            >
              <input
                type="search"
                placeholder="Apa yang kamu cari?"
                value={desktopQuery}
                onChange={(event) => setDesktopQuery(event.target.value)}
                autoComplete="off"
                maxLength={80}
                className="bg-transparent outline-none text-sm w-48"
              />
              <button type="submit" className="text-gray-500 transition hover:text-black" aria-label="Cari produk">
                <Search size={18} className="text-current" />
              </button>
            </form>

            {user ? (
              <>
                <Heart
                  onClick={() => navigate("/wishlist")}
                  className="cursor-pointer hover:text-primary transition"
                  size={20}
                />

                <div className="relative cursor-pointer group" onClick={() => navigate("/cart")}>
                  <ShoppingCart size={20} className="group-hover:text-primary transition-colors" />

                  {totalQty > 0 && (
                    <span className="absolute -top-2 -right-2 bg-primary text-white text-xs px-1.5 rounded-full">
                      {totalQty}
                    </span>
                  )}
                </div>

                <div className="relative" ref={dropdownRef}>
                  <button onClick={() => setOpen(!open)} className="cursor-pointer p-2">
                    <User
                      className={`transition hover:text-primary ${open ? "text-primary" : "text-black"}`}
                      size={20}
                    />
                  </button>

                  <div
                    className={`absolute right-0 top-full mt-2 w-56 bg-white border border-gray-100 shadow-2xl rounded-xl transition-all duration-200 z-50 ${
                      open
                        ? "opacity-100 translate-y-0 pointer-events-auto"
                        : "opacity-0 translate-y-2 pointer-events-none"
                    }`}
                  >
                    <div className="p-1.5 text-gray-700">
                      {accountMenuItems.map((item) => (
                        <Link
                          key={item.label}
                          to={item.path}
                          onClick={() => setOpen(false)}
                          className="flex items-center gap-3 px-4 py-2.5 w-full hover:bg-gray-200 hover:text-primary transition rounded-lg group"
                        >
                          <span className="text-gray-400 group-hover:text-primary">
                            {item.iconKey === "user" ? <User size={18} /> : <Package size={18} />}
                          </span>
                          <span className="text-sm font-medium">{item.label}</span>
                        </Link>
                      ))}

                      <hr className="my-1.5 border-gray-100" />

                      <button
                        onClick={logout}
                        className="w-full flex items-center gap-3 px-4 py-2.5 text-red-500 hover:bg-red-100 transition rounded-lg"
                      >
                        <LogOut size={18} />
                        <span className="text-sm font-medium">Keluar</span>
                      </button>
                    </div>
                  </div>
                </div>
              </>
            ) : (
              <Link
                to="/auth"
                className="hidden md:block px-4 py-2 bg-primary font-semibold text-white rounded-md hover:bg-primary-600 transition"
              >
                Masuk
              </Link>
            )}

            <button className="md:hidden" onClick={() => setMobileOpen(!mobileOpen)}>
              {mobileOpen ? <X size={24} /> : <Menu size={24} />}
            </button>
          </div>
        </div>
      </div>

      <div
        className={`md:hidden overflow-hidden transition-all duration-300 bg-white border-t border-gray-200 ${
          mobileOpen ? "max-h-96 py-4" : "max-h-0"
        }`}
      >
        <div className="flex flex-col gap-4 px-6 text-sm font-medium">
          <form onSubmit={handleMobileSubmit} className="flex items-center rounded-md px-4 py-2 bg-gray-100 mt-2">
            <input
              type="search"
              placeholder="Apa yang kamu cari?"
              value={mobileQuery}
              onChange={(event) => setMobileQuery(event.target.value)}
              autoComplete="off"
              maxLength={80}
              className="bg-transparent outline-none text-sm w-full"
            />
            <button type="submit" className="text-gray-500 transition hover:text-black" aria-label="Cari produk">
              <Search size={18} className="text-current" />
            </button>
          </form>

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
              className="px-4 py-2 bg-primary font-semibold text-white rounded-md text-center"
            >
              Masuk
            </Link>
          )}
        </div>
      </div>
    </nav>
  );
}
