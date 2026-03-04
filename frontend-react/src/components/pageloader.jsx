import { useEffect, useState } from "react";
import { useLocation } from "react-router-dom";
import "nprogress/nprogress.css";

export default function PageLoader() {
    const location = useLocation();
    const [loading, setLoading] = useState(false);

    useEffect(() => {
        setLoading(true);

        const timer = setTimeout(() => {
            setLoading(false);
        }, 1000);

        return () => clearTimeout(timer);
    }, [location]);

    if (!loading) return null;

    return (
        <div className="fixed inset-0 bg-white z-9999 flex items-center justify-center">
            <div className="w-12 h-12 border-4 border-gray-300 border-t-primary rounded-full animate-spin"></div>
        </div>
    );
}