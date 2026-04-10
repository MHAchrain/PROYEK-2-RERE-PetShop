import { getCategories } from "../../services/categoryservice";
import { categoryIconMap } from "../../utils/categoryIconMap";
import { useEffect, useState } from "react";
import CategoryCard from "../ui/categorycard";
import * as icons from "lucide-react";
import Skeleton from "../ui/skeleton";
import { serviceList } from "../../utils/serviceslist";

export default function CategorySection() {
    const [categories, setCategories] = useState([]);
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        const fetchCategories = async () => {
            try{
                const data = await getCategories();
                setCategories(data);
            } catch(err){
                console.error(err);
            } finally{
                setIsLoading(false);
            }
        };
        fetchCategories();
    }, []);

    const finalItems = [
        ...categories.map((item) => ({
            id: item.id_kategori,
            nama: item.nama_kategori,
            Icon: categoryIconMap[item.nama_kategori] || icons.Box,
            isService: false
        })),
        ...serviceList.map((item) => ({
            ...item,
            isService: true
        }))
    ];

    return(
        <div className="flex justify-center">
            <div className="grid grid-cols-2 px-4 md:grid-cols-3  lg:grid-cols-5 lg:px-0
            gap-10 max-w-5xl w-full">
                {isLoading ? (
                    [...Array(5)].map((_, i) => (
                        <Skeleton key={i} className="w-full h-40 rounded-md" />
                    ))
                ) : (
                    finalItems.map((item) => (
                        <CategoryCard
                            key={item.id}
                            id={item.id}
                            nama={item.nama}
                            Icon={item.Icon}
                            path={item.path}
                            isService={item.isService}
                        />
                    ))
                )}
            </div>
        </div>
    )
}