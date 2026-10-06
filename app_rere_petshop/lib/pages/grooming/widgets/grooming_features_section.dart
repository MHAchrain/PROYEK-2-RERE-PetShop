import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';

class GroomingFeaturesSection extends StatelessWidget {
  const GroomingFeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final features = [
      {'icon': Icons.verified_user, 'text': 'Tenaga Berpengalaman'},
      {'icon': Icons.favorite, 'text': 'Produk Ramah Hewan'},
      {'icon': Icons.home, 'text': 'Home Service Tersedia'},
      {'icon': Icons.star, 'text': '100% Aman & Higienis'},
    ];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mengapa Memilih Kami?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Icon(
                      feature['icon'] as IconData,
                      color: AppColors.primary,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      feature['text'] as String,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
