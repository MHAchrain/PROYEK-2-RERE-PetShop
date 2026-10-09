import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:app_rere_petshop/components/product_card.dart';
import 'package:app_rere_petshop/pages/product/product_detail_page.dart';
import 'package:app_rere_petshop/pages/catalog/catalog_page.dart';
import 'package:app_rere_petshop/providers/product_provider.dart';

class FeaturedSection extends StatelessWidget {
  const FeaturedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 18,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Rekomendasi Produk',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Pilihan terbaik untuk anabul kamu',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CatalogPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Product grid
              if (provider.isLoading)
                _buildShimmerGrid()
              else if (provider.error != null)
                _buildError(provider)
              else if (provider.featuredProducts.isEmpty)
                _buildEmpty()
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.62,
                  ),
                  itemCount: provider.featuredProducts.length,
                  itemBuilder: (context, i) {
                    final product = provider.featuredProducts[i];
                    return ProductCard(
                      product: product,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailPage(productId: product.id),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.62,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildError(ProductProvider provider) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.wifi_off, size: 48, color: AppColors.grey),
          const SizedBox(height: 8),
          Text(provider.error!, style: const TextStyle(color: AppColors.grey)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => provider.fetchHomeData(),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        children: [
          Icon(Icons.pets, size: 48, color: AppColors.grey),
          SizedBox(height: 8),
          Text('Belum ada produk', style: TextStyle(color: AppColors.grey)),
        ],
      ),
    );
  }
}
