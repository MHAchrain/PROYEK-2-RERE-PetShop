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
      <div className="container mx-auto py-8 px-4">
        <Skeleton className="w-48 h-8 mb-6 bg-gray-200" />

        <div className="space-y-4">
          {[1, 2, 3].map((i) => (
            <Skeleton key={i} className="w-full h-24 rounded-lg bg-gray-100" />
          ))}
        </div>

        <div className="mt-6 flex justify-end">
          <Skeleton className="w-64 h-10 bg-gray-200" />
        </div>
      </div>
    );
  }

  if (!cart || !cart.items || cart.items.length === 0) {
    return (
      <div className="container mx-auto">
        <h1 className="font-semibold text-center text-gray-600">Keranjang belanja Anda kosong.</h1>
      </div>
    );
  }

  return (
    <div className="w-full space-y-10">
      <div className="overflow-x-auto">
        <table className="w-full border-separate border-spacing-y-4">
          <thead>
            <tr className="text-left bg-white">
              <th className="py-4 px-6 font-medium">Product</th>
              <th className="py-4 px-6 font-medium">Price</th>
              <th className="py-4 px-6 font-medium">Quantity</th>
              <th className="py-4 px-6 font-medium text-right">Subtotal</th>
            </tr>
          </thead>
          <tbody>
            {cart?.items?.map((item) => (
              <CartCard key={item.id_item} item={item} removeItem={removeItem} updateQty={updateQty} />
            ))}
          </tbody>
        </table>
      </div>

      <div className="flex justify-between items-center">
        <button
          onClick={() => navigate("/")}
          className="group flex items-center gap-2 px-8 py-3 border-2 border-gray-200 rounded-lg text-gray-700 font-bold transition-all duration-300 hover:border-primary hover:text-primary hover:shadow-lg active:scale-95"
        >
          <span className="transition-transform duration-300 group-hover:-translate-x-1">&larr;</span>
          Return To Shop
        </button>
      </div>

      <div className="flex flex-col lg:flex-row justify-between gap-10 items-start">
        <div className="flex gap-4 w-full lg:w-auto">
          <input
            type="text"
            placeholder="Coupon Code"
            className="px-4 py-3 border border-gray-400 rounded w-full lg:w-64 outline-none focus:border-black"
          />
          <button className="px-6 py-3 bg-[#8B100E] text-white rounded font-medium whitespace-nowrap">
            Apply Coupon
          </button>
        </div>

        <div className="border-2 border-gray-400 p-6 rounded-md w-full lg:w-96 space-y-4">
          <h3 className="text-xl font-bold mb-4">Cart Total</h3>

          <div className="flex justify-between border-b pb-3 border-gray-300">
            <span>Subtotal:</span>
            <span>Rp {total.toLocaleString("id-ID")}</span>
          </div>

          <div className="flex justify-between border-b pb-3 border-gray-300">
            <span>Shipping:</span>
            <span className="text-gray-500">Free</span>
          </div>

          <div className="flex justify-between font-bold text-lg pt-2">
            <span>Total:</span>
            <span>Rp {total.toLocaleString("id-ID")}</span>
          </div>

          <button
            onClick={handleCheckout}
            disabled={isCheckingOut}
            className={`w-full py-4 bg-primary text-white rounded font-medium mt-4 transition-all ${
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
