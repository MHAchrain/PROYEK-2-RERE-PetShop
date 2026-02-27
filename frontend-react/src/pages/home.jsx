import { useState } from "react"
import HeroSlider from "../components/section/heroslider";
import CategorySection from "../components/reusable/categorysection";
import ProductSection from "../components/reusable/productsection";


export default function Home() {
    return(
        <div className="space-y-10">
            <HeroSlider />
            <CategorySection />
            <ProductSection />
        </div>
    );
}