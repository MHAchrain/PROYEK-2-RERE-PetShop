import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { getProductById } from "../services/productservice";
import ProductSection from "../components/section/productsection";
import ProductGallerySection from "../components/section/productgallerysection";
import ProductDetailSection from "../components/section/productdetailsection";
import Skeleton from "../components/ui/skeleton";

const BASE_URL = "http://127.0.0.1:8000/storage/";

export default function ProductPage() {
  const { id } = useParams();
  const [product, setProduct] = useState(null);
  const [visibleCount, setVisibleCount] = useState(4);
  const [isLoading, setIsLoading] = useState(false);

  useEffect(() => {
    const fetch = async () => {
      try {
        setIsLoading(true);

        const data = await getProductById(id);

        const mapped = {
          id: data.id_produk,
          name: data.nama_produk,
          price: Number(data.harga),
          stock: data.stok,
          description: data.deskripsi,
          images: data.foto ? [BASE_URL + data.foto] : [],
        };

        setProduct(mapped);
      } catch (err) {
        console.error(err);
      } finally {
        setIsLoading(false);
      }
    };

    fetch();
  }, [id]);

  if (!product && !isLoading) {
    return <p className="text-center mt-20">Produk tidak ditemukan</p>;
  }

  return (
    <div className="min-h-screen flex flex-col my-15 mx-20">
      <div className="w-full space-y-10 mb-20">

        <div className="flex items-center gap-5 mb-16">
          <div className="bg-primary w-5 h-10 rounded-sm"></div>
          {isLoading ? (
            <Skeleton className="w-40 h-6" />
            ) : (
            <p className="text-primary font-semibold capitalize">
                {product?.name}
            </p>
          )}
        </div>

        <div className="grid md:grid-cols-2 gap-20">
          <ProductGallerySection product={product} isLoading={isLoading} />
          <ProductDetailSection product={product} isLoading={isLoading} />
        </div>

        <div className="w-full">
          <div className="flex items-center gap-5 mb-5">
            <div className="bg-black w-5 h-10 rounded-sm"></div>
            <p className="text-black font-semibold capitalize">Produk Serupa</p>
          </div>
          <ProductSection visibleCount={visibleCount} isLoading={isLoading} />
        </div>

      </div>
    </div>
  );
}
