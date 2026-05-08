// lib/presentation/screens/product/product_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/product_model.dart';
import '../../../data/services/api_service.dart';

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

  Future<void> _openWhatsApp() async {
    final message = Uri.encodeComponent(
      'Halo, saya tertarik dengan produk "${_product?.name}" seharga ${_product?.formattedPrice}. Apakah masih tersedia?',
    );
    final url =
        Uri.parse('https://wa.me/${AppConstants.whatsappNumber}?text=$message');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
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
                  Text(product.name,
                      style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: product.isInStock
                          ? AppColors.success.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      product.isInStock ? 'In Stock' : 'Out of Stock',
                      style: TextStyle(
                          color: product.isInStock
                              ? AppColors.success
                              : Colors.red,
                          fontWeight: FontWeight.w600,
                          fontSize: 13),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(product.formattedPrice,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary)),
                  const SizedBox(height: 16),
                  if (product.description != null &&
                      product.description!.isNotEmpty) ...[
                    const Divider(),
                    const SizedBox(height: 12),
                    Text(product.description!,
                        style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.6)),
                    const SizedBox(height: 16),
                  ],
                  const Divider(),
                  const SizedBox(height: 12),
                  _infoTile(
                      icon: Icons.local_shipping_outlined,
                      title: 'Free Shipping',
                      subtitle: 'Free delivery over Rp 200.000'),
                  const SizedBox(height: 8),
                  _infoTile(
                      icon: Icons.replay_outlined,
                      title: 'Easy Returns',
                      subtitle: '30-day return policy'),
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
        border: Border.all(color: AppColors.greyLight),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(children: [
        Icon(icon, color: AppColors.primary, size: 28),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
          Text(subtitle,
              style: const TextStyle(
                  fontSize: 12, color: AppColors.textSecondary)),
        ]),
      ]),
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
          height: 48,
          child: ElevatedButton.icon(
            onPressed: _openWhatsApp,
            icon: const Icon(Icons.chat_outlined),
            label: const Text('Hubungi via WhatsApp',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
