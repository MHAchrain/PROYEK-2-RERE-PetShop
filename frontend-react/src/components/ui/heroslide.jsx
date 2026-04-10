export default function HeroSlide({ text, image }) {
    return (
        <div
        className="min-w-full h-full bg-cover bg-center relative flex items-center"
        style={{ backgroundImage: `url(${image})` }}
        >
        {/* Overlay biar text kebaca */}
        <div className="absolute inset-0 bg-black/40"></div>

        {/* Content */}
        <div className="relative z-10 max-w-4xl px-10 md:px-16 lg:px-24">
            <h1 className="text-white text-lg md:text-2xl lg:text-3xl font-semibold leading-snug">
            {text}
            </h1>
        </div>
        </div>
    );
}