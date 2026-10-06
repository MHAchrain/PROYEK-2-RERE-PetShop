import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';

class GroomingHeroSection extends StatelessWidget {
  const GroomingHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'LAYANAN GROOMING',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Berikan Perawatan Terbaik\nuntuk Anabul Anda',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Layanan grooming profesional kami dirancang untuk memastikan hewan peliharaan Anda tetap bersih, sehat, dan tampil menggemaskan. Kami menggunakan produk ramah hewan dan ditangani oleh tenaga berpengalaman.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
