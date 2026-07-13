import {
  Truck,
  RefreshCcw,
  Heart,
  Plus,
  Minus,
  PackageCheck,
  PackageX,
} from 'lucide-react';
export default function ProductDetail({
  product,
  qty,
  setQty,
  onBuyNow,
  onAddToWishlist,
  isBuyingNow = false,
  isWishlistLoading = false,
  isWishlisted = false,
}) {
  const safeStock = Number(product.stock) || 0;
  const isOutOfStock = safeStock < 1;
  const isAtMaxQty = qty >= safeStock && safeStock > 0;

  return (
    <div className="w-full">
      <h1 className="text-2xl md:text-2xl lg:text-3xl font-semibold leading-tight">
        {product.name}
      </h1>

      <div className="mt-3 flex flex-wrap items-center gap-3">
        <span
          className={`inline-flex items-center gap-2 rounded-full px-3 py-1.5 text-sm font-semibold ${
            isOutOfStock
              ? 'bg-rose-50 text-rose-600 ring-1 ring-rose-100'
              : 'bg-emerald-50 text-emerald-700 ring-1 ring-emerald-100'
          }`}>
          {isOutOfStock ? <PackageX size={16} /> : <PackageCheck size={16} />}
          {isOutOfStock ? 'Stok Habis' : `${safeStock} stok tersedia`}
        </span>
      </div>

      <p className="text-2xl md:text-3xl font-bold mt-4 text-primary">
        Rp {product.price.toLocaleString()}
      </p>

      {product.description && (
        <p className="mt-4 text-gray-600 text-sm md:text-base leading-relaxed max-w-xl">
          {product.description}
        </p>
      )}

      <hr className="my-6 border-gray-200" />

      <div className="flex flex-col sm:flex-row items-stretch sm:items-center gap-4 mt-6">
        <div
          className={`flex h-12 w-full items-stretch overflow-hidden rounded-md border shadow-sm sm:w-fit ${
            isOutOfStock
              ? 'border-gray-200 bg-gray-100'
              : 'border-gray-300 bg-white'
          }`}>
          <button
            type="button"
            onClick={() => setQty(Math.max(1, qty - 1))}
            disabled={isOutOfStock || qty <= 1}
            className="flex-1 sm:w-12 flex items-center justify-center hover:bg-gray-100 active:bg-primary active:text-white transition-all disabled:cursor-not-allowed disabled:bg-gray-100 disabled:text-gray-300">
            <Minus size={20} />
          </button>

          <div
            className={`flex flex-1 items-center justify-center border-x px-4 text-lg font-bold sm:min-w-20 ${
              isOutOfStock
                ? 'border-gray-200 bg-gray-100 text-gray-400 text-sm'
                : 'border-gray-300 bg-white text-gray-900'
            }`}>
            {isOutOfStock ? 'Habis' : qty}
          </div>

          <button
            type="button"
            onClick={() => setQty(qty + 1)}
            disabled={isOutOfStock || isAtMaxQty}
            className="flex-1 sm:w-12 flex items-center justify-center hover:bg-gray-100 active:bg-primary active:text-white transition-all disabled:cursor-not-allowed disabled:bg-gray-100 disabled:text-gray-300">
            <Plus size={20} />
          </button>
        </div>

        <div className="flex flex-1 gap-3">
          <button
            type="button"
            onClick={onBuyNow}
            disabled={isOutOfStock || isBuyingNow}
            className="min-w-40 max-w-60 h-12 bg-primary text-white px-6 rounded-md hover:bg-primary/90 shadow-md active:scale-95 transition-all text-sm md:text-base disabled:cursor-not-allowed disabled:bg-gray-300 disabled:shadow-none">
            {isOutOfStock
              ? 'Stok Habis'
              : isBuyingNow
                ? 'Memproses...'
                : 'Beli Sekarang'}
          </button>

          <button
            type="button"
            onClick={onAddToWishlist}
            disabled={isWishlistLoading}
            className={`h-12 w-12 flex items-center justify-center rounded-md transition-all group ${
              isWishlisted
                ? 'border border-primary bg-primary/10 text-primary'
                : 'border border-gray-300 hover:border-primary hover:text-primary'
            } ${isWishlistLoading ? 'cursor-not-allowed opacity-70' : ''}`}
            title={isWishlisted ? 'Sudah di Wishlist' : 'Tambah ke Wishlist'}>
            <Heart
              size={22}
              className={`transition-all ${
                isWishlisted
                  ? 'fill-primary text-primary'
                  : 'group-active:fill-primary'
              }`}
            />
          </button>
        </div>
      </div>

      <div className="w-full sm:max-w-100 border border-gray-300 rounded-xl mt-10 overflow-hidden shadow-sm">
        <div className="flex items-center gap-4 p-4 md:p-5 hover:bg-gray-50 transition-colors">
          <div className="p-2 bg-primary/10 rounded-lg text-primary shrink-0">
            <Truck size={32} className="md:w-10 md:h-10" />
          </div>
          <div className="flex flex-col">
            <h3 className="font-bold text-gray-800 text-sm md:text-base leading-none mb-1">
              Gratis Ongkir
            </h3>
            <p className="text-xs md:text-sm text-gray-500">
              Gratis pengiriman untuk belanja di atas Rp 200.000
            </p>
          </div>
        </div>

        <div className="border-t border-gray-300"></div>

        <div className="flex items-center gap-4 p-4 md:p-5 hover:bg-gray-50 transition-colors">
          <div className="p-2 bg-primary/10 rounded-lg text-primary shrink-0">
            <RefreshCcw size={32} className="md:w-10 md:h-10" />
          </div>
          <div className="flex flex-col">
            <h3 className="font-bold text-gray-800 text-sm md:text-base leading-none mb-1">
              Retur Mudah
            </h3>
            <p className="text-xs md:text-sm text-gray-500">
              Kebijakan retur hingga 30 hari
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
