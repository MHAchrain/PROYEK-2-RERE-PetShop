import { getStorageUrl } from "../../utils/appconfig";

export default function CartCard({ item, removeItem, updateQty }) {
    const harga = Number(item.produk?.harga) || 0;
    const qty = Number(item.qty) || 0;
    const subtotal = harga * qty;

    return (
        <tr className="bg-white shadow-sm rounded-lg group relative">
            <td className="py-4 px-6 flex items-center gap-4">
                {/* Remove Icon Overlay */}
                <div className="relative">
                    <button 
                    onClick={() => removeItem(item.id_item)}
                    className="absolute -top-2 -left-2 bg-primary-500 text-white w-5 h-5 rounded-full text-[10px] flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity">
                        ✕
                    </button>
                    <img
                        src={item.produk?.foto ? getStorageUrl(item.produk.foto) : "/no-image.png"}
                        className="w-16 h-16 object-contain"
                        alt={item.produk?.nama_produk || "product"}
                    />
                </div>
                <span className="font-medium">{item.produk?.nama_produk || "Produk tidak ditemukan"}</span>
            </td>
            
            <td className="py-4 px-6">
                Rp {harga.toLocaleString("id-ID")}
            </td>
            
            <td className="py-4 px-6">
                <div className="flex items-center border border-gray-400 rounded w-fit px-3 py-2 gap-4">
                    <span>{qty}</span>
                    <div className="flex flex-col text-[10px] text-gray-500">
                        <button onClick={() => updateQty(item.id_item, qty + 1)}>▲</button>
                        <button onClick={() => updateQty(item.id_item, Math.max(1, qty - 1))}>▼</button>
                    </div>
                </div>
            </td>
            
            <td className="py-4 px-6 text-right font-medium">
                Rp {subtotal.toLocaleString("id-ID")}
            </td>
        </tr>
    );
}
