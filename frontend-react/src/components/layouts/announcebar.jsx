import { useState, useEffect } from "react";

export default function AnnounceBar() {
    const [isOpen, setIsOpen] = useState(false);
    const [visible, setVisible] = useState(false);

    useEffect(() => {
        const timer = setTimeout(()=> {
            setIsOpen(true);
            setTimeout(() => setVisible(true), 50);
        }, 2000);
        return () => clearTimeout(timer);
    }, []);

    const handleClose = () => {
        setVisible(false);
        setTimeout(() => {
        setIsOpen(false);
        }, 500);
    };

    if(!isOpen) return null;

    return(
        <div className={`bg-primary text-white
                left-0 w-full z-50 transform
                transition-all duration-500 ease-in-out
                ${visible ? "translate-y-0 opacity-100":"-translate-y-full opacity-0"}`}>
            
            <div className="relative w-full py-3">

                <p className="text-sm font-medium text-center px-12">
                    ⚡ Flash Sale! Dapatkan diskon hingga 50% untuk produk pilihan. Jangan lewatkan kesempatan ini! ⚡
                </p>

                <button onClick={handleClose}
                    className="absolute top-1/2 right-6 -translate-y-1/2 text-lg font-bold hover:opacity-70">
                    x
                </button>
            </div>
        </div>
    );
}