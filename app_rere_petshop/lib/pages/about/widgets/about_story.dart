import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';

class AboutStory extends StatelessWidget {
  const AboutStory({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kenapa kami memulainya',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Column(
              children: [
                Text(
                  'Berawal dari kecintaan kami terhadap hewan peliharaan, kami menyadari bahwa menemukan produk dan layanan terbaik untuk mereka tidak selalu mudah. Banyak pemilik hewan harus mencari ke berbagai tempat hanya untuk memastikan kebutuhan si kesayangan terpenuhi.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Dari situlah platform ini lahir, untuk menghadirkan kemudahan dalam satu genggaman. Kami menyediakan akses ke makanan berkualitas, vitamin, perlengkapan, hingga layanan grooming profesional.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Karena bagi kami, hewan peliharaan bukan sekadar teman. Mereka adalah keluarga yang pantas mendapatkan perhatian dan kasih sayang terbaik setiap hari.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
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
