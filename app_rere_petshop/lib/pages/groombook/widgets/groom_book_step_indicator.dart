import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';

class GroomBookStepIndicator extends StatelessWidget {
  const GroomBookStepIndicator({
    super.key,
    required this.step,
    this.totalSteps = 2,
  });

  final int step;
  final int totalSteps;

  @override
  Widget build(BuildContext context) => Container(
        color: AppColors.white,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'LANGKAH ${step + 1} DARI $totalSteps',
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: .4,
                  ),
                ),
                Text(
                  step == 0
                      ? 'Data & Layanan'
                      : step == 1
                          ? 'Jadwal & Ringkasan'
                          : 'Konfirmasi Akhir',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: (step + 1) / totalSteps,
                minHeight: 5,
                backgroundColor: AppColors.greyLight,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      );
}
