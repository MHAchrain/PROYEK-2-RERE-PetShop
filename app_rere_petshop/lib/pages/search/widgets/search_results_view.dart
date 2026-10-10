import 'package:app_rere_petshop/components/product_card.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/models/product_model.dart';
import 'package:flutter/material.dart';

class SearchResultsView extends StatelessWidget {
  const SearchResultsView({
    super.key,
    required this.hasSearched,
    required this.isLoading,
    required this.query,
    required this.products,
    required this.hasUnfilteredResults,
    required this.onProductTap,
  });

  final bool hasSearched;
  final bool isLoading;
  final String query;
  final List<Product> products;
  final bool hasUnfilteredResults;
  final ValueChanged<Product> onProductTap;

  @override
  Widget build(BuildContext context) {
    if (!hasSearched) return _buildInitialState();
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (products.isEmpty) return _buildEmptyState();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
          child: Text(
            '${products.length} produk ditemukan',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.62,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(
                product: product,
                onTap: () => onProductTap(product),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildInitialState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: 72, color: AppColors.greyLight),
          SizedBox(height: 16),
          Text(
            'Cari produk petshop',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Ketik nama produk untuk mulai mencari',
            style: TextStyle(fontSize: 13, color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pets, size: 64, color: AppColors.greyLight),
          const SizedBox(height: 16),
          Text(
            hasUnfilteredResults
                ? 'Tidak ada produk yang cocok dengan filter'
                : 'Produk "$query" tidak ditemukan',
            style: const TextStyle(color: AppColors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
