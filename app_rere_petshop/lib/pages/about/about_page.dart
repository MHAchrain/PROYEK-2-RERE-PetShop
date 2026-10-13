// lib/presentation/screens/about/about_screen.dart
import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/about/widgets/about_hero.dart';
import 'package:app_rere_petshop/pages/about/widgets/about_story.dart';
import 'package:app_rere_petshop/pages/about/widgets/about_stats.dart';
import 'package:app_rere_petshop/pages/about/widgets/about_values.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'TENTANG RERE PETSHOP',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.primary,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              'Cerita Kami',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
            const AboutHero(),

            // Kenapa kami memulainya
            const AboutStory(),

            // Stats
            const AboutStats(),

            // Values
            const AboutValues(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
