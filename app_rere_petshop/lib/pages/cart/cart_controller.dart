import 'package:app_rere_petshop/pages/auth/login_page.dart';
import 'package:app_rere_petshop/services/api_service.dart';
import 'package:app_rere_petshop/services/auth_service.dart';
import 'package:flutter/material.dart';

class CartController extends ChangeNotifier {
  final ApiService _api = ApiService();
  final AuthService _auth = AuthService();
  bool _isDisposed = false;

  bool isLoading = true;
  bool isDeleting = false;
  String? error;
  Map<String, dynamic> cart = {};
  final Set<int> selectedItemIds = {};
  final Set<int> updatingItemIds = {};
  bool _selectionInitialized = false;

  List<Map<String, dynamic>> get items =>
      (cart['items'] as List? ?? const [])
          .whereType<Map>()
          .map((item) => Map<String, dynamic>.from(item))
          .toList();

  List<int> get selectedIds => items
      .map((item) => _itemId(item))
      .whereType<int>()
      .where(selectedItemIds.contains)
      .toList();

  num get selectedTotal => items
      .where((item) => selectedItemIds.contains(_itemId(item)))
      .fold<num>(
        0,
        (total, item) =>
            total + (num.tryParse(item['subtotal']?.toString() ?? '') ?? 0),
      );

  Future<void> load(BuildContext context) async {
    isLoading = true;
    error = null;
    _notify();

    try {
      if (!await _auth.hasAuthToken()) {
        if (!context.mounted) return;
        final loggedIn = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
        if (loggedIn != true) {
          error = 'Masuk untuk melihat keranjang.';
          return;
        }
      }

      final result = await _api.getCart();
      if (!context.mounted) return;
      cart = result;
      final availableIds = items.map(_itemId).whereType<int>().toSet();
      selectedItemIds.removeWhere((id) => !availableIds.contains(id));
      if (!_selectionInitialized) {
        selectedItemIds.addAll(availableIds);
        _selectionInitialized = true;
      }
    } catch (exception) {
      error = exception.toString();
    } finally {
      isLoading = false;
      _notify();
    }
  }

  void toggleAll(bool selected) {
    selectedItemIds
      ..clear()
      ..addAll(selected ? items.map(_itemId).whereType<int>() : const <int>[]);
    _notify();
  }

  void toggleItem(int itemId, bool selected) {
    if (selected) {
      selectedItemIds.add(itemId);
    } else {
      selectedItemIds.remove(itemId);
    }
    _notify();
  }

  Future<String?> changeQuantity(Map<String, dynamic> item, int delta) async {
    final id = _itemId(item);
    final currentQty = int.tryParse(item['qty']?.toString() ?? '') ?? 1;
    final nextQty = currentQty + delta;
    if (id == null ||
        nextQty < 1 ||
        isDeleting ||
        updatingItemIds.contains(id)) {
      return null;
    }

    final updatedItems = _copyItems();
    final index = updatedItems.indexWhere((entry) => _itemId(entry) == id);
    if (index < 0) return null;

    final previousItem = Map<String, dynamic>.from(updatedItems[index]);
    final price = _unitPrice(previousItem, currentQty);
    updatedItems[index]['qty'] = nextQty;
    updatedItems[index]['subtotal'] = price * nextQty;
    cart = {...cart, 'items': updatedItems};
    updatingItemIds.add(id);
    _notify();

    String? actionError;
    try {
      await _api.updateCartItem(id, nextQty);
    } catch (exception) {
      final currentItems = _copyItems();
      final currentIndex = currentItems.indexWhere((entry) => _itemId(entry) == id);
      if (currentIndex >= 0) currentItems[currentIndex] = previousItem;
      cart = {...cart, 'items': currentItems};
      actionError = 'Gagal mengubah jumlah barang: $exception';
    } finally {
      updatingItemIds.remove(id);
      _notify();
    }
    return actionError;
  }

  Future<String?> deleteSelected() async {
    final ids = selectedIds;
    if (ids.isEmpty || isDeleting || updatingItemIds.isNotEmpty) return null;

    isDeleting = true;
    _notify();
    String? actionError;
    try {
      for (final id in ids) {
        await _api.removeCartItem(id);
      }
      final remainingItems = _copyItems()
        ..removeWhere((item) => ids.contains(_itemId(item)));
      cart = {...cart, 'items': remainingItems};
      selectedItemIds.removeAll(ids);
    } catch (exception) {
      actionError = 'Gagal menghapus barang: $exception';
    } finally {
      isDeleting = false;
      _notify();
    }
    return actionError;
  }

  List<Map<String, dynamic>> _copyItems() =>
      (cart['items'] as List? ?? const [])
          .map((entry) => entry is Map
              ? Map<String, dynamic>.from(entry)
              : <String, dynamic>{})
          .toList();

  int? _itemId(Map item) => int.tryParse(item['id_item']?.toString() ?? '');

  num _unitPrice(Map<String, dynamic> item, int quantity) {
    final storedPrice = num.tryParse(item['harga_satuan']?.toString() ?? '');
    if (storedPrice != null) return storedPrice;
    if (quantity <= 0) return 0;
    return (num.tryParse(item['subtotal']?.toString() ?? '') ?? 0) / quantity;
  }

  void _notify() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
