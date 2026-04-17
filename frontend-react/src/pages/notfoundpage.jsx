import { Link } from "react-router-dom";

export default function NotFoundPage() {
    return (
        <div className="min-h-screen flex flex-col">

            <div className="flex flex-1 flex-col items-center text-center justify-center">

                <h1 className="font-bold text-8xl mb-6">
                    404 Not Found
                </h1>

                <p className="text-gray-500 mb-8">
                    Your visited page not found. You may go home page.
                </p>

                <Link to="/"
                    className="px-12 py-3 rounded-sm 
                    bg-primary text-white hover:bg-primary-600 transition">
                        Kembali ke Beranda
                </Link>
            </div>
        </div>
    );
}
