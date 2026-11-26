// lib/core/constants/app_constants.dart
import 'package:flutter/foundation.dart';

class AppConstants {
  // ── KONFIGURASI API ──────────────────────────────────────────────
  // Default: backend LARAVEL LOKAL.
  //
  // Bisa dioverride tanpa ubah kode, contoh:
  //   flutter run                                                      -> otomatis (web/desktop/iOS: 127.0.0.1, emulator Android: 10.0.2.2)
  //   flutter run --dart-define=API_BASE_URL=http://192.168.1.40:8000  -> HP fisik (pakai IP LAN laptop)
  //   flutter run --dart-define=API_BASE_URL=https://api.rerepetshop.biz.id -> produksi
  static const String _apiOverride = String.fromEnvironment('API_BASE_URL');

  static const String localHost = 'http://127.0.0.1:8000';

  // Emulator Android tidak bisa pakai 127.0.0.1; 10.0.2.2 = localhost komputer host.
  static const String androidEmulatorHost = 'http://10.0.2.2:8000';

  static String get baseDomain {
    if (_apiOverride.isNotEmpty) return _apiOverride;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return androidEmulatorHost;
    }
    return localHost;
  }

  static String get baseUrl => '$baseDomain/api';
  static String get storageUrl => '$baseDomain/storage';

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