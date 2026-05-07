// lib/presentation/screens/catalog/catalog_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../product/product_detail_screen.dart';

class CatalogScreen extends StatefulWidget {
  final String? initialCategory;

  const CatalogScreen({super.key, this.initialCategory});

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  String _selectedCategory = 'Semua';

  final List<String> _categoryFilters = [
    'Semua',
    'Equipment',
    'Toys',
    'Medicine',
    'Food',
    'Grooming',
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

    if (_selectedCategory == 'Semua') {
      provider.fetchProductsByCategory(null);
    } else {
      // Mapping nama kategori ke ID
      final Map<String, int> categoryMap = {
        'Equipment': 4,
        'Toys': 3,
        'Medicine': 2,
        'Food': 1,
        'Grooming': 5,
      };

      final categoryId = categoryMap[_selectedCategory];

      // Debug print
      print('Selected: $_selectedCategory, ID: $categoryId');

      provider.fetchProductsByCategory(categoryId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildCategoryFilter(),
          Expanded(child: _buildProductGrid()),
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
              print('Category selected: $cat');
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
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
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

        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.72,
          ),
          itemCount: provider.products.length,
          itemBuilder: (context, i) {
            final product = provider.products[i];
            return ProductCard(
              product: product,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(productId: product.id),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
