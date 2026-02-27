import { ListKategori } from "../../Data";
import CategoryCard from "./categorycard";

export default function CategorySection() {
    return(
        <div className="flex justify-center">
            <div className="grid grid-cols-2 px-4 md:grid-cols-3  lg:grid-cols-4 lg:px-0
            gap-10 max-w-4xl w-full">
                {ListKategori.map((item)=>(
                    <CategoryCard
                        key={item.id}
                        nama={item.nama}
                        Icon={item.icon}
                    />
                ))}
            </div>
        </div>
    )
}