import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/models/product_model.dart';

class ProductHeroImage extends StatelessWidget {
  const ProductHeroImage({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context) {
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
}
