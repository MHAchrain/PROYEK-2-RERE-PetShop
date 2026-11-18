import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/models/category_model.dart';
import 'package:app_rere_petshop/models/product_model.dart';
import 'package:app_rere_petshop/providers/product_provider.dart';
import 'package:app_rere_petshop/components/pet_loading_indicator.dart';
import 'package:app_rere_petshop/components/product_card.dart';
import 'package:app_rere_petshop/pages/product/product_detail_page.dart';
import 'package:app_rere_petshop/pages/search/models/search_filter.dart';
import 'package:app_rere_petshop/pages/search/widgets/search_filter_sheet.dart';

class CatalogPage extends StatefulWidget {
  final String? initialCategory;

  /// `false` saat dipakai sebagai tab di bottom navigation
  /// (tanpa tombol back).
  final bool showBackButton;

  const CatalogPage({
    super.key,
    this.initialCategory,
    this.showBackButton = true,
  });

  @override
  State<CatalogPage> createState() => _CatalogPageState();
}

class _CatalogPageState extends State<CatalogPage> {
  String _selectedCategory = 'Semua';

  /// Filter tambahan (harga, stok, urutan) yang dipakai di halaman katalog.
  /// Kategori tetap ditangani lewat chip di atas, sama seperti sebelumnya.
  SearchFilter _filter = const SearchFilter();

  final List<String> _categoryFilters = [
    'Semua',
    'Equipment',
    'Toys',
    'Medicine',
    'Food',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialCategory != null) {
      _selectedCategory = widget.initialCategory!;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProducts();
    });
  }

  void _loadProducts() {
    final provider = context.read<ProductProvider>();
    provider.fetchProductsByCategory(
      _resolveCategoryId(_selectedCategory, provider.categories),
    );
  }

  /// Mengubah nama kategori (chip) menjadi id kategori.
  int? _resolveCategoryId(String name, List<Category> categories) {
    if (name == 'Semua') return null;

    final match = categories.where(
      (c) => c.name.toLowerCase() == name.toLowerCase(),
    );
    if (match.isNotEmpty) return match.first.id;

    const Map<String, int> fallbackMap = {
      'Food': 1,
      'Medicine': 2,
      'Toys': 3,
      'Equipment': 4,
    };
    return fallbackMap[name];
  }

  Future<void> _openFilters() async {
    final categories = context.read<ProductProvider>().categories;

    // Hanya kirim id kategori yang benar-benar ada di daftar kategori,
    // supaya dropdown di bottom sheet tidak error.
    int? currentCategoryId;
    for (final category in categories) {
      if (category.name.toLowerCase() == _selectedCategory.toLowerCase()) {
        currentCategoryId = category.id;
        break;
      }
    }

    final initialFilter = SearchFilter(
      categoryId: currentCategoryId,
      minPrice: _filter.minPrice,
      maxPrice: _filter.maxPrice,
      inStockOnly: _filter.inStockOnly,
      sortOrder: _filter.sortOrder,
    );

    final selectedFilter = await showModalBottomSheet<SearchFilter>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => SearchFilterSheet(
        categories: categories,
        initialFilter: initialFilter,
      ),
    );

    if (selectedFilter == null || !mounted) return;

    // Kategori dari bottom sheet disinkronkan ke chip di atas supaya
    // tidak dobel filter (chip = data dari server, sisanya lokal).
    String? categoryName;
    if (selectedFilter.categoryId != null) {
      for (final category in categories) {
        if (category.id == selectedFilter.categoryId) {
          categoryName = category.name;
          break;
        }
      }
    }
    final newCategory = selectedFilter.categoryId == null
        ? 'Semua'
        : (categoryName ?? _selectedCategory);
    final categoryChanged = newCategory != _selectedCategory;

    setState(() {
      _filter = SearchFilter(
        minPrice: selectedFilter.minPrice,
        maxPrice: selectedFilter.maxPrice,
        inStockOnly: selectedFilter.inStockOnly,
        sortOrder: selectedFilter.sortOrder,
      );
      _selectedCategory = newCategory;
    });

    if (categoryChanged) _loadProducts();
  }

  void _resetFilter() {
    setState(() => _filter = const SearchFilter());
  }

  /// Filter harga, stok, dan urutan di sisi aplikasi.
  List<Product> _applyFilter(List<Product> products) {
    final result = products.where((product) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        automaticallyImplyLeading: widget.showBackButton,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'KATEGORI',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.primary,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              _selectedCategory == 'Semua' ? 'Semua Produk' : _selectedCategory,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [
          IconButton(
            tooltip: 'Filter produk',
            onPressed: _openFilters,
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.tune, color: AppColors.textPrimary),
                if (_filter.activeCount > 0)
                  Positioned(
                    right: -1,
                    top: -1,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(
            child: _buildProductGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      color: AppColors.white,
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: _categoryFilters.length,
        itemBuilder: (context, i) {
          final cat = _categoryFilters[i];
          final isSelected = cat == _selectedCategory;
          return GestureDetector(
            onTap: () {
              setState(() => _selectedCategory = cat);
              _loadProducts();
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.greyLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                cat,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductGrid() {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const PetLoadingIndicator(
            message: 'Mencari produk anabul...',
          );
        }

        if (provider.error != null && provider.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, size: 64, color: AppColors.grey),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Text(
                    provider.error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.grey, fontSize: 14),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadProducts,
                  child: const Text('Coba Lagi'),
                ),
              ],
            ),
          );
        }

        if (provider.products.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.pets, size: 64, color: AppColors.grey),
                SizedBox(height: 12),
                Text(
                  'Tidak ada produk',
                  style: TextStyle(color: AppColors.grey, fontSize: 16),
                ),
              ],
            ),
          );
        }

        final products = _applyFilter(provider.products);

        if (products.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.filter_alt_off_outlined,
                      size: 64, color: AppColors.grey),
                  const SizedBox(height: 12),
                  const Text(
                    'Tidak ada produk yang cocok dengan filter',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _resetFilter,
                    child: const Text('Reset Filter'),
                  ),
                ],
              ),
            ),
          );
        }

        return GridView.builder(
          padding: const EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            childAspectRatio: 0.62,
          ),
          itemCount: products.length,
          itemBuilder: (context, i) {
            final product = products[i];
            return ProductCard(
              product: product,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailPage(productId: product.id),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
