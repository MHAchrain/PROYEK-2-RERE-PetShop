import React from 'react';
import { getStorageUrl } from '../../utils/appconfig';
import noImage from '../../assets/no-image.png';

export default function CartCard({
  item,
  removeItem,
  updateQty,
  variant = 'responsive',
}) {
  const product = item?.produk || item?.product || item || {};

  const harga = Number(product?.harga ?? item?.harga ?? 0);
  const qty = Number(item?.qty ?? item?.jumlah ?? 1);
  const subtotal = Number(item?.subtotal ?? harga * qty);
  const productName =
    product?.nama_produk || product?.nama || item?.nama_produk || 'Produk';

  // Cek semua kemungkinan letak data Base64 / Foto di dalam item FE
  const rawBase64 =
    product?.foto_base64 ||
    item?.foto_base64 ||
    product?.image_base64 ||
    item?.image_base64;

  const rawPath =
    product?.foto ||
    item?.foto ||
    product?.image ||
    item?.image ||
    product?.gambar ||
    item?.gambar;

  // Prioritaskan Base64, jika tidak ada fallback ke Storage URL atau No Image
  let imageSrc = noImage;
  if (rawBase64 && String(rawBase64).startsWith('data:')) {
    imageSrc = rawBase64;
  } else if (rawPath) {
    const cleanPath = Array.isArray(rawPath) ? rawPath[0] : rawPath;
    imageSrc = String(cleanPath).startsWith('data:')
      ? cleanPath
      : getStorageUrl(cleanPath);
  }

  const isResponsive = variant === 'responsive';

  const quantityControl = (
    <div className="inline-flex items-center rounded-2xl border border-gray-300 bg-white p-1 shadow-sm">
      <button
        type="button"
        onClick={() => updateQty(item.id_item || item.id, Math.max(1, qty - 1))}
        className="flex h-9 w-9 items-center justify-center rounded-xl text-lg leading-none text-gray-500 transition hover:bg-gray-100 hover:text-primary"
        aria-label={`Kurangi jumlah ${productName}`}>
        -
      </button>
      <span className="min-w-8 px-2 text-center text-sm font-semibold text-gray-800">
        {qty}
      </span>
      <button
        type="button"
        onClick={() => updateQty(item.id_item || item.id, qty + 1)}
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
            <div className="flex h-20 w-20 shrink-0 items-center justify-center overflow-hidden rounded-2xl bg-gray-50 border border-gray-100 md:h-24 md:w-24">
              <img
                src={imageSrc}
                className="h-full w-full object-cover"
                alt={productName}
                loading="lazy"
                onError={(e) => {
                  e.currentTarget.onerror = null;
                  e.currentTarget.src = noImage;
                }}
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
                  onClick={() => removeItem(item.id_item || item.id)}
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
