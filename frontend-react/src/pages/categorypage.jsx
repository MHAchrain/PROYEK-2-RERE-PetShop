import { useParams } from "react-router-dom";
import { useEffect, useState } from "react";
import ProductSectionByCategory from "../components/section/productbycategorysection";
import NotFoundPage from "./notfoundpage";
import { getCategoriesById } from "../services/categoryservice";
import Skeleton from "../components/ui/skeleton";

export default function CategoryPage() {

    const { id } = useParams();

    const [category, setCategory] = useState(null);
    const [isLoading, setIsLoading] = useState(true);
    const [notFound, setNotFound] = useState(false);

    useEffect(() => {
        const fetchCategory = async () => {
        try {
            setIsLoading(true);

            const data = await getCategoriesById(id);
            setCategory(data);

        } catch (err) {
            console.error(err);
            setNotFound(true);
        } finally {
            setIsLoading(false);
        }
        };

        fetchCategory();
    }, [id]);

    if (notFound) {
        return <NotFoundPage />;
    }

    return (
        <div className="min-h-screen flex flex-col my-15 mx-20">
            <div className="w-full px-4 md:px-10 space-y-4">

                <div className="flex items-center gap-5">
                    <div className="bg-primary w-5 h-10 rounded-sm"></div>
                    {isLoading ? (
                        <Skeleton className="w-40 h-6" />
                        ) : (
                        <p className="text-primary font-semibold capitalize">
                            Kategori
                        </p>
                    )}
                </div>

                {isLoading ? (
                    <Skeleton className="w-40 h-6" />
                    ) : (
                    <h2 className="text-2xl font-bold capitalize">
                        {category?.nama_kategori}
                    </h2>
                )}

                <ProductSectionByCategory categoryId={id} />

            </div>
        </div>
    );
}
