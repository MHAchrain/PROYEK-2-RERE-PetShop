import { useState } from "react";

export default function AnnounceBar() {
    const [isOpen, setIsOpen] = useState(true);

    if(!isOpen) return null;

    return(
        <div className="bg-primary text-white text-center py-2 px-4 flex justify-between items-center">
            <p className="text-sm font-medium">
                ⚡ Flash Sale! Dapatkan diskon hingga 50% untuk produk pilihan. Jangan lewatkan kesempatan ini! ⚡
            </p>

            <button onClick={() => setIsOpen(false)}
                className="text-lg font-bold hover:opacity-70 cursor-pointer">
                x
            </button>
        </div>
    );
}