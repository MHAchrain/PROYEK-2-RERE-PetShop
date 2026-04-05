import { getCategories } from "../../services/categoryservice";
import { categoryIconMap } from "../../utils/categoryIconMap";
import { useEffect, useState } from "react";
import CategoryCard from "./categorycard";
import * as icons from "lucide-react";
import Skeleton from "../ui/skeleton";

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

    return(
        <div className="flex justify-center">
            <div className="grid grid-cols-2 px-4 md:grid-cols-3  lg:grid-cols-4 lg:px-0
            gap-10 max-w-4xl w-full">
                {isLoading ? (
                    [...Array(4)].map((_, i) => (
                        <Skeleton 
                            key={i} 
                            className="w-full h-40 rounded-md" 
                        />
                    ))
                ) : (
                    categories.map((item) => {
                        const Icon = categoryIconMap[item.nama_kategori] || icons.Box;

                        return (
                            <CategoryCard
                                key={item.id_kategori}
                                id={item.id_kategori}
                                nama={item.nama_kategori}
                                Icon={Icon}
                            />
                        );
                    })
                )}
            </div>
        </div>
    )
}