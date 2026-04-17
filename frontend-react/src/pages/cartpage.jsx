import CartSection from "../components/section/cartsection";
import Skeleton from "../components/ui/skeleton";
import { useEffect, useState } from "react";

export default function CartPage() {
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        const timer = setTimeout(() => {
        setIsLoading(false);
        }, 2000);

        return () => clearTimeout(timer);
    }, []);


    return (
        <div className="min-h-screen px-4 py-10 md:px-8 lg:px-16 xl:px-20">
            <div className="mx-auto w-full max-w-7xl space-y-6">

                <div className="flex items-center gap-5">
                    <div className="bg-primary w-5 h-10 rounded-sm"></div>
                    {isLoading ? (
                        <Skeleton className="w-40 h-6" />
                        ) : (
                        <p className="text-xl font-bold capitalize text-primary sm:text-2xl">
                            Keranjang
                        </p>
                    )}
                </div>

                <CartSection />

            </div>
        </div>
    );
}
