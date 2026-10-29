import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AboutStory extends StatelessWidget {
  const AboutStory({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.divider),
          ),
          child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Kenapa kami memulainya',
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            SizedBox(height: 12),
            Text(
              'Berawal dari kecintaan kami terhadap hewan peliharaan, kami menyadari bahwa menemukan produk dan layanan terbaik untuk mereka tidak selalu mudah. Banyak pemilik hewan harus mencari ke berbagai tempat hanya untuk memastikan kebutuhan si kesayangan terpenuhi.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.6),
            ),
            SizedBox(height: 12),
            Text(
              'Dari situlah platform ini lahir, untuk menghadirkan kemudahan dalam satu genggaman. Kami menghubungkan para pecinta hewan dengan petshop terpercaya di sekitar mereka, menyediakan akses ke makanan berkualitas, vitamin, perlengkapan, hingga layanan grooming profesional.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.6),
            ),
            SizedBox(height: 12),
            Text(
              'Karena bagi kami, hewan peliharaan bukan sekadar teman. Mereka adalah keluarga yang pantas mendapatkan perhatian dan kasih sayang terbaik setiap hari.',
              style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.6),
            ),
          ]),
        ),
      );
}
