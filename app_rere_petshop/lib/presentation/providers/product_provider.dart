// lib/presentation/providers/product_provider.dart
import 'package:flutter/material.dart';
import '../../data/models/product_model.dart';
import '../../data/models/category_model.dart';
import '../../data/services/api_service.dart';

class ProductProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _products = [];
  List<Product> _featuredProducts = [];
  List<Category> _categories = [];
  List<Product> _searchResults = [];

  bool _isLoading = false;
  bool _isSearching = false;
  String? _error;
  int? _selectedCategoryId;

  // Getters
  List<Product> get products => _products;
  List<Product> get featuredProducts => _featuredProducts;
  List<Category> get categories => _categories;
  List<Product> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get error => _error;
  int? get selectedCategoryId => _selectedCategoryId;

  // ─── FETCH DATA ──────────────────────────────────────────

  Future<void> fetchHomeData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _apiService.getProducts(),
        _apiService.getCategories(),
      ]);
      _featuredProducts = (results[0] as List<Product>).take(8).toList();
      _categories = results[1] as List<Category>;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchProductsByCategory(int? categoryId) async {
    _selectedCategoryId = categoryId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _products = await _apiService.getProducts(categoryId: categoryId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> searchProducts(String query) async {
    if (query.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _isSearching = true;
    notifyListeners();

    try {
      _searchResults = await _apiService.searchProducts(query);
    } catch (e) {
      _searchResults = [];
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }

  void clearSearch() {
    _searchResults = [];
    notifyListeners();
  }
}
