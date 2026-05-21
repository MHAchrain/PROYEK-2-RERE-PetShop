import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/api_service.dart';
import '../web_view_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final int productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ApiService _apiService = ApiService();
  Product? _product;
  bool _isLoading = true;
  String? _error;
  bool _isDescriptionExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      final product = await _apiService.getProductDetail(widget.productId);
      setState(() {
        _product = product;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _openWebsite() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const WebViewScreen(
          url: 'https://rerepetshop.biz.id',
          title: 'ReRe Petshop',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: _product != null ? _buildBottomBar() : null,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? _buildError()
              : _buildDetail(),
    );
  }

  Widget _buildDetail() {
    final product = _product!;
    final hasDescription =
        product.description != null && product.description!.isNotEmpty;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 320,
          pinned: true,
          backgroundColor: AppColors.white,
          leading: GestureDetector(
            onTap: () {
              if (Navigator.canPop(context)) Navigator.pop(context);
            },
            child: Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: _buildProductImage(product),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: AppColors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header dengan garis
                  Row(
                    children: [
                      Container(
                        width: 4,
                        height: 14,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text('PRODUK',
                          style: TextStyle(
                              fontSize: 11,
                              color: AppColors.primary,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Nama produk
                  Text(product.name,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 8),

                  // Stock badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: product.isInStock
                          ? AppColors.success.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.isInStock ? '✓ In Stock' : '✗ Out of Stock',
                      style: TextStyle(
                          color: product.isInStock
                              ? AppColors.success
                              : Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Harga
                  Text(product.formattedPrice,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                  const SizedBox(height: 16),

                  // Deskripsi produk (dengan tampilan lebih bagus)
                  if (hasDescription) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.greyBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.greyLight,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.description_outlined,
                                  size: 18, color: AppColors.primary),
                              const SizedBox(width: 8),
                              const Text(
                                'Deskripsi Produk',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          AnimatedCrossFade(
                            duration: const Duration(milliseconds: 300),
                            crossFadeState: _isDescriptionExpanded
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            firstChild: Text(
                              product.description!,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                            secondChild: Text(
                              product.description!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.6,
                              ),
                            ),
                          ),
                          if (product.description!.length > 100)
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isDescriptionExpanded =
                                      !_isDescriptionExpanded;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      _isDescriptionExpanded
                                          ? 'Tutup'
                                          : 'Selengkapnya',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Icon(
                                      _isDescriptionExpanded
                                          ? Icons.keyboard_arrow_up
                                          : Icons.keyboard_arrow_down,
                                      size: 18,
                                      color: AppColors.primary,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],

                  const Divider(),
                  const SizedBox(height: 12),

                  // Informasi tambahan
                  _infoTile(
                      icon: Icons.local_shipping_outlined,
                      title: 'Free Shipping',
                      subtitle: 'Gratis ongkir minimal belanja Rp 200.000'),
                  const SizedBox(height: 8),
                  _infoTile(
                      icon: Icons.replay_outlined,
                      title: 'Easy Returns',
                      subtitle: 'Garansi 30 hari pengembalian barang'),
                  const SizedBox(height: 8),
                  _infoTile(
                      icon: Icons.security_outlined,
                      title: 'Produk Original',
                      subtitle: '100% produk asli dan berkualitas'),
                  const SizedBox(height: 80),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductImage(Product product) {
    if (product.image == null || product.image!.isEmpty) {
      return Container(
          color: AppColors.greyLight,
          child: const Icon(Icons.pets, size: 80, color: AppColors.grey));
    }
    return CachedNetworkImage(
      imageUrl: product.image!,
      fit: BoxFit.contain,
      placeholder: (_, __) => const Center(
          child: CircularProgressIndicator(color: AppColors.primary)),
      errorWidget: (_, __, ___) => Container(
          color: AppColors.greyLight,
          child: const Icon(Icons.pets, size: 80, color: AppColors.grey)),
    );
  }

  Widget _infoTile(
      {required IconData icon,
      required String title,
      required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.greyBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                        fontSize: 14)),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: _openWebsite,
            icon: const Icon(Icons.web, size: 20),
            label: const Text('Kunjungi Website ReRe Petshop',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.error_outline, size: 64, color: AppColors.grey),
        const SizedBox(height: 12),
        Text(_error ?? 'Terjadi kesalahan', textAlign: TextAlign.center),
        const SizedBox(height: 16),
        ElevatedButton(onPressed: _loadProduct, child: const Text('Coba Lagi')),
      ]),
    );
  }
}
