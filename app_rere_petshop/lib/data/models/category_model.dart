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
      id: json['id'] ?? 0,
      name: json['name'] ?? json['nama'] ?? '',
      icon: json['icon'],
      productCount: json['products_count'] ?? json['jumlah_produk'],
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
