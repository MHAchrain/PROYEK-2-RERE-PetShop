// lib/presentation/providers/product_provider.dart
import 'package:flutter/material.dart';
import 'package:app_rere_petshop/models/product_model.dart';
import 'package:app_rere_petshop/models/category_model.dart';
import 'package:app_rere_petshop/services/api_service.dart';

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

    // Produk dan kategori dipanggil terpisah supaya kalau salah satu gagal,
    // data yang berhasil tetap tampil (sebelumnya pakai Future.wait:
    // satu gagal = semua kosong).
    try {
      final products = await _apiService.getProducts();
      _featuredProducts = products.take(8).toList();
    } catch (e) {
      _featuredProducts = [];
      _error = e.toString();
    }

    try {
      _categories = await _apiService.getCategories();
    } catch (_) {
      // Kategori hanya untuk filter, tidak perlu menggagalkan home.
      _categories = [];
    }

    _isLoading = false;
    notifyListeners();
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
