// lib/data/services/api_service.dart
import 'package:dio/dio.dart';
import 'package:app_rere_petshop/models/product_model.dart';
import 'package:app_rere_petshop/models/category_model.dart';
import 'package:app_rere_petshop/constants/app_constants.dart';
import 'package:app_rere_petshop/services/auth_service.dart';

class ApiService {
  late final Dio _dio;
  final AuthService _authService = AuthService();

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    ));

    // Interceptor untuk logging (debug)
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  Future<Options> _authOptions() async {
    return _authService.authOptions();
  }

  Future<void> addToCart(int productId) async {
    try {
      await _dio.post('/cart/add', data: {'id_produk': productId, 'qty': 1}, options: await _authOptions());
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<bool> toggleWishlist(int productId) async {
    try {
      final response = await _dio.post('/favorites', data: {'produk_id': productId}, options: await _authOptions());
      return response.data['is_favorite'] == true;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getCart() async {
    try {
      final response = await _dio.get('/cart', options: await _authOptions());
      return Map<String, dynamic>.from(response.data['data'] ?? {});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ─── PRODUCTS ─────────────────────────────────────────────

  Future<List<Product>> getProducts({int? categoryId, int page = 1}) async {
    try {
      final response = await _dio.get(
        AppConstants.productsEndpoint,
        queryParameters: {
          if (categoryId != null) 'id_kategori': categoryId,
          'page': page,
        },
      );
      final data = response.data;
      List<dynamic> items;
      if (data is List) {
        items = data;
      } else if (data['data'] is List) {
        items = data['data'];
      } else {
        items = [];
      }
      return items.map((e) => Product.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Product> getProductDetail(int id) async {
    try {
      final response = await _dio.get('${AppConstants.productsEndpoint}/$id');
      final data = response.data;
      // Response: {"success": true, "data": {...}}
      return Product.fromJson(data['data'] ?? data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Product>> searchProducts(String query) async {
    try {
      final response = await _dio.get(
        AppConstants.productsEndpoint,
        queryParameters: {'search': query},
      );
      final data = response.data;
      List<dynamic> items = data is List ? data : (data['data'] ?? []);
      return items.map((e) => Product.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ─── CATEGORIES ───────────────────────────────────────────

  Future<List<Category>> getCategories() async {
    try {
      final response = await _dio.get(AppConstants.categoriesEndpoint);
      final data = response.data;
      List<dynamic> items = data is List ? data : (data['data'] ?? []);
      return items.map((e) => Category.fromJson(e)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ─── ERROR HANDLER ────────────────────────────────────────

  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Koneksi timeout. Periksa internet kamu.';
      case DioExceptionType.connectionError:
        return 'Tidak bisa terhubung ke server.';
      default:
        return e.response?.data?['message']?.toString() ?? 'Terjadi kesalahan.';
    }
  }
}
