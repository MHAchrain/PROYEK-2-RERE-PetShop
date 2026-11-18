import 'package:flutter/foundation.dart';
import 'package:app_rere_petshop/models/product_model.dart';
import 'package:app_rere_petshop/services/api_service.dart';
import 'package:app_rere_petshop/services/auth_service.dart';

/// Menyimpan daftar wishlist (produk favorit) milik user yang sedang login.
///
/// Dipakai oleh:
/// - [ProductCard] untuk menandai icon love sudah aktif / belum
/// - halaman Wishlist di Profil untuk menampilkan daftar produk favorit
class WishlistProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  final AuthService _auth = AuthService();

  List<Product> _items = const [];
  Set<int> _ids = <int>{};
  bool _isLoading = false;
  bool _hasLoaded = false;
  String? _error;

  List<Product> get items => _items;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get count => _ids.length;

  bool isFavorite(int productId) => _ids.contains(productId);

  Future<void> load({bool force = false}) async {
    if (_isLoading) return;
    if (_hasLoaded && !force) return;

    if (!await _auth.hasAuthToken()) {
      _items = const [];
      _ids = <int>{};
      _hasLoaded = false;
      _error = null;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final items = await _api.getFavorites();
      _items = items;
      _ids = items.map((product) => product.id).toSet();
      _hasLoaded = true;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Menambahkan produk ke wishlist, atau menghapusnya kalau sudah ada.
  /// Mengembalikan `true` kalau produk sekarang berstatus favorit.
  Future<bool> toggle(Product product) async {
    final isFavorite = await _api.toggleWishlist(product.id);

    if (isFavorite) {
      _ids.add(product.id);
      if (!_items.any((item) => item.id == product.id)) {
        _items = [product, ..._items];
      }
    } else {
      _ids.remove(product.id);
      _items = _items.where((item) => item.id != product.id).toList();
    }

    notifyListeners();
    return isFavorite;
  }

  /// Dipanggil saat logout supaya data user sebelumnya tidak tertinggal.
  void reset() {
    _items = const [];
    _ids = <int>{};
    _hasLoaded = false;
    _error = null;
    notifyListeners();
  }
}
