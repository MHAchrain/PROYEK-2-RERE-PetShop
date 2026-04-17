import OrderCard from "../ui/ordercard";

export default function AllOrdersSection() {
    return (
    <div className="animate-in fade-in slide-in-from-bottom-2 duration-500">
        {/* Contoh Data Map - Nanti ganti pake data dari Backend */}
        <OrderCard 
            status="Selesai" 
            date="12 April 2026" 
        totalPrice={250000} 
        items={[{ name: "Layanan Grooming Kucing Premium", image: "https://picsum.photos/200" }]} 
        />
    </div>
    );
}