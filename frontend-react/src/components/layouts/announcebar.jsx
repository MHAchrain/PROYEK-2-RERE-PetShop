import { useEffect, useState } from "react";
import { PackageCheck, X } from "lucide-react";

export default function AnnounceBar() {
    const [isOpen, setIsOpen] = useState(false);
    const [visible, setVisible] = useState(false);

    useEffect(() => {
        const timer = setTimeout(() => {
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

    if (!isOpen) return null;

    return (
        <div
            className={`left-0 z-50 w-full transform bg-[linear-gradient(90deg,#6f0707_0%,#850909_45%,#a20f0f_100%)] text-white shadow-sm transition-all duration-500 ease-in-out ${
                visible ? "translate-y-0 opacity-100" : "-translate-y-full opacity-0"
            }`}
        >
            <div className="relative w-full overflow-hidden py-3">
                <div className="pointer-events-none absolute inset-y-0 left-0 w-1/3 bg-[linear-gradient(90deg,rgba(255,255,255,0.16),transparent)]" />

                <div className="relative mx-auto flex max-w-7xl items-center justify-center gap-2 px-12 text-center">
                    <span className="hidden h-6 w-6 shrink-0 items-center justify-center rounded-full bg-white/15 text-white ring-1 ring-white/20 sm:inline-flex">
                        <PackageCheck size={14} />
                    </span>

                    <p className="truncate text-sm font-semibold">
                        Produk pilihan minggu ini sudah tersedia, dari makanan harian sampai aksesori favorit anabul.
                    </p>
                </div>

                <button
                    type="button"
                    onClick={handleClose}
                    className="absolute right-4 top-1/2 inline-flex h-7 w-7 -translate-y-1/2 items-center justify-center rounded-full bg-white/10 text-white transition hover:bg-white/20 sm:right-6"
                    aria-label="Tutup pengumuman"
                >
                    <X size={15} />
                </button>
            </div>
        </div>
    );
}
