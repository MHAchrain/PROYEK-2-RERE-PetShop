import { useEffect, useState } from 'react';
import { useParams } from 'react-router-dom';

export default function ProductPage() {
  const { id } = useParams();

  const [product, setProduct] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    fetch(`http://127.0.0.1:8000/api/produk/${id}`, {
      headers: {
        Accept: 'application/json',
      },
    })
      .then((res) => res.json())
      .then((data) => {
        setProduct(data.data ?? data);
        setLoading(false);
      })
      .catch((err) => {
        console.error('Gagal ambil detail produk:', err);
        setLoading(false);
      });
  }, [id]);

  if (loading) return <div className="p-10">Loading...</div>;
  if (!product) return <div className="p-10">Product not found</div>;

  return (
    <div className="p-10">
      <div className="flex items-center gap-5 mb-16">
        <div className="bg-primary w-5 h-10 rounded-sm"></div>
        <p className="text-primary font-semibold">{product.nama_produk}</p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-10">
        <div>
          {product.foto ? (
            <img
              src={`http://127.0.0.1:8000/storage/${product.foto}`}
              alt={product.nama_produk}
              className="w-full max-w-md rounded-lg object-cover"
            />
          ) : (
            <div className="w-full h-80 bg-gray-200 rounded-lg flex items-center justify-center">
              Tidak ada gambar
            </div>
          )}
        </div>

        <div className="space-y-4">
          <h1 className="text-3xl font-bold">{product.nama_produk}</h1>

          <p className="text-2xl text-primary font-semibold">
            Rp {Number(product.harga).toLocaleString('id-ID')}
          </p>

          <p className="text-gray-700">Stok: {product.stok}</p>

          <div>
            <h2 className="font-semibold mb-2">Deskripsi</h2>
            <p className="text-gray-600">
              {product.deskripsi || 'Tidak ada deskripsi'}
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}
