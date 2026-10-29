import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/about/about_data.dart';
import 'package:flutter/material.dart';

class AboutValues extends StatelessWidget {
  const AboutValues({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Nilai dan Keunggulan Kami',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          for (final benefit in aboutBenefits) ...[
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Icon(benefit.icon, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(benefit.title, style: const TextStyle(fontSize: 13,
                      fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                  const SizedBox(height: 4),
                  Text(benefit.description, style: const TextStyle(fontSize: 12,
                      height: 1.45, color: AppColors.textSecondary)),
                ])),
              ]),
            ),
          ],
        ]),
      );
}
