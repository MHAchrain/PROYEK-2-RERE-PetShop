import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/models/product_model.dart';
import 'package:app_rere_petshop/services/api_service.dart';
import 'package:app_rere_petshop/pages/cart/cart_page.dart';
import 'package:app_rere_petshop/pages/auth/login_page.dart';
import 'package:app_rere_petshop/services/auth_service.dart';
import 'package:app_rere_petshop/constants/app_constants.dart';
import 'package:app_rere_petshop/pages/product/widgets/product_action_bar.dart';
import 'package:app_rere_petshop/pages/product/widgets/product_detail_content.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailPage extends StatefulWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ApiService _apiService = ApiService();
  Product? _product;
  bool _isLoading = true;
  bool _isAddingToCart = false;
  bool _isBuyingNow = false;
  int _quantity = 1;
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

  Future<bool> _ensureSignedIn() async {
    if (await AuthService().hasAuthToken()) return true;
    if (!mounted) return false;
    return await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        ) ==
        true;
  }

  Future<void> _addToCart({bool buyNow = false}) async {
    final product = _product;
    if (product == null || !product.isInStock) return;
    if (!await _ensureSignedIn()) return;

    setState(() {
      if (buyNow) {
        _isBuyingNow = true;
      } else {
        _isAddingToCart = true;
      }
    });
    try {
      await _apiService.addToCart(product.id, quantity: _quantity);
      if (!mounted) return;
      if (buyNow) {
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CartPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Produk ditambahkan ke keranjang.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal menambahkan ke keranjang: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAddingToCart = false;
          _isBuyingNow = false;
        });
      }
    }
  }

  void _setQuantity(int quantity) {
    final stock = _product?.stock ?? 0;
    final maxQuantity = stock > 0 ? stock : 1;
    setState(() {
      _quantity = quantity.clamp(1, maxQuantity).toInt();
    });
  }

  Future<void> _chatAboutProduct() async {
    final product = _product;
    if (product == null) return;
    final text = Uri.encodeComponent(
      'Halo ReRe Petshop, saya ingin bertanya tentang ${product.name}.',
    );
    final uri = Uri.parse('https://wa.me/${AppConstants.whatsappNumber}?text=$text');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      bottomNavigationBar: _product != null
          ? ProductActionBar(
              isInStock: _product!.isInStock,
              isAddingToCart: _isAddingToCart,
              isBuyingNow: _isBuyingNow,
              onChat: _chatAboutProduct,
              onAddToCart: () => _addToCart(),
              onBuyNow: () => _addToCart(buyNow: true),
            )
          : null,
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary))
          : _error != null
              ? _buildError()
              : ProductDetailContent(
                  product: _product!,
                  quantity: _quantity,
                  onQuantityChanged: _setQuantity,
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
