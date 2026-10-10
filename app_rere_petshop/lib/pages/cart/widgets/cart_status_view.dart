import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CartStatusView extends StatelessWidget {
  const CartStatusView.loading({super.key})
      : isLoading = true,
        message = null,
        onRetry = null;

  const CartStatusView.message(this.message, {super.key})
      : isLoading = false,
        onRetry = null;

  const CartStatusView.error(this.message, {required this.onRetry, super.key})
      : isLoading = false;

  final bool isLoading;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: onRetry == null
            ? Text(message ?? '', textAlign: TextAlign.center)
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(message ?? '', textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: onRetry,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
      ),
    );
  }
}
