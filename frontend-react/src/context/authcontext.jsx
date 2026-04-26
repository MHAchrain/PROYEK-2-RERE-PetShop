import { createContext, useContext, useEffect, useState } from "react";
import toast from "../utils/toast.jsx";
import api from "../api/axios";
import { AUTH_SESSION_EXPIRED_EVENT } from "../utils/appconfig";

const AuthContext = createContext();

const mergeNested = (previousValue, nextValue) => {
    if (!nextValue) return previousValue;
    if (!previousValue || typeof previousValue !== "object" || typeof nextValue !== "object") {
        return nextValue;
    }

    return { ...previousValue, ...nextValue };
};

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
            if (!prevUser) {
                localStorage.setItem("user", JSON.stringify(newData));
                return newData;
            }

            const updatedUser = {
                ...prevUser,
                ...newData,
                user: mergeNested(prevUser.user, newData?.user),
                pelanggan: mergeNested(prevUser.pelanggan, newData?.pelanggan),
                data: mergeNested(prevUser.data, newData?.data),
            };

            if (updatedUser.data) {
                updatedUser.data = {
                    ...updatedUser.data,
                    user: mergeNested(prevUser.data?.user, newData?.data?.user ?? newData?.user),
                    pelanggan: mergeNested(prevUser.data?.pelanggan, newData?.data?.pelanggan ?? newData?.pelanggan),
                };
            }

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

    useEffect(() => {
        const handleSessionExpired = () => {
            localStorage.removeItem("user");
            localStorage.removeItem("token");
            setUser(null);
            setToken(null);
            toast.error("Sesi login berakhir. Silakan masuk lagi.");
        };

        window.addEventListener(AUTH_SESSION_EXPIRED_EVENT, handleSessionExpired);

        return () => {
            window.removeEventListener(AUTH_SESSION_EXPIRED_EVENT, handleSessionExpired);
        };
    }, []);

    useEffect(() => {
        if (!token) return;

        const syncUser = async () => {
            try {
                const res = await api.get("/me");

                if (res.data?.success && res.data?.data) {
                    localStorage.setItem("user", JSON.stringify(res.data.data));
                    setUser(res.data.data);
                }
            } catch (error) {
                localStorage.removeItem("user");
                localStorage.removeItem("token");
                setUser(null);
                setToken(null);
            }
        };

        syncUser();
    }, [token]);

    return(
        <AuthContext.Provider value={{ user, token, login, logout, loading, updateUser }}>
            {children}
        </AuthContext.Provider>
    )
}

export const useAuth = () => useContext(AuthContext);


