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

  Future<void> addToCart(int productId, {int quantity = 1}) async {
    try {
      await _dio.post(
        '/cart/add',
        data: {'id_produk': productId, 'qty': quantity},
        options: await _authOptions(),
      );
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

  Future<void> updateCartItem(int itemId, int quantity) async {
    try {
      await _dio.patch(
        '/cart/item/$itemId',
        data: {'qty': quantity},
        options: await _authOptions(),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> removeCartItem(int itemId) async {
    try {
      await _dio.delete(
        '/cart/item/$itemId',
        options: await _authOptions(),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> createOrder({
    required List<int> itemIds,
    required String address,
    required String phone,
  }) async {
    try {
      final response = await _dio.post(
        '/checkout',
        data: {
          'item_ids': itemIds,
          'alamat_kirim': address,
          'no_telp': phone,
        },
        options: await _authOptions(),
      );
      return Map<String, dynamic>.from(response.data['data'] ?? {});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, String>> createPayment(int orderId) async {
    try {
      final response = await _dio.post(
        '/pembayaran',
        data: {'id_pesanan': orderId, 'metode_bayar': 'Midtrans'},
        options: await _authOptions(),
      );
      final data = Map<String, dynamic>.from(response.data);
      final token = data['snap_token']?.toString();
      if (token == null || token.isEmpty) {
        throw Exception('Token pembayaran tidak ditemukan.');
      }
      final url = data['redirect_url']?.toString();
      if (url == null || url.isEmpty) {
        throw Exception('URL pembayaran tidak ditemukan.');
      }
      return {'token': token, 'url': url};
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getOrders() async {
    try {
      final response = await _dio.get('/pesanan', options: await _authOptions());
      return (response.data['data'] as List? ?? const [])
          .whereType<Map>()
          .map((order) => Map<String, dynamic>.from(order))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getOrder(int orderId) async {
    try {
      final response = await _dio.get('/pesanan/$orderId', options: await _authOptions());
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

  // ─── GROOMING ─────────────────────────────────────────────

  Future<List<Map<String, dynamic>>> getGroomingServices() async {
    try {
      final response = await _dio.get('/grooming/services');
      final items = response.data is Map ? response.data['data'] : null;
      return (items as List? ?? const [])
          .whereType<Map>()
          .map((service) => Map<String, dynamic>.from(service))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Map<String, dynamic>>> getGroomingSlots(String date) async {
    try {
      final response = await _dio.get(
        '/grooming/slots',
        queryParameters: {'date': date},
      );
      final items = response.data is Map ? response.data['data'] : null;
      return (items as List? ?? const [])
          .whereType<Map>()
          .map((slot) => Map<String, dynamic>.from(slot))
          .toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> createGroomingBooking(
    Map<String, dynamic> bookingData,
  ) async {
    try {
      final response = await _dio.post(
        '/grooming/bookings',
        data: bookingData,
        options: await _authOptions(),
      );
      final result = Map<String, dynamic>.from(response.data['data'] ?? {});
      result['snap_token'] = response.data['snap_token'];
      return result;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> syncGroomingPayment(int bookingId, String paymentStatus) async {
    try {
      await _dio.post(
        '/grooming/bookings/$bookingId/sync-payment',
        data: {'payment_status': paymentStatus},
        options: await _authOptions(),
      );
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getGroomingBooking(int bookingId) async {
    try {
      final response = await _dio.get(
        '/grooming/bookings/$bookingId',
        options: await _authOptions(),
      );
      return Map<String, dynamic>.from(response.data['data'] ?? {});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<String> getGroomingPaymentToken(int bookingId) async {
    try {
      final response = await _dio.get(
        '/grooming/bookings/$bookingId/payment-token',
        options: await _authOptions(),
      );
      final token = response.data['snap_token']?.toString();
      if (token == null || token.isEmpty) {
        throw Exception('Token pembayaran tidak ditemukan.');
      }
      return token;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  // ─── ARPET AI CHAT ────────────────────────────────────────

  Future<Map<String, dynamic>> sendChatAI(String message, {dynamic imageBytes, String? imageName}) async {
    try {
      dynamic data;
      if (imageBytes != null && imageName != null) {
        data = FormData.fromMap({
          if (message.trim().isNotEmpty) 'message': message.trim(),
          'image': MultipartFile.fromBytes(imageBytes, filename: imageName),
        });
      } else {
        data = {'message': message.trim()};
      }

      final response = await _dio.post(
        '/chat-ai',
        data: data,
        options: await _authOptions(),
      );
      return Map<String, dynamic>.from(response.data ?? {});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> sendChatGemini(String message, {dynamic imageBytes, String? imageName}) async {
    try {
      dynamic data;
      if (imageBytes != null && imageName != null) {
        data = FormData.fromMap({
          if (message.trim().isNotEmpty) 'message': message.trim(),
          'image': MultipartFile.fromBytes(imageBytes, filename: imageName),
        });
      } else {
        data = {'message': message.trim()};
      }

      final response = await _dio.post(
        '/chat-gemini',
        data: data,
        options: await _authOptions(),
      );
      return Map<String, dynamic>.from(response.data ?? {});
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

