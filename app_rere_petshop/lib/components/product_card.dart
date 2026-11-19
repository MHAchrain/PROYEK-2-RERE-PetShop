import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/models/product_model.dart';
import 'package:app_rere_petshop/pages/cart/cart_page.dart';
import 'package:app_rere_petshop/pages/auth/login_page.dart';
import 'package:app_rere_petshop/services/api_service.dart';
import 'package:app_rere_petshop/services/auth_service.dart';
import 'package:app_rere_petshop/providers/cart_provider.dart';
import 'package:app_rere_petshop/providers/wishlist_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  final ApiService _api = ApiService();
  final AuthService _auth = AuthService();

  // Status loading dipisah supaya klik icon love tidak membuat
  // tombol "Beli" ikut berputar.
  bool _cartBusy = false;
  bool _wishlistBusy = false;

  Future<bool> _ensureLogin() async {
    if (await _auth.hasAuthToken()) return true;
    if (!mounted) return false;
    return await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        ) == true;
  }

  String _titleCase(String text) {
  return text
      .trim()
      .split(RegExp(r'\s+'))
      .map((word) => word.isEmpty
          ? word
          : '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}')
      .join(' ');
  }

  Future<void> _addToCart() async {
    if (!widget.product.isInStock || _cartBusy) return;
    setState(() => _cartBusy = true);
    try {
      if (!await _ensureLogin()) return;
      await _api.addToCart(widget.product.id);
      if (!mounted) return;
      await context.read<CartProvider>().refreshCount();
      if (!mounted) return;
      Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _cartBusy = false);
    }
  }

  Future<void> _toggleWishlist() async {
    if (_wishlistBusy) return;
    setState(() => _wishlistBusy = true);
    try {
      if (!await _ensureLogin()) return;
      if (!mounted) return;
      final isFavorite =
          await context.read<WishlistProvider>().toggle(widget.product);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isFavorite
                ? 'Produk ditambahkan ke wishlist'
                : 'Produk dihapus dari wishlist',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _wishlistBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final isFavorite = context.watch<WishlistProvider>().isFavorite(product.id);
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(20),
      elevation: 1.5,
      shadowColor: Colors.black.withValues(alpha: .08),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        splashColor: AppColors.primary.withValues(alpha: 0.12),
        highlightColor: AppColors.primary.withValues(alpha: 0.06),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              flex: 6,
              child: Stack(children: [
                Positioned.fill(
                  child: ClipRRect(borderRadius: BorderRadius.circular(16), child: _buildImage()),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Material(
                    color: Colors.white.withValues(alpha: .95),
                    shape: const CircleBorder(),
                    elevation: 3,
                    child: IconButton(
                      tooltip: isFavorite
                          ? 'Hapus dari wishlist'
                          : 'Tambah ke wishlist',
                      visualDensity: VisualDensity.compact,
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        
                        highlightColor: Colors.transparent,
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: _wishlistBusy ? null : _toggleWishlist,
                      icon: _wishlistBusy
                          ? SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary.withValues(alpha: 0.7),
                                ),
                              ),
                            )
                          : Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite
                                  ? AppColors.primary
                                  : AppColors.textSecondary,
                              size: 20,
                            ),
                    ),
                  ),
                ),
                if (!product.isInStock)
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: .48), borderRadius: BorderRadius.circular(16)),
                      child: const Center(child: Text('Stok Habis', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                    ),
                  ),
              ]),
            ),
            const SizedBox(height: 10),
            Text(_titleCase(product.name), maxLines: 2, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, height: 1.2, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            Text(product.formattedPrice, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.primary)),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed:
                    _cartBusy || !product.isInStock ? null : _addToCart,
                icon: _cartBusy
                    ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.add, size: 20),
                label: const Text('Beli'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.grey,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  textStyle: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget _buildImage() {
    final image = widget.product.image;
    if (image == null || image.isEmpty) {
      return Container(color: AppColors.greyBg, child: const Icon(Icons.pets, size: 48, color: AppColors.grey));
    }
    return CachedNetworkImage(
      imageUrl: image,
      fit: BoxFit.cover,
      placeholder: (_, __) => Shimmer.fromColors(baseColor: AppColors.greyLight, highlightColor: AppColors.white, child: Container(color: AppColors.greyLight)),
      errorWidget: (_, __, ___) => Container(color: AppColors.greyBg, child: const Icon(Icons.pets, size: 48, color: AppColors.grey)),
    );
  }
}
