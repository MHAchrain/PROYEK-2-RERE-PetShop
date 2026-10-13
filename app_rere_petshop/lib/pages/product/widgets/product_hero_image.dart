import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/models/product_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProductHeroImage extends StatelessWidget {
  const ProductHeroImage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
    final imageCount = product.image?.trim().isNotEmpty == true ? 1 : 0;
    final showSlideControls = imageCount > 1;

    return ColoredBox(
      color: AppColors.white,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 38),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: ColoredBox(
                color: const Color(0xFFF1EAE8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: _buildProductImage(),
                    ),
                    if (showSlideControls) ...[
                      const Positioned(
                        left: 12,
                        child: _CarouselArrow(
                          icon: Icons.chevron_left,
                          onPressed: null,
                        ),
                      ),
                      const Positioned(
                        right: 12,
                        child: _CarouselArrow(
                          icon: Icons.chevron_right,
                          onPressed: null,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (showSlideControls)
            Positioned(
              bottom: 13,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 20,
                    height: 6,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(width: 6),
                  ...List.generate(
                    imageCount - 1,
                    (_) => Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFFD4D4D4),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildProductImage() {
    if (product.image == null || product.image!.isEmpty) {
      return const _ProductImagePlaceholder();
    }

    return CachedNetworkImage(
      imageUrl: product.image!,
      fit: BoxFit.contain,
      placeholder: (_, __) => const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      ),
      errorWidget: (_, __, ___) => const _ProductImagePlaceholder(),
    );
  }
}

class _CarouselArrow extends StatelessWidget {
  const _CarouselArrow({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 38,
      height: 38,
      child: IconButton(
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.textPrimary,
          disabledBackgroundColor: AppColors.white,
          disabledForegroundColor: AppColors.textPrimary,
          shape: const CircleBorder(),
        ),
        icon: Icon(icon, size: 22),
      ),
    );
  }
}

class _ProductImagePlaceholder extends StatelessWidget {
  const _ProductImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Icon(Icons.pets, size: 72, color: AppColors.grey),
    );
  }
}
