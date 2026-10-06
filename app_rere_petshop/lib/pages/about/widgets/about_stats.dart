import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';

class AboutStats extends StatelessWidget {
  const AboutStats({super.key});

  @override
  Widget build(BuildContext context) {
    final stats = [
      {'value': '100+', 'label': 'Produk'},
      {'value': '5', 'label': 'Kategori'},
      {'value': '500+', 'label': 'Pelanggan'},
      {'value': '4.8★', 'label': 'Rating'},
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      color: AppColors.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: stats
            .map(
              (s) => Column(
                children: [
                  Text(
                    s['value']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    s['label']!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}
