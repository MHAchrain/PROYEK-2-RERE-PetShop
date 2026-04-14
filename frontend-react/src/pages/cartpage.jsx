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
        <div className="min-h-screen flex flex-col my-15 mx-20">
            <div className="w-full px-4 md:px-10 space-y-4">

                <div className="flex items-center gap-5">
                    <div className="bg-primary w-5 h-10 rounded-sm"></div>
                    {isLoading ? (
                        <Skeleton className="w-40 h-6" />
                        ) : (
                        <p className="text-primary font-semibold capitalize">
                            Keranjang
                        </p>
                    )}
                </div>

                <CartSection />

            </div>
        </div>
    );
}