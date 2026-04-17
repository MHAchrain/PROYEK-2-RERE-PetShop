import { getStorageUrl } from "../../utils/appconfig";

export default function OrderCard({ order }) {
    const detailPertama = order.details?.[0] || {}; 
    const produk = detailPertama.produk || {};

    return (
        <div className="border border-gray-200 rounded-2xl p-6 mb-6 bg-white shadow-sm">
            <div className="flex flex-col md:flex-row justify-between items-start md:items-center gap-4 mb-4">
                <div className="flex gap-8">
                    <div>
                        <p className="text-gray-400 text-[10px] uppercase font-bold">Order date</p>
                        {/* Pakai field tanggal_pesanan */}
                        <p className="font-bold text-sm text-gray-800">
                            {produk.nama_produk || "Produk tidak tersedia"}
                        </p>
                    </div>
                    <div>
                        <p className="text-gray-400 text-[10px] uppercase font-bold">Total Amount</p>
                        {/* Pakai field total */}
                        <p className="font-bold text-sm text-gray-800">Rp{Number(order.total).toLocaleString('id-ID')}</p>
                    </div>
                    <div className="hidden sm:block">
                        <p className="text-gray-400 text-[10px] uppercase font-bold">Ship To</p>
                        {/* Pakai field alamat_kirim */}
                        <p className="font-bold text-sm text-gray-600 truncate max-w-37.5">{order.alamat_kirim || 'Alamat tidak diatur'}</p>
                    </div>
                </div>
                <div>
                    <p className="text-gray-800 font-bold text-sm">
                        Order: <span className="text-black font-extrabold ml-1">#{order.id_pesanan}</span>
                    </p>
                </div>
            </div>

        <hr className="border-gray-100 mb-6" />

        <div className="flex flex-col lg:flex-row gap-6">
            <div className="w-28 h-28 shrink-0 bg-gray-50 rounded-xl overflow-hidden">
                <img
                    src={getStorageUrl(produk.foto)}
                    alt={produk.nama_produk}
                    className="w-full h-full object-cover"
                />
            </div>

            <div className="flex-1">
                {/* Status mapping dari status_pesanan database */}
                <h3 className="text-gray-900 font-extrabold text-lg leading-snug mb-1 capitalize">
                    {order.status_pesanan === 'selesai' ? 'Pesanan Selesai' : `Status: ${order.status_pesanan}`}
                </h3>
                <p className="font-bold text-gray-700 text-sm mb-1">
                    {produk.nama_produk} {order.detail?.length > 1 && `(+${order.detail.length - 1} produk lainnya)`}
                </p>
                <p className="text-gray-400 text-xs mb-5">
                    Jumlah: {detailPertama.qty} barang
                </p>

                <div className="flex items-center gap-4">
                    <button className="text-primary font-bold text-sm hover:underline">↺ Buy it again</button>
                    <div className="w-px h-4 bg-gray-200"></div>
                    <button className="text-primary font-bold text-sm hover:underline">👁 View product</button>
                </div>
            </div>

            <div className="flex flex-col gap-3 justify-end min-w-35">
                <button className="w-full py-2.5 px-4 border border-gray-300 rounded-lg font-bold text-sm">View Invoice</button>
                <button className="w-full py-2.5 px-4 bg-primary text-white rounded-lg font-bold text-sm">View Order</button>
            </div>

            {order.status_pesanan === 'selesai' && (
                <button className="bg-orange-500 text-white px-4 py-2 rounded-lg">
                    Beri Ulasan
                </button>
            )}
        </div>
        </div>
    );
}
