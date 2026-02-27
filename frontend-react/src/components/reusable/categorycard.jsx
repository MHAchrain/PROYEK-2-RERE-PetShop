export default function CategoryCard({nama, Icon}) {
    return (
        <div className="w-full h-40 border rounded-md 
        flex flex-col items-center justify-center
        border-gray-300 hover:bg-primary hover:text-white 
        transition cursor-pointer duration-500">
            <Icon size={32} />
            <h3 className="text-lg font-semibold mt-2">
                {nama}
            </h3>
        </div>
    )
}