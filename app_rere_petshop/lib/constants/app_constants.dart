// lib/core/constants/app_constants.dart
import 'package:flutter/foundation.dart';

class AppConstants {
  // Android emulator reaches the host machine through 10.0.2.2.
  // Physical devices should use the deployed API or the computer's LAN address.
  static String get baseUrl {
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://192.168.0.3:8000/api';
    }
    return 'http://127.0.0.1:8000/api';
  }

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
