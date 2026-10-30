// lib/core/constants/app_constants.dart

class AppConstants {
  // // API produksi
  // static const String baseDomain = 'https://api.rerepetshop.biz.id';

  // // Base API URL
  // static String get baseUrl => '$baseDomain/api';

  // // Storage / Image Base URL
  // static String get storageUrl => '$baseDomain/storage';

  // API Laravel lokal
  static const String localBaseDomain = 'http://127.0.0.1:8000';
  static String get baseUrl => '$localBaseDomain/api';
  static String get storageUrl => '$localBaseDomain/storage';

  static const String appName = 'ReRe Petshop';
  static const String whatsappNumber = '6281319410250'; // 0813-1941-0250
  static const String email = 'rereps@gmail.com';
  static const String address = 'Jl. Kecubung 1 No.14, Tangerang';

  static const String googleClientId =
      '876505123972-275fabovfuu6pal978bnu7g3gb9kp50t.apps.googleusercontent.com';
  static const String midtransClientKey = 'Mid-client-kbF8O_OJSIc1ljLp';

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
