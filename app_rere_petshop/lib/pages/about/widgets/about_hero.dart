import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:flutter/material.dart';

class AboutHero extends StatelessWidget {
  const AboutHero({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('TENTANG RERE PETSHOP',
              style: TextStyle(color: AppColors.primary, fontSize: 11,
                  letterSpacing: 1, fontWeight: FontWeight.w700)),
          const SizedBox(height: 5),
          const Text('Cerita Kami',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 8),
          const Text(
            'Kami membangun pengalaman belanja pet shop yang terasa hangat, mudah dipahami, dan membantu pemilik hewan menemukan kebutuhan terbaik dalam satu tempat.',
            style: TextStyle(fontSize: 13, color: AppColors.textSecondary, height: 1.55),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'assets/images/about-story.png',
              width: double.infinity,
              height: 210,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                height: 180,
                color: AppColors.primary.withOpacity(0.08),
                child: const Center(child: Icon(Icons.pets, size: 48, color: AppColors.primary)),
              ),
            ),
          ),
          const SizedBox(height: 10),
          const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.pets, color: AppColors.primary, size: 18),
            SizedBox(width: 7),
            Text('ReRe Petshop', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
          ]),
        ]),
      );
}
