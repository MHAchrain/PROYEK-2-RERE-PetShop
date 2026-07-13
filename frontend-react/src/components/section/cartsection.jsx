import { useAuth } from "../../context/authcontext";
import { useCartSection } from "../../hooks/usecartsection";
import CartCard from "../ui/cartcard";
import Skeleton from "../ui/skeleton";

export default function CartSection() {
  const { token } = useAuth();
  const { cart, total, isLoading, isCheckingOut, removeItem, updateQty, handleCheckout, navigate } =
    useCartSection({ token });

  if (isLoading) {
    return (
      <div className="mx-auto w-full py-4">
        <Skeleton className="w-48 h-8 mb-6 bg-gray-200" />

        <div className="space-y-4">
          {[1, 2, 3].map((i) => (
            <Skeleton key={i} className="w-full h-32 rounded-3xl bg-gray-100" />
          ))}
        </div>

        <div className="mt-6 flex justify-end">
          <Skeleton className="h-40 w-full max-w-sm rounded-3xl bg-gray-200" />
        </div>
      </div>
    );
  }

  if (!cart || !cart.items || cart.items.length === 0) {
    return (
      <div className="rounded-3xl border border-dashed border-gray-300 bg-white px-6 py-16 text-center">
        <h1 className="font-semibold text-gray-600">Keranjang belanja kamu kosong.</h1>
      </div>
    );
  }

  return (
    <div className="w-full space-y-10">
      <div className="space-y-4">
        {cart?.items?.map((item) => (
          <CartCard
            key={item.id_item}
            item={item}
            removeItem={removeItem}
            updateQty={updateQty}
            variant="responsive"
          />
        ))}
      </div>

      <div className="flex justify-start">
        <button
          onClick={() => navigate("/")}
          className="group flex w-full items-center justify-center gap-2 rounded-2xl font-medium border-2 border-gray-200 px-5 py-3 text-sm text-gray-700 transition-all duration-300 hover:border-primary hover:text-primary hover:shadow-lg active:scale-95 sm:w-auto sm:px-8"
        >
          <span className="transition-transform duration-300 group-hover:-translate-x-1">&larr;</span>
          Kembali Belanja
        </button>
      </div>

      <div className="flex flex-col gap-6 xl:flex-row xl:items-start xl:justify-end">
        <div className="w-full rounded-[28px] border border-gray-200 bg-white p-6 shadow-sm xl:max-w-sm">
          <h3 className="mb-5 text-xl font-bold">Ringkasan Belanja</h3>

          <div className="flex justify-between border-b border-gray-200 pb-3">
            <span>Subtotal:</span>
            <span>Rp {total.toLocaleString("id-ID")}</span>
          </div>

          <div className="flex justify-between border-b border-gray-200 py-3">
            <span>Pengiriman:</span>
            <span className="text-gray-500">Gratis</span>
          </div>

          <div className="flex justify-between pt-3 text-lg font-bold">
            <span>Total:</span>
            <span>Rp {total.toLocaleString("id-ID")}</span>
          </div>

          <button
            onClick={handleCheckout}
            disabled={isCheckingOut}
            className={`mt-5 w-full rounded-2xl bg-primary py-4 font-semibold text-white transition-all ${
              isCheckingOut ? "opacity-50 cursor-not-allowed" : "hover:bg-primary-600"
            }`}
          >
            {isCheckingOut ? "Sedang Diproses..." : "Buat Pesanan"}
          </button>
        </div>
      </div>
    </div>
  );
}
