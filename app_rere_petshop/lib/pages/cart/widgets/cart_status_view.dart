import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CartStatusView extends StatelessWidget {
  const CartStatusView.loading({super.key})
      : isLoading = true,
        message = null,
        onRetry = null,
        actionButton = null;

  const CartStatusView.message(this.message, {super.key})
      : isLoading = false,
        onRetry = null,
        actionButton = null;

  const CartStatusView.error(
    this.message, {
    required this.onRetry,
    this.actionButton,
    super.key,
  }) : isLoading = false;

  final bool isLoading;
  final String? message;
  final VoidCallback? onRetry;
  final Widget? actionButton;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    if (onRetry == null && actionButton == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.shopping_cart_outlined, size: 56, color: AppColors.grey),
              const SizedBox(height: 12),
              Text(
                message ?? 'Keranjang belanja kamu kosong.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w500, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.info_outline_rounded, size: 48, color: AppColors.grey),
            const SizedBox(height: 12),
            Text(
              message ?? '',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            if (actionButton != null)
              actionButton!
            else if (onRetry != null)
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
