import { useParams } from "react-router-dom";
import { useEffect, useState } from "react";
import ProductSection from "../components/reusable/productsection";
import NotFoundPage from "./notfoundpage";
import { getProductsByCategory, getCategoriesById } from "../services/categoryservice";
import Skeleton from "../components/ui/skeleton";

export default function CategoryPage() {

    const { id } = useParams();

    const [products, setProducts] = useState([]);
    const [category, setCategory] = useState(null);
    const [isLoading, setIsLoading] = useState(true);
    const [notFound, setNotFound] = useState(false);

    useEffect(() => {
        const fetchData = async () => {
            try {
                setIsLoading(true);

                const [productData, categoryData] = await Promise.all([
                    getProductsByCategory(id),
                    getCategoriesById(id)
                ]);

                setProducts(productData);
                setCategory(categoryData);

            } catch (err) {
                console.error(err);
                setNotFound(true);
            } finally {
                setIsLoading(false);
            }
        };

        fetchData();
    }, [id]);

    if (notFound) {
        return <NotFoundPage />;
    }

    return (
        <div className="flex justify-center m-10">
            <div className="w-full max-w-6xl space-y-4">

                <div className="flex items-center gap-5">
                    <div className="bg-primary w-5 h-10 rounded-sm"></div>
                    <p className="text-primary font-semibold">
                        Kategori
                    </p>
                </div>

                {isLoading ? (
                    <Skeleton className="w-40 h-6" />
                    ) : (
                    <h2 className="text-2xl font-bold capitalize">
                        {category?.nama_kategori}
                    </h2>
                )}

                <ProductSection
                    products={products}
                    isLoading={isLoading}
                />

            </div>
        </div>
    );
}
