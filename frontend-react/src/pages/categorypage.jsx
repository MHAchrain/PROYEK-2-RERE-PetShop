import { useParams } from "react-router-dom";
import ProductSection from "../components/reusable/productsection";
import NotFoundPage from "./notfoundpage";
import { ListKategori } from "../Data";

export default function CategoryPage() {

    const { namaKategori } = useParams();

    const kategoriValid = ListKategori.find(
        (item) => item.nama.toLowerCase() === namaKategori.toLowerCase()
    );

    if (!kategoriValid) {
        return <NotFoundPage />;
    }

    return (
        <div className="flex justify-center m-10">
            <div className="w-full max-w-6xl space-y-4">
                <div className="flex items-center gap-5">
                    <div className="bg-primary w-5 h-10 rounded-sm"></div>
                    <p className="text-primary font-semibold">
                        Category
                    </p>
                </div>

                <h2 className="text-2xl font-bold capitalize">{namaKategori}</h2>

                <ProductSection/>
            </div>
        </div>
    );
}
