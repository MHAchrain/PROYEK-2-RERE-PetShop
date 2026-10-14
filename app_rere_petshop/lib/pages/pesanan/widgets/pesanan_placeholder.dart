import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';

class PesananPlaceholder extends StatelessWidget {
  const PesananPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.receipt_long_outlined, size: 56, color: AppColors.primary),
            SizedBox(height: 12),
            Text('Halaman pesanan sedang disiapkan.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
