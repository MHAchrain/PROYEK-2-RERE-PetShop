import 'dart:async';

import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/models/category_model.dart';
import 'package:app_rere_petshop/models/product_model.dart';
import 'package:app_rere_petshop/pages/product/product_detail_page.dart';
import 'package:app_rere_petshop/pages/search/models/search_filter.dart';
import 'package:app_rere_petshop/pages/search/widgets/product_search_field.dart';
import 'package:app_rere_petshop/pages/search/widgets/search_filter_sheet.dart';
import 'package:app_rere_petshop/pages/search/widgets/search_results_view.dart';
import 'package:app_rere_petshop/providers/product_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  bool _hasSearched = false;
  SearchFilter _filter = const SearchFilter();

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onQueryChanged(String value) {
    _debounce?.cancel();
    final query = value.trim();

    if (query.length < 2) {
      setState(() => _hasSearched = false);
      context.read<ProductProvider>().clearSearch();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) _search(query);
    });
  }

  void _search(String query) {
    if (query.trim().isEmpty) return;
    setState(() => _hasSearched = true);
    context.read<ProductProvider>().searchProducts(query.trim());
  }

  Future<void> _openFilters(List<Category> categories) async {
    final selectedFilter = await showModalBottomSheet<SearchFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SearchFilterSheet(
        categories: categories,
        initialFilter: _filter,
      ),
    );

    if (selectedFilter != null && mounted) {
      setState(() => _filter = selectedFilter);
    }
  }

  List<Product> _filterProducts(List<Product> products) {
    final result = products.where((product) {
      if (_filter.categoryId != null &&
          product.categoryId != _filter.categoryId) {
        return false;
      }
      if (_filter.minPrice != null && product.price < _filter.minPrice!) {
        return false;
      }
      if (_filter.maxPrice != null && product.price > _filter.maxPrice!) {
        return false;
      }
      if (_filter.inStockOnly && !product.isInStock) return false;
      return true;
    }).toList();

    if (_filter.sortOrder == SearchSortOrder.priceLowToHigh) {
      result.sort((a, b) => a.price.compareTo(b.price));
    } else if (_filter.sortOrder == SearchSortOrder.priceHighToLow) {
      result.sort((a, b) => b.price.compareTo(a.price));
    }
    return result;
  }

  void _openProduct(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailPage(productId: product.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Cari Produk',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: Column(
        children: [
          Consumer<ProductProvider>(
            builder: (context, provider, _) => ProductSearchField(
              controller: _controller,
              filterCount: _filter.activeCount,
              onChanged: _onQueryChanged,
              onSubmitted: _search,
              onFilterTap: () => _openFilters(provider.categories),
            ),
          ),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, provider, _) {
                final products = _filterProducts(provider.searchResults);
                return SearchResultsView(
                  hasSearched: _hasSearched,
                  isLoading: provider.isSearching,
                  query: _controller.text,
                  products: products,
                  hasUnfilteredResults: provider.searchResults.isNotEmpty,
                  onProductTap: _openProduct,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
