// lib/core/constants/app_constants.dart

class AppConstants {
  // Ganti dengan URL Laravel kamu
  static const String baseUrl =
      'https://api.rerepetshop.biz.id/api'; // untuk Android emulator
  // static const String baseUrl = 'http://localhost:8000/api'; // untuk Chrome/web
  // static const String baseUrl = 'https://your-domain.com/api'; // untuk production

  static const String appName = 'ReRe Petshop';
  static const String whatsappNumber = '6281319410250'; // 0813-1941-0250
  static const String email = 'rereps@gmail.com';
  static const String address = 'Jl. Kecubung 1 No.14, Tangerang';

  // Endpoints
  static const String productsEndpoint = '/produk';
  static const String categoriesEndpoint = '/kategori';
  static const String searchEndpoint = '/produk';

  // Kategori
  static const List<Map<String, String>> categories = [
    {'name': 'Equipment', 'icon': 'equipment'},
    {'name': 'Toys', 'icon': 'toys'},
    {'name': 'Medicine', 'icon': 'medicine'},
    {'name': 'Food', 'icon': 'food'},
    {'name': 'Grooming', 'icon': 'grooming'},
  ];
}
