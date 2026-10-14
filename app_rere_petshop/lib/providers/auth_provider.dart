import 'package:flutter/foundation.dart';
import 'package:app_rere_petshop/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _auth = AuthService();
  bool _isLoggedIn = false;
  String? _displayName;

  bool get isLoggedIn => _isLoggedIn;
  String? get displayName => _displayName;

  Future<void> refreshProfile() async {
    _isLoggedIn = await _auth.hasAuthToken();
    if (!_isLoggedIn) {
      _displayName = null;
      notifyListeners();
      return;
    }

    try {
      final profile = await _auth.getCurrentUser();
      final user = profile['user'] as Map?;
      final customer = profile['pelanggan'] as Map?;
      _displayName = (user?['name'] ?? customer?['nama'] ?? customer?['nama_pelanggan'])?.toString();
    } catch (_) {
      _displayName ??= 'Pelanggan';
    }
    notifyListeners();
  }
}
