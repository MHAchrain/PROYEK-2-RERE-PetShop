import CartSection from "../components/section/cartsection";

export default function CartPage() {
  return (
    <div className="min-h-screen flex flex-col my-15 mx-20">
        <div className="w-full px-4 md:px-10 space-y-4">

            <div className="flex items-center gap-5">
                <div className="bg-primary w-5 h-10 rounded-sm"></div>
                <p className="text-primary font-semibold">
                    Keranjang
                </p>
            </div>

            <CartSection />

        </div>
    </div>
  );
}