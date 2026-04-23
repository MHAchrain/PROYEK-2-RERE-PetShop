import { useEffect, useState } from "react";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { HeroSlides as HeroSlidesData } from "../../Data";
import HeroSlide from "../ui/heroslide";
import Skeleton from "../ui/skeleton";
import SectionTitle from "../ui/sectiontitle";

export default function HeroSlider() {
    const [slides, setSlides] = useState([]);
    const [current, setCurrent] = useState(0);
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        setIsLoading(true);

        const shuffled = [...HeroSlidesData].sort(() => 0.5 - Math.random());
        const timer = setTimeout(() => {
        setSlides(shuffled.slice(0, 5));
        setCurrent(0);
        setIsLoading(false);
        }, 2000);

        return () => clearTimeout(timer);
    }, []);

    const nextSlide = () => {
        if (slides.length <= 1) return;
        setCurrent((prev) => (prev === slides.length - 1 ? 0 : prev + 1));
    };

    const prevSlide = () => {
        if (slides.length <= 1) return;
        setCurrent((prev) => (prev === 0 ? slides.length - 1 : prev - 1));
    };

    useEffect(() => {
        if (slides.length <= 1) return undefined;

        const timer = setInterval(() => {
        setCurrent((prev) => (prev === slides.length - 1 ? 0 : prev + 1));
        }, 3500);

        return () => clearInterval(timer);
    }, [slides]);

    return (
        <section className="px-4 py-4 md:px-8 lg:px-16 xl:px-20">
        <div className="mx-auto w-full max-w-7xl space-y-4 sm:space-y-6">

            <div className="relative overflow-hidden rounded-[28px] border border-primary/10 bg-white shadow-sm sm:rounded-[32px]">
            <div className="relative h-[24rem] sm:h-[28rem] lg:h-[32rem]">
                {isLoading ? (
                <Skeleton className="h-full w-full rounded-[28px] sm:rounded-[32px]" />
                ) : (
                <div
                    className="flex h-full transition-transform duration-700 ease-in-out"
                    style={{ transform: `translateX(-${current * 100}%)` }}
                >
                    {slides.map((slide) => (
                    <HeroSlide key={slide.id} text={slide.text} image={slide.image} />
                    ))}
                </div>
                )}
            </div>

            <div className="absolute inset-x-0 top-0 z-20 flex items-start justify-between gap-3 p-3 sm:p-5">
                <div className="max-w-[70%] rounded-full border border-white/70 bg-white/85 px-3 py-1.5 shadow-sm backdrop-blur sm:max-w-none sm:px-4 sm:py-2">
                <p className="truncate text-[11px] font-semibold uppercase tracking-[0.18em] text-primary/80 sm:text-xs">
                    Highlight minggu ini
                </p>
                </div>

                <div className="flex gap-2">
                <button
                    type="button"
                    onClick={prevSlide}
                    className="flex h-9 w-9 items-center justify-center rounded-full border border-white/70 bg-white/85 text-gray-700 shadow-sm backdrop-blur transition hover:bg-white sm:h-11 sm:w-11"
                    aria-label="Slide sebelumnya"
                >
                    <ChevronLeft size={16} className="sm:hidden" />
                    <ChevronLeft size={18} className="hidden sm:block" />
                </button>

                <button
                    type="button"
                    onClick={nextSlide}
                    className="flex h-9 w-9 items-center justify-center rounded-full border border-white/70 bg-white/85 text-gray-700 shadow-sm backdrop-blur transition hover:bg-white sm:h-11 sm:w-11"
                    aria-label="Slide berikutnya"
                >
                    <ChevronRight size={16} className="sm:hidden" />
                    <ChevronRight size={18} className="hidden sm:block" />
                </button>
                </div>
            </div>

            <div className="absolute inset-x-0 bottom-0 z-20 flex items-end justify-between gap-3 bg-[linear-gradient(180deg,rgba(17,24,39,0)_0%,rgba(17,24,39,0.82)_100%)] px-3 pb-3 pt-20 sm:px-5 sm:pb-5">
                <div className="hidden rounded-2xl border border-white/15 bg-white/10 px-4 py-3 text-white backdrop-blur md:block">
                <p className="text-xs uppercase tracking-[0.18em] text-white/70">Slide aktif</p>
                <p className="mt-1 text-sm font-semibold">
                    {slides.length === 0 ? "Memuat..." : `${current + 1} dari ${slides.length}`}
                </p>
                </div>

                <div className="ml-auto flex max-w-full gap-1.5 rounded-full border border-white/10 bg-black/10 px-2 py-2 backdrop-blur sm:gap-2 sm:px-3">
                {slides.map((_, index) => (
                    <button
                    key={index}
                    type="button"
                    onClick={() => setCurrent(index)}
                    aria-label={`Pindah ke slide ${index + 1}`}
                    className={`h-2 rounded-full transition-all sm:h-2.5 ${
                        index === current ? "w-6 bg-primary sm:w-8" : "w-2 bg-white/55 hover:bg-white/80 sm:w-2.5"
                    }`}
                    />
                ))}
                </div>
            </div>
            </div>
        </div>
        </section>
    );
}
