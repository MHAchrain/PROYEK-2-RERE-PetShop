import { useState } from 'react';
import { ChevronDown, HelpCircle } from 'lucide-react';

export default function FaqSection() {
    const [openIndex, setOpenIndex] = useState(null);

    const faqs = [
        { q: "Bagaimana cara melacak pesanan saya?", a: "Anda dapat melihat status pesanan di halaman 'Pesanan Saya' secara real-time." },
        { q: "Apakah bisa melakukan pembatalan?", a: "Pembatalan bisa dilakukan selama pesanan belum diproses oleh admin kami." },
        { q: "Metode pembayaran apa saja yang tersedia?", a: "Kami menerima Transfer Bank, E-Wallet (Gopay, OVO), dan pembayaran di Alfamart/Indomaret." },
    ];

    return (
        <div className="space-y-6 animate-in fade-in duration-500">
        <div>
            <h3 className="text-xl font-bold text-gray-800">FAQ</h3>
            <p className="text-sm text-gray-500">Pertanyaan yang sering ditanyakan seputar layanan kami</p>
        </div>

        <div className="space-y-3">
            {faqs.map((faq, index) => (
            <div key={index} className="border border-gray-100 rounded-xl overflow-hidden">
                <button 
                onClick={() => setOpenIndex(openIndex === index ? null : index)}
                className="w-full flex justify-between items-center p-4 text-left hover:bg-gray-50 transition"
                >
                <span className="text-sm font-semibold text-gray-700">{faq.q}</span>
                <ChevronDown className={`transition-transform duration-300 ${openIndex === index ? 'rotate-180' : ''}`} size={18} />
                </button>
                {openIndex === index && (
                <div className="p-4 bg-gray-50 text-sm text-gray-600 border-t border-gray-100 animate-in slide-in-from-top-2 duration-300">
                    {faq.a}
                </div>
                )}
            </div>
            ))}
        </div>
        </div>
    );
};