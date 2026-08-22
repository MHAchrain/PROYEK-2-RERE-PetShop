import { getStorageUrl } from '../../utils/appconfig';

export default function CartCard({
  item,
  removeItem,
  updateQty,
  variant = 'responsive',
}) {
  const harga = Number(item.produk?.harga) || 0;
  const qty = Number(item.qty) || 0;
  const subtotal = harga * qty;
  const productName = item.produk?.nama_produk || 'Produk tidak ditemukan';
  const imageSrc = item.produk?.foto
    ? getStorageUrl(item.produk.foto)
    : '/no-image.png';
  const isResponsive = variant === 'responsive';

  const quantityControl = (
    <div className="inline-flex items-center rounded-2xl border border-gray-300 bg-white p-1 shadow-sm">
      <button
        type="button"
        onClick={() => updateQty(item.id_item, Math.max(1, qty - 1))}
        className="flex h-9 w-9 items-center justify-center rounded-xl text-lg leading-none text-gray-500 transition hover:bg-gray-100 hover:text-primary"
        aria-label={`Kurangi jumlah ${productName}`}>
        -
      </button>
      <span className="min-w-8 px-2 text-center text-sm font-semibold text-gray-800">
        {qty}
      </span>
      <button
        type="button"
        onClick={() => updateQty(item.id_item, qty + 1)}
        className="flex h-9 w-9 items-center justify-center rounded-xl text-lg leading-none text-gray-500 transition hover:bg-gray-100 hover:text-primary"
        aria-label={`Tambah jumlah ${productName}`}>
        +
      </button>
    </div>
  );

  if (isResponsive) {
    return (
      <div className="rounded-[28px] border border-gray-200 bg-white p-4 shadow-sm transition hover:shadow-md md:p-5">
        <div className="flex flex-col gap-4 md:flex-row md:items-center md:justify-between">
          <div className="flex items-start gap-4 md:min-w-0 md:flex-1">
            <div className="flex h-20 w-20 shrink-0 items-center justify-center overflow-hidden rounded-2xl bg-gray-50 md:h-24 md:w-24">
              <img
                src={imageSrc}
                className="h-full w-full object-contain"
                alt={productName}
              />
            </div>

            <div className="min-w-0 flex-1">
              <div className="flex items-start justify-between gap-3">
                <div className="min-w-0">
                  <p className="font-semibold text-gray-900 md:text-lg">
                    {productName}
                  </p>
                  <p className="mt-1 text-sm text-gray-500">Harga satuan</p>
                  <p className="text-sm font-medium text-gray-700 md:text-base">
                    Rp {harga.toLocaleString('id-ID')}
                  </p>
                </div>

                <button
                  type="button"
                  onClick={() => removeItem(item.id_item)}
                  className="shrink-0 rounded-full border border-gray-200 px-3 py-1 text-xs font-semibold text-gray-500 transition hover:border-red-200 hover:bg-red-50 hover:text-red-500">
                  Hapus
                </button>
              </div>
            </div>
          </div>

          <div className="flex flex-col gap-3 border-t border-gray-100 pt-4 md:min-w-62.5 md:border-t-0 md:border-l md:pl-5 md:pt-0">
            <div className="flex items-center justify-between gap-4">
              <span className="text-xs uppercase tracking-[0.14em] text-gray-400">
                Jumlah
              </span>
              {quantityControl}
            </div>

            <div className="flex items-center justify-between gap-4">
              <span className="text-xs uppercase tracking-[0.14em] text-gray-400">
                Subtotal
              </span>
              <p className="text-right text-lg font-bold text-primary">
                Rp {subtotal.toLocaleString('id-ID')}
              </p>
            </div>
          </div>
        </div>
      </div>
    );
  }

  return null;
}
