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
    return Product(
      id: json['id_produk'] ?? json['id'] ?? 0,
      name: json['nama_produk'] ?? '',
      price: double.tryParse(json['harga']?.toString() ?? '0') ?? 0,
      description: json['deskripsi'],
      image: json['foto'] != null
          ? 'http://localhost:8000/api/image/${json['foto']}' // ← Pakai API proxy
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
