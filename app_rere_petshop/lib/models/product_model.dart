// lib/data/models/product_model.dart

class Product {
  final int id;
  final String name;
  final double price;
  final String? description;
  final String? image;
  final int? stock;
  final String? category;
  final int? categoryId;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.image,
    this.stock,
    this.category,
    this.categoryId,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    // Ambil path foto dari JSON
    String? fotoPath = json['foto'];

    // Hapus 'produk/' prefix jika ada (biar tidak double)
    if (fotoPath != null && fotoPath.startsWith('produk/')) {
      fotoPath = fotoPath.substring(7);
    }

    return Product(
      id: json['id_produk'] ?? json['id'] ?? 0,
      name: json['nama_produk'] ?? '',
      price: double.tryParse(json['harga']?.toString() ?? '0') ?? 0,
      description: json['deskripsi'],
      // ⚠️ PERHATIKAN: ini pakai API, BUKAN storage langsung!
      image: fotoPath != null
          ? 'https://api.rerepetshop.biz.id/api/image/$fotoPath'
          : null,
      stock: json['stok'],
      category: json['kategori']?['nama_kategori'],
      categoryId: json['id_kategori'],
    );
  }

  bool get isInStock => (stock ?? 0) > 0;

  String get formattedPrice {
    return 'Rp ${price.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }
}
