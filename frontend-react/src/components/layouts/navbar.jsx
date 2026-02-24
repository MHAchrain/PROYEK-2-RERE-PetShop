import { Link } from "react-router-dom";
import { Heart, ShoppingCart, User, Search } from "lucide-react";

export default function Navbar() {
  return (
    <nav className="w-full border-b border-gray-300">
      <div className="max-w-7xl mx-auto px-6">
        <div className="flex items-center justify-between h-22">
          
          {/* Logo */}
          <div className="flex items-center gap-2">
            <a href="#">
                <img src="./src/assets/logorere.png" alt="Logo" className="h-18 w-18" />
            </a>
          </div>

          {/* Menu */}
          <div className="hidden md:flex items-center gap-12 text-sm font-medium">
            <Link to="#" className="relative group">
                <span className="relative z-10">Home</span>
                <span className="absolute left-0 -bottom-1 h-0.5 w-0 bg-gray-700 transition-all duration-500 ease-out group-hover:w-full"></span>
            </Link>
            <Link to="#" className="relative group">
                <span className="relative z-10">Contact</span>
                <span className="absolute left-0 -bottom-1 h-0.5 w-0 bg-gray-700 transition-all duration-500 ease-out group-hover:w-full"></span>
            </Link>
            <Link to="#" className="relative group">
                <span className="relative z-10">About</span>
                <span className="absolute left-0 -bottom-1 h-0.5 w-0 bg-gray-700 transition-all duration-500 ease-out group-hover:w-full"></span>
            </Link>
            <Link to="#" className="relative group">
                <span className="relative z-10">Sign Up</span>
                <span className="absolute left-0 -bottom-1 h-0.5 w-0 bg-gray-700 transition-all duration-500 ease-out group-hover:w-full"></span>
            </Link>
          </div>

          {/* Right Section */}
          <div className="flex items-center gap-8">
            
            {/* Search */}
            <div className="hidden md:flex items-center rounded-md px-4 py-2 bg-gray-200">
              <input
                type="text"
                placeholder="What are you looking for?"
                className="bg-transparent outline-none text-sm w-48"
              />
              <Search size={18} className="text-gray-500" />
            </div>

            {/* Icons */}
            <Heart className="cursor-pointer hover:text-red-600 transition" size={20} />

            <div className="relative cursor-pointer">
              <ShoppingCart size={20} />
              <span className="absolute -top-2 -right-2 bg-red-600 text-white text-xs px-1.5 rounded-full">
                2
              </span>
            </div>

            <User className="cursor-pointer hover:text-red-600 transition" size={20} />
          </div>
        </div>
      </div>
    </nav>
  );
}