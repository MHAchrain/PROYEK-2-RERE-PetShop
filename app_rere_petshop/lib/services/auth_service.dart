import 'package:dio/dio.dart';
import 'package:app_rere_petshop/constants/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  late final Dio _dio;

  AuthService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 45),
      receiveTimeout: const Duration(seconds: 45),
      sendTimeout: const Duration(seconds: 45),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'X-Client-Platform': 'mobile',
      },
    ));
  }

  Future<Options> authOptions() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    return Options(headers: {
      if (token != null) 'Authorization': 'Bearer $token',
      'ngrok-skip-browser-warning': 'true',
    });
  }

  Future<bool> hasAuthToken() async =>
      (await SharedPreferences.getInstance()).getString('auth_token') != null;

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _dio.get('/me', options: await authOptions());
      return Map<String, dynamic>.from(response.data['data'] ?? {});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> updateCustomerProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    try {
      final response = await _dio.post(
        '/pelanggan/update',
        data: {
          if (name != null) 'nama': name,
          if (phone != null) 'no_hp': phone,
          if (address != null) 'alamat': address,
        },
        options: await authOptions(),
      );
      return Map<String, dynamic>.from(response.data['data'] ?? {});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getCaptcha() async {
    try {
      final response = await _dio.get('/captcha');
      return Map<String, dynamic>.from(response.data ?? {});
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> login(
    String email,
    String password, {
    String? captchaKey,
    String? captchaCode,
  }) async {
    try {
      final response = await _dio.post('/login', data: {
        'email': email,
        'password': password,
        if (captchaKey != null) 'captcha_key': captchaKey,
        if (captchaCode != null) 'captcha_code': captchaCode,
      });
      final token = response.data['token']?.toString();
      if (token == null || token.isEmpty) {
        throw Exception('Token login tidak ditemukan.');
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> loginWithGoogle(String googleToken) async {
    try {
      final response = await _dio.post('/auth/google', data: {
        'token': googleToken,
      });
      final token = response.data['token']?.toString();
      if (token == null || token.isEmpty) {
        throw Exception('Token autentikasi tidak ditemukan.');
      }
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    String? phone,
    String? address,
  }) async {
    try {
      await _dio.post('/register', data: {
        'name': name,
        'email': email,
        'password': password,
        if (phone != null && phone.trim().isNotEmpty) 'no_hp': phone.trim(),
        if (address != null && address.trim().isNotEmpty) 'alamat': address.trim(),
      });
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  String _handleError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Koneksi timeout. Periksa internet kamu.';
      case DioExceptionType.connectionError:
        return 'Tidak bisa terhubung ke server.';
      case DioExceptionType.badCertificate:
        return 'Sertifikat server tidak valid.';
      case DioExceptionType.cancel:
        return 'Permintaan dibatalkan.';
      case DioExceptionType.badResponse:
        return _messageFromResponse(e);
      default:
        return _messageFromResponse(e);
    }
  }

  String _messageFromResponse(DioException e) {
    final data = e.response?.data;
    final status = e.response?.statusCode;

    if (data is Map && data['message'] != null) {
      return data['message'].toString();
    }

    if (status == null) return 'Terjadi kesalahan.';

    if (status >= 500) {
      return 'Server sedang tidak tersedia (HTTP $status). Coba lagi nanti.';
    }
    return 'Terjadi kesalahan (HTTP $status).';
  }
}
