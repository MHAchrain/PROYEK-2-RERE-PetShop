import { Phone, Mail } from "lucide-react"
import { useEffect, useState } from "react";
import Skeleton from "../components/ui/skeleton";

export default function ContactPage(){
    const [isLoading, setIsLoading] = useState(true);

    useEffect(() => {
        const timer = setTimeout(() => {
            setIsLoading(false);
        }, 2000);
        return () => clearTimeout(timer);
    }, []);

    return(
        <div className="min-h-screen flex flex-col my-15 mx-20">

            <div className="flex items-center gap-5 mb-16">
                <div className="bg-primary w-5 h-10 rounded-sm"></div>
                {isLoading ? (
                    <Skeleton className="w-32 h-8 bg-gray-200" />
                ) : (
                    <p className="text-primary font-bold text-xl capitalize">Kontak</p>
                )}
            </div>

            <div className="max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-3 gap-10">
                <div className="bg-gray-50 shadow-sm rounded-md p-8 space-y-10 h-fit">

                    <div>
                        {isLoading ? (
                            <div className="flex items-center gap-4 mb-4">
                                <Skeleton className="w-10 h-10 rounded-full bg-gray-200" />
                                <Skeleton className="w-32 h-6 bg-gray-200" />
                            </div>
                        ) : (
                            <>
                                <div className="flex items-center gap-4 mb-4">
                                    <div className="w-10 h-10 bg-primary rounded-full flex items-center justify-center text-white">
                                        <Phone size={18} />
                                    </div>
                                    <h3 className="font-semibold text-lg">
                                        Hubungi Kami
                                    </h3>
                                </div>
                            </>
                        )}
                        {isLoading ? (
                            <div className="space-y-3">
                                <Skeleton className="w-full h-4 bg-gray-100" />
                                <Skeleton className="w-3/4 h-4 bg-gray-100" />
                            </div>
                        ) : (
                            <>
                                <p className="text-gray-600 text-sm mb-3">
                                    Kami siap melayani Anda 24 jam sehari, 7 hari seminggu.
                                </p>
                                <p className="text-sm font-medium">
                                    Nomor Telepon: <span className="underline text-primary">0813-1941-0250</span>
                                </p>
                            </>
                        )}
                    </div>

                    <hr />

                    <div>
                        {isLoading ? (
                            <div className="flex items-center gap-4 mb-4">
                                <Skeleton className="w-10 h-10 rounded-full bg-gray-200" />
                                <Skeleton className="w-40 h-6 bg-gray-200" />
                            </div>
                        ) : (
                            <>
                                <div className="flex items-center gap-4 mb-4">
                                    <div className="w-10 h-10 bg-primary rounded-full flex items-center justify-center text-white">
                                        <Mail size={18} />
                                    </div>
                                    <h3 className="font-semibold text-lg">
                                        Menulis Kepada Kami
                                    </h3>
                                </div>
                            </>
                        )}

                        {isLoading ? (
                            <div className="space-y-3">
                                <Skeleton className="w-full h-4 bg-gray-100" />
                                <Skeleton className="w-1/2 h-4 bg-gray-100" />
                            </div>
                        ) : (
                            <>
                                <p className="text-gray-600 text-sm mb-3">
                                    Isilah formulir kami dan kami akan menghubungi Anda dalam waktu 24 jam.
                                </p>
                                <div className="space-y-2">
                                    <p className="text-sm">Emails: <span className="font-medium">customer@exclusive.com</span></p>
                                    <p className="text-sm">Emails: <span className="font-medium">support@exclusive.com</span></p>
                                </div>
                            </>
                        )}
                    </div>
                </div>

                <div className="bg-gray-50 shadow-sm rounded-md p-8 lg:col-span-2">
                    {isLoading ? (
                        <div className="space-y-6">
                            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                                <Skeleton className="w-full h-12 bg-gray-100 rounded-md" />
                                <Skeleton className="w-full h-12 bg-gray-100 rounded-md" />
                                <Skeleton className="w-full h-12 bg-gray-100 rounded-md" />
                            </div>
                            <Skeleton className="w-full h-40 bg-gray-100 rounded-md" />
                            <div className="flex justify-end">
                                <Skeleton className="w-40 h-12 bg-gray-100 rounded-md" />
                            </div>
                        </div>
                    ) : (
                        <form action="" className="space-y-6">
                            <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                                <input type="text" placeholder="Masukan Nama"
                                className="bg-gray-100 px-4 py-3 rounded-md outline-none focus:ring-2 focus:ring-primary"/>
                                
                                <input type="email" placeholder="Masukan Email"
                                className="bg-gray-100 px-4 py-3 rounded-md outline-none focus:ring-2 focus:ring-primary"/>
                                
                                <input type="number" placeholder="Masukan Nomor Telepon"
                                className="bg-gray-100 px-4 py-3 rounded-md outline-none focus:ring-2 focus:ring-primary "/>
                            </div>

                            <textarea rows="6" placeholder="Masukan Pesan"
                            className="w-full bg-gray-100 px-4 py-3 rounded-md outline-none focus:ring-2 focus:ring-primary resize-none"></textarea>

                            <div className="flex justify-end">
                                <button type="submit" className="bg-primary text-white px-8 py-3 rounded-md hover:opacity-90 transition">
                                    Kirim Pesan
                                </button>
                            </div>

                        </form>
                    )}
                </div>
            </div>
        </div>
    );
}