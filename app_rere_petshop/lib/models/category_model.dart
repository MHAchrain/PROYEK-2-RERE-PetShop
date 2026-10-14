// lib/data/models/category_model.dart

class Category {
  final int id;
  final String name;
  final String? icon;
  final int? productCount;

  Category({
    required this.id,
    required this.name,
    this.icon,
    this.productCount,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: int.tryParse(
            (json['id_kategori'] ?? json['id'] ?? 0).toString(),
          ) ??
          0,
      name: json['nama_kategori'] ?? json['name'] ?? json['nama'] ?? '',
      icon: json['icon'],
      productCount: int.tryParse(
        (json['products_count'] ?? json['jumlah_produk'] ?? '').toString(),
      ),
    );
  }

  // Icon mapping berdasarkan nama kategori
  String get iconEmoji {
    switch (name.toLowerCase()) {
      case 'food':
      case 'makanan':
        return '🍖';
      case 'toys':
      case 'mainan':
        return '🧸';
      case 'medicine':
      case 'obat':
        return '💊';
      case 'grooming':
        return '✂️';
      case 'equipment':
      case 'perlengkapan':
        return '🔧';
      default:
        return '🐾';
    }
  }
}
