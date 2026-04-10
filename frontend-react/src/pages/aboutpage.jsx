import { Link } from "react-router-dom"
import { Statistic, TeamList } from "../Data"
import examp from "../assets/dummy.png"
import { Instagram, Linkedin, Github, Icon } from "lucide-react"
import { BenefitList } from "../Data"

export default function AboutPage(){
    return(
        <div className="min-h-screen flex flex-col my-15 mx-20">

            <div className="flex items-center gap-5">
                <div className="bg-primary w-5 h-10 rounded-sm"></div>
                <p className="text-primary font-semibold">Tentang Kami</p>
            </div>

            <div className="flex flex-col lg:flex-row items-center gap-16 px-10 py-16 mx-auto">
                <div className="flex-1 space-y-6">
                    <h1 className="text-5xl font-bold">Cerita Kami</h1>
                    <p className="text-gray-600 leading-relaxed">
                        Berawal dari kecintaan kami terhadap hewan peliharaan, kami menyadari bahwa menemukan produk dan layanan terbaik untuk mereka tidak selalu mudah. Banyak pemilik hewan harus mencari ke berbagai tempat hanya untuk memastikan kebutuhan si kesayangan terpenuhi.
                    </p>
                    <p className="text-gray-600 leading-relaxed">
                        Dari situlah platform ini lahir — untuk menghadirkan kemudahan dalam satu genggaman. Kami menghubungkan para pecinta hewan dengan petshop terpercaya di sekitar mereka, menyediakan akses ke makanan berkualitas, vitamin, perlengkapan, hingga layanan grooming profesional.
                    </p>
                    <p className="text-gray-600">
                        Karena bagi kami, hewan peliharaan bukan sekadar teman. Mereka adalah keluarga yang pantas mendapatkan perhatian dan kasih sayang terbaik setiap hari.
                    </p>
                </div>

                <div className="flex-1">
                    <img src={examp} alt="cat photo" className="rounded-md shadow-lg w-full object-cover" />
                </div>
            </div>

            <div className="py-16">
                <div className="mx-auto grid grid-cols-1 md:grid-cols-4 gap-8 px-10">
                    {Statistic.map((item) =>{
                        const Icon = item.icon;
                        return(
                        <div key={item.id} className=" group p-8 rounded-md 
                        text-center border border-gray-300  transition-all duration-150 
                        hover:bg-primary hover:text-white hover:shadow-lg">

                            <div className="w-16 h-16 mx-auto rounded-full 
                                bg-gray-300 flex items-center justify-center
                                transition-all duration-300 mb-4
                                group-hover:bg-white/30">

                                <div className="w-12 h-12 bg-primary rounded-full 
                                    flex items-center justify-center text-white
                                    transition-all duration-300
                                    group-hover:bg-white group-hover:text-primary">

                                <Icon size={22} />
                                </div>
                            </div>
                            
                            <h2 className="text-3xl font-bold">{item.value}</h2>
                            
                            <p className="text-sm mt-2">{item.label}</p>

                        </div>
                        );
                    })}
                </div>
            </div>

            <div className="py-20">
                <div className="mx-auto grid grid-cols-1 md:grid-cols-3 gap-10 px-10">
                    {TeamList.map((member) => (
                        <div key={member.id} className="text-left group">

                            <div className="overflow-hidden rounded-md h-100">
                                <img src={member.image} alt={member.name} 
                                className="w-full h-full object-cover transition duration-500 group-hover:scale-105"/>
                            </div>

                            <h3 className="text-xl font-semibold mt-4">
                                {member.name}
                            </h3>

                            <p className="text-gray-500 text-sm">
                                {member.role}
                            </p>

                            <div className="flex gap-4 mt-4 opacity-70 group-hover:opacity-100 transition">
                                <a href={member.instagram} target="_blank">
                                    <Instagram size={18} className="hover:text-primary transition"/>
                                </a>
                                <a href={member.linkedin} target="_blank">
                                    <Linkedin size={18} className="hover:text-primary transition"/>
                                </a>
                                <a href={member.github} target="_blank">
                                    <Github size={18} className="hover:text-primary transition"/>
                                </a>
                            </div>
                        </div>
                    ))}
                </div>
            </div>

            <div className="py-20">
                <div className=" mx-auto grid grid-cols-1 md:grid-cols-3 gap-10 px-10 text-center">

                    {BenefitList.map((item) => {
                        const Icon = item.icon;
                        return(
                            <div key={item.id} className="space-y-4 text-center">

                                <div className="w-16 h-16 mx-auto rounded-full bg-gray-300 flex items-center justify-center">
                                    <div className="w-12 h-12 bg-red-700 rounded-full flex items-center justify-center text-white">
                                        <Icon size={24} />
                                    </div>
                                </div>

                                <h4 className="font-bold text-lg">
                                    {item.title}
                                </h4>

                                <p className="text-gray-500 text-sm">
                                    {item.desc}
                                </p>
                            </div>
                        );
                    })}

                </div>
            </div>
        </div>
    )
}