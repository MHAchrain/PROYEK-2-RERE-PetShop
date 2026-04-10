export default function ProductGallery({ images, selectedImage, onSelect }) {
    return (
        <div className="flex gap-4">
        
        {/* Thumbnail */}
        <div className="flex flex-col gap-2">
            {images.map((img, i) => (
            <img
                key={i}
                src={img}
                onClick={() => onSelect(img)}
                className={`w-16 h-16 object-cover cursor-pointer border ${
                selectedImage === img ? "border-primary" : ""
                }`}
            />
            ))}
        </div>

        {/* Main Image */}
        <div className="flex-1">
            <img src={selectedImage} className="w-full rounded-lg" />
        </div>

        </div>
    );
}