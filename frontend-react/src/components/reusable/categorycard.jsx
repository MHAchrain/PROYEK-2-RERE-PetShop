import { Link } from "react-router-dom";

export default function CategoryCard({ id, nama, Icon}) {
    return (
        <Link to={`/category/${id}`}>
            <div className="w-full h-40 border rounded-md 
            flex flex-col items-center justify-center
            border-gray-300 hover:bg-primary hover:text-white 
            transition cursor-pointer duration-150">

                <Icon size={32} />

                <h3 className="text-lg font-semibold mt-2">
                    {nama}
                </h3>

            </div>
        </Link>
    )
}