import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';

class GroomingAppBar extends StatelessWidget {
  const GroomingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.textPrimary,
      elevation: 1,
      title: const Text(
        'Grooming',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
