// lib/presentation/screens/search/search_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../product/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  bool _hasSearched = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _search(String query) {
    if (query.trim().isEmpty) return;
    setState(() => _hasSearched = true);
    context.read<ProductProvider>().searchProducts(query.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
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
          _buildSearchBar(),
          Expanded(child: _buildSearchResult()),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: TextField(
        controller: _controller,
        autofocus: false,
        onSubmitted: _search,
        decoration: InputDecoration(
          hintText: 'Cari makanan, obat, mainan...',
          hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: AppColors.grey),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: AppColors.grey),
                  onPressed: () {
                    _controller.clear();
                    context.read<ProductProvider>().clearSearch();
                    setState(() => _hasSearched = false);
                  },
                )
              : null,
          filled: true,
          fillColor: AppColors.greyBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        onChanged: (val) {
          setState(() {});
          if (val.length >= 3) _search(val);
        },
      ),
    );
  }

  Widget _buildSearchResult() {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        // Belum search
        if (!_hasSearched) {
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
                  'Ketik nama produk, kategori, atau merek',
                  style: TextStyle(fontSize: 13, color: AppColors.grey),
                ),
              ],
            ),
          );
        }

        // Loading
        if (provider.isSearching) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        // Tidak ada hasil
        if (provider.searchResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.pets, size: 64, color: AppColors.greyLight),
                const SizedBox(height: 16),
                Text(
                  'Produk "${_controller.text}" tidak ditemukan',
                  style: const TextStyle(color: AppColors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        // Hasil search
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Text(
                '${provider.searchResults.length} produk ditemukan',
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
                  childAspectRatio: 0.72,
                ),
                itemCount: provider.searchResults.length,
                itemBuilder: (context, i) {
                  final product = provider.searchResults[i];
                  return ProductCard(
                    product: product,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            ProductDetailScreen(productId: product.id),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
