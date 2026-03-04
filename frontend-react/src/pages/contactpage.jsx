import { Phone, Mail } from "lucide-react"

export default function ContactPage(){
    return(
        <div className="min-h-screen p-10">

            <div className="flex items-center gap-5 mb-16">
                <div className="bg-primary w-5 h-10 rounded-sm"></div>
                <p className="text-primary font-semibold">Kontak</p>
            </div>

            <div className="max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-3 gap-10">
                <div className="bg-gray-50 shadow-sm rounded-md p-8 space-y-10 h-fit">

                    <div>
                        <div className="flex items-center gap-4 mb-4">
                            <div className="w-10 h-10 bg-primary rounded-full flex items-center justify-center text-white">
                                <Phone size={18} />
                            </div>
                            <h3 className="font-semibold text-lg">
                                Hubungi Kami
                            </h3>
                        </div>

                        <p className="text-gray-600 text-sm mb-3">
                            Kami siap melayani Anda 24 jam sehari, 7 hari seminggu.
                        </p>

                        <p className="text-sm">
                            Nomor Telepon: <span className="underline">0813-1941-0250</span>
                        </p>
                    </div>

                    <hr />

                    <div>
                        <div className="flex items-center gap-4 mb-4">
                            <div className="w-10 h-10 bg-primary rounded-full flex items-center justify-center text-white">
                                <Mail size={18} />
                            </div>
                            <h3 className="font-semibold text-lg">
                                Menulis Kepada Kami
                            </h3>
                        </div>

                        <p className="text-gray-600 text-sm mb-3">
                            Isilah formulir kami dan kami akan menghubungi Anda dalam waktu 24 jam.
                        </p>

                        <div className="space-y-2">
                            <p className="text-sm">
                                Emails: customer@exclusive.com
                            </p>
                            <p className="text-sm">
                                Emails: support@exclusive.com
                            </p>
                        </div>
                    </div>
                </div>

                <div className="bg-gray-50 shadow-sm rounded-md p-8 lg:col-span-2">

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
                </div>
            </div>
        </div>
    );
}