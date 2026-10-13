import 'package:flutter/foundation.dart';
import 'package:app_rere_petshop/services/api_service.dart';
import 'package:app_rere_petshop/services/auth_service.dart';

class CartProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final AuthService _auth = AuthService();
  int _itemCount = 0;

  int get itemCount => _itemCount;

  Future<void> refreshCount() async {
    try {
      if (!await _auth.hasAuthToken()) {
        _itemCount = 0;
        notifyListeners();
        return;
      }

      final cart = await _apiService.getCart();
      final items = cart['items'] as List? ?? const [];
      _itemCount = items.fold<int>(0, (total, item) {
        if (item is! Map) return total;
        final qty = int.tryParse(item['qty']?.toString() ?? '') ?? 1;
        return total + qty;
      });
      notifyListeners();
    } catch (_) {
      // Keep the last known count if the cart request temporarily fails.
    }
  }
}
