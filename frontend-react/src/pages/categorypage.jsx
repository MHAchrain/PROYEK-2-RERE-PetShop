import { useParams } from "react-router-dom";
import { useEffect, useState } from "react";
import { getCategoriesById } from "../services/categoryservice";
import { getProductsByCategory } from "../services/productservice";
import ProductSectionByCategory from "../components/section/productbycategorysection";
import NotFoundPage from "./notfoundpage";
import Skeleton from "../components/ui/skeleton";
import LoadMoreButton from "../components/ui/loadmorebutton";

export default function CategoryPage() {

    const { id } = useParams();

    const [products, setProducts] = useState([]);
    const [category, setCategory] = useState(null);
    const [isLoading, setIsLoading] = useState(true);
    const [notFound, setNotFound] = useState(false);
    const [visibleCount, setVisibleCount] = useState(8);
    const [isBtnLoading, setIsBtnLoading] = useState(false);

    useEffect(() => {
        const fetchData = async () => {
            try {
                setIsLoading(true);
                // Ambil Kategori dan Produk sekaligus
                const [categoryData, productsData] = await Promise.all([
                    getCategoriesById(id),
                    getProductsByCategory(id)
                ]);

                setCategory(categoryData);
                setProducts(productsData);
            } catch (err) {
                console.error(err);
                setNotFound(true);
            } finally {
                setIsLoading(false);
            }
        };
        fetchData();
        setVisibleCount(8);
    }, [id]);

    const toggleVisible = () => {
        if (visibleCount < products.length) {
            setIsBtnLoading(true);
            setTimeout(() => {
            setVisibleCount(products.length);
            setIsBtnLoading(false);
            }, 800);
        } else {
            setVisibleCount(8);
            window.scrollTo({ top: 500, behavior: 'smooth' });
        }
    };

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
                        <p className="text-xl font-bold capitalize text-primary sm:text-2xl">
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

                <ProductSectionByCategory 
                    products={products.slice(0, visibleCount)}
                    isLoading={isLoading}
                />

                <LoadMoreButton
                    onClick={toggleVisible}
                    isLoading={isBtnLoading}
                    isShowingAll={visibleCount >= products.length}
                    totalData={products.length}
                />
            </div>
        </div>
    );
}
