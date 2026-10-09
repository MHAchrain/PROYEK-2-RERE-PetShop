import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';

class ProfilPlaceholder extends StatelessWidget {
  const ProfilPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_outline, size: 56, color: AppColors.primary),
            SizedBox(height: 12),
            Text('Halaman profil sedang disiapkan.', textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
