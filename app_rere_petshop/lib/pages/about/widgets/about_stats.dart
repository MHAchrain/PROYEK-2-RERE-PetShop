import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/about/about_data.dart';
import 'package:flutter/material.dart';

class AboutStats extends StatelessWidget {
  const AboutStats({super.key});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 22, 16, 0),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 620),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: aboutStats.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.15,
              ),
              itemBuilder: (context, index) {
                final stat = aboutStats[index];
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(stat.icon, color: AppColors.white.withOpacity(0.9), size: 25),
                      const SizedBox(height: 10),
                      Text(stat.value, textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.white,
                              fontSize: 27, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 3),
                      Text(stat.label, textAlign: TextAlign.center, maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white70, fontSize: 12)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );
}
