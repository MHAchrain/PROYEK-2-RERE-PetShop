import 'package:app_rere_petshop/components/pet_loading_indicator.dart';
import 'package:app_rere_petshop/components/product_card.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/auth/login_page.dart';
import 'package:app_rere_petshop/pages/product/product_detail_page.dart';
import 'package:app_rere_petshop/providers/auth_provider.dart';
import 'package:app_rere_petshop/providers/wishlist_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WishlistProvider>().load(force: true);
    });
  }

  Future<void> _openLogin() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
    if (result == true && mounted) {
      await context.read<WishlistProvider>().load(force: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Wishlist'),
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
      ),
      body: Consumer<WishlistProvider>(
        builder: (context, wishlist, _) {
          if (wishlist.isLoading && wishlist.items.isEmpty) {
            return const PetLoadingIndicator(
              message: 'Memuat wishlist kamu...',
            );
          }

          if (wishlist.error != null && wishlist.items.isEmpty) {
            return _buildError(wishlist);
          }

          if (wishlist.items.isEmpty) {
            return _buildEmpty(
              isLoggedIn: context.watch<AuthProvider>().isLoggedIn,
            );
          }

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => wishlist.load(force: true),
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 0.62,
              ),
              itemCount: wishlist.items.length,
              itemBuilder: (context, index) {
                final product = wishlist.items[index];
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
            ),
          );
        },
      ),
    );
  }

  Widget _buildError(WishlistProvider wishlist) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 56, color: AppColors.grey),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Text(
              wishlist.error!,
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.grey, fontSize: 14),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => wishlist.load(force: true),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty({required bool isLoggedIn}) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.favorite_border, size: 64, color: AppColors.grey),
            const SizedBox(height: 12),
            const Text(
              'Wishlist kamu masih kosong',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              isLoggedIn
                  ? 'Ketuk icon love pada produk untuk menyimpannya di sini.'
                  : 'Masuk dulu supaya produk yang kamu sukai tersimpan di sini.',
              style: const TextStyle(color: AppColors.grey, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            if (!isLoggedIn) ...[
              const SizedBox(height: 18),
              FilledButton(
                onPressed: _openLogin,
                style:
                    FilledButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text('Masuk ke akun'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
