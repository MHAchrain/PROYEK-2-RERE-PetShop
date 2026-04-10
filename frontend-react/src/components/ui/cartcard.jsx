export default function CartCard({ item }) {
    const harga = Number(item.produk?.harga) || 0;
    const qty = Number(item.qty) || 0;
    const subtotal = harga * qty;
    return (
        <div className="flex items-center gap-4 border p-4 rounded">
        <img
            src={
                item.produk?.foto
                ? `http://127.0.0.1:8000/storage/${item.produk.foto}`
                : "/no-image.png"
            }
            onError={(e) => {
                e.target.src = "/no-image.png";
            }}
            className="w-20 h-20 object-cover"
        />

        <div className="flex-1">
            <h3 className="font-semibold">{item.produk.nama_produk}</h3>
            <p>Qty: {item.qty}</p>
            <p>Rp {subtotal.toLocaleString("id-ID")}</p>
        </div>
        </div>
    );
}