export default function WishlistPage() {
    return (
            <div className="min-h-screen flex flex-col my-15 mx-20">
    
                    <div className="flex items-center gap-5">
                        <div className="bg-primary w-5 h-10 rounded-sm"></div>
                        <p className="text-primary font-semibold">
                            Produk Favorit
                        </p>
                    </div>

                    <div className="mt-10">
                        <p className="text-gray-500 text-center">
                            Belum ada produk favorit. Jelajahi produk kami dan tambahkan ke favoritmu!
                        </p>
                    </div>
            </div>
        );
}