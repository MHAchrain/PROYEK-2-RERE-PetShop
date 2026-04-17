import { createContext, useContext, useEffect, useState } from "react";
import toast from "react-hot-toast";

const AuthContext = createContext();

export function AuthProvider({ children }) {
    const [user, setUser] = useState(() => {
        const storedUser = localStorage.getItem("user");
        if (storedUser) {
            try {
                return JSON.parse(storedUser);
            } catch (err) {
                return null;
            }
        }
        return null;
    });

    const [token, setToken] = useState(() => localStorage.getItem("token") || null);
    const [loading, setLoading] = useState(false);

    const login = (userData, token) => {
        localStorage.setItem("user", JSON.stringify(userData));
        localStorage.setItem("token", token);
        setUser(userData);
        setToken(token);
    };

    const updateUser = (newData) => {
        setUser((prevUser) => {
        const updatedUser = { ...prevUser, ...newData };
        localStorage.setItem("user", JSON.stringify(updatedUser));
        return updatedUser;
    });
    };

    const logout = async () => {
        setLoading(true);

        await new Promise((res) => setTimeout(res, 500));

        localStorage.removeItem("user");
        localStorage.removeItem("token");
        setUser(null);
        setToken(null);
        toast.success("Berhasil logout");
        setLoading(false);
    };

    return(
        <AuthContext.Provider value={{ user, token, login, logout, loading, updateUser }}>
            {children}
        </AuthContext.Provider>
    )
}

export const useAuth = () => useContext(AuthContext);