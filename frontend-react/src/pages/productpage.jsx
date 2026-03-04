import { ListBarang } from "../Data"
import { useParams } from "react-router-dom";

export default function ProductPage(){
    const { id } = useParams();

    const product = ListBarang.find(
        (item) => item.id === Number(id)
    );

    if (!product) return <div>Product not found</div>;

    return(
        <div className="p-10">
            
            <div className="flex items-center gap-5 mb-16">
                <div className="bg-primary w-5 h-10 rounded-sm"></div>
                <p className="text-primary font-semibold">{product.nama}</p>
            </div>

            <div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
                <div></div>
            </div>
        </div>
    )
}