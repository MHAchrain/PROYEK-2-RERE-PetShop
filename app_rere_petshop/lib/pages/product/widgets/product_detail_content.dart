import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/models/product_model.dart';
import 'package:app_rere_petshop/pages/product/widgets/product_hero_image.dart';
import 'package:flutter/material.dart';

class ProductDetailContent extends StatelessWidget {
  const ProductDetailContent({
    super.key,
    required this.product,
    required this.quantity,
    required this.onQuantityChanged,
  });

  final Product product;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    final hasDescription =
        product.description != null && product.description!.trim().isNotEmpty;

    return Stack(
      fit: StackFit.expand,
      children: [
        CustomScrollView(
          slivers: [
        SliverSafeArea(
          top: false,
          bottom: false,
          sliver: SliverToBoxAdapter(
            child: SizedBox(
              height: 320,
              child: ProductHeroImage(product: product),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Container(
            color: AppColors.white,
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.formattedPrice,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  product.name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 10),
                _buildStockRow(),
                const SizedBox(height: 18),
                _buildQuantitySelector(),
                const SizedBox(height: 20),
                const Divider(height: 1),
                const SizedBox(height: 16),
                const Text(
                  'Deskripsi Produk',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  hasDescription
                      ? product.description!.trim()
                      : 'Belum ada deskripsi untuk produk ini.',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 18),
                const _ArpetSuggestionCard(),
                const SizedBox(height: 88),
              ],
            ),
          ),
        ),
          ],
        ),
        Positioned(
          top: MediaQuery.paddingOf(context).top + 8,
          left: 16,
          child: Material(
            color: AppColors.white,
            shape: const CircleBorder(),
            elevation: 1,
            child: IconButton(
              tooltip: 'Kembali',
              onPressed: () => Navigator.maybePop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStockRow() {
    final inStock = product.isInStock;
    final color = inStock ? AppColors.success : Colors.red;
    final stockText = inStock
        ? 'Stok tersedia: ${product.stock} pcs'
        : 'Stok habis';

    return Row(
      children: [
        Icon(Icons.circle, color: color, size: 9),
        const SizedBox(width: 7),
        Text(
          stockText,
          style: TextStyle(
            color: inStock ? AppColors.textSecondary : color,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuantitySelector() {
    final maxQuantity = product.stock != null && product.stock! > 0
        ? product.stock!
        : 1;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        border: Border.all(color: const Color(0xFFF0F0F0)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Jumlah Pembelian:',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.white,
              border: Border.all(color: AppColors.greyLight),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _QuantityButton(
                  icon: Icons.remove,
                  onPressed: quantity > 1
                      ? () => onQuantityChanged(quantity - 1)
                      : null,
                ),
                SizedBox(
                  width: 34,
                  child: Text(
                    '$quantity',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                _QuantityButton(
                  icon: Icons.add,
                  onPressed: product.isInStock && quantity < maxQuantity
                      ? () => onQuantityChanged(quantity + 1)
                      : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityButton extends StatelessWidget {
  const _QuantityButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      visualDensity: VisualDensity.compact,
      iconSize: 17,
      color: AppColors.primary,
      disabledColor: AppColors.grey,
      icon: Icon(icon),
    );
  }
}

class _ArpetSuggestionCard extends StatelessWidget {
  const _ArpetSuggestionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5),
        border: Border.all(color: const Color(0xFFF5DDDD)),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.pets,
              color: AppColors.white,
              size: 19,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Saran dari ARPET',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    SizedBox(width: 6),
                  ],
                ),
                SizedBox(height: 6),
                Text(
                  'Sesuaikan produk dengan usia dan kebutuhan anabul. Perkenalkan produk baru secara bertahap, lalu perhatikan kenyamanan dan reaksinya.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
