import { ListBarang } from "../../Data";
import ProductCard from "./productcard";

export default function ProductSection() {

    const displayedProducts = ListBarang.slice(0, 4);

    return(
        <div className="flex justify-center px-4">
            <div className="max-w-6xl w-full space-y-4">
                <div className="flex items-center gap-5">
                    <div className="bg-primary w-5 h-10 rounded-sm"></div>
                    <p className="text-primary font-semibold">Hari ini</p>
                </div>

                <h2 className="text-2xl font-bold">Rekomendasi</h2>

                <div className="grid grid-cols-2 md:grid-cols-3 md:max-w- lg:grid-cols-4 gap-6">
                    {displayedProducts.map((item)=>(
                        <ProductCard
                        key={item.id}
                        nama={item.nama}
                        harga={item.harga}
                        image={item.image}
                        diskon={item.diskon}
                        rating={item.rating}
                        />
                    ))}
                </div>

                <div className="flex justify-center">
                    <button className="px-12 py-3 rounded-sm bg-primary text-white hover:bg-primary-700 transition">
                        Lihat Semua
                    </button>
                </div>
            </div>
        </div>
    );
}