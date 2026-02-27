import { useState, useEffect } from "react";
import { HeroSlides as HeroSlidesData } from "../../Data";
import HeroSlide from "./heroslide";

export default function HeroSlider() {

    const [slides, setSlides] = useState([]);
    const [current, setCurrent] = useState(0);

    // Shuffle + ambil 5 data saat pertama load
    useEffect(() => {
        const shuffled = [...HeroSlidesData].sort(() => 0.5 - Math.random());
        setSlides(shuffled.slice(0, 5));
    }, []);

    const nextSlide = () => {
        setCurrent((prev) =>
        prev === slides.length - 1 ? 0 : prev + 1
        );
    };

    const prevSlide = () => {
        setCurrent((prev) =>
        prev === 0 ? slides.length - 1 : prev - 1
        );
    };

    // Auto-play
    useEffect(() => {
        if (slides.length === 0) return;

        const timer = setInterval(nextSlide, 3000);
        return () => clearInterval(timer);
    }, [current, slides]);

    return (
        <div className="relative w-full max-w-6xl h-120 md:h-140 mx-auto overflow-hidden">

        {/* Slides Container */}
        <div
            className="flex transition-transform duration-700 ease-in-out h-full"
            style={{ transform: `translateX(-${current * 100}%)` }}
        >
            {slides.map((slide) => (
            <HeroSlide
                key={slide.id}
                text={slide.text}
                image={slide.image} 
            />
            ))}
        </div>

        {/* Prev Button */}
        <button
            onClick={prevSlide}
            className="absolute top-1/2 left-4 -translate-y-1/2 text-white text-2xl"
        >
            ❮
        </button>

        {/* Next Button */}
        <button
            onClick={nextSlide}
            className="absolute top-1/2 right-4 -translate-y-1/2 text-white text-2xl"
        >
            ❯
        </button>

        {/* Indicator Dots */}
        <div className="absolute bottom-4 left-0 right-0 flex justify-center gap-2">
            {slides.map((_, index) => (
            <button
                key={index}
                onClick={() => setCurrent(index)}
                className={`w-3 h-3 rounded-full ${
                index === current
                    ? "bg-primary border-2 border-white"
                    : "bg-white/50"
                }`}
            />
            ))}
        </div>
        </div>
    );
}