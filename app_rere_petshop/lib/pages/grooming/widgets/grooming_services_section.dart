import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';

class GroomingServicesSection extends StatelessWidget {
  const GroomingServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final services = [
      {
        'title': 'Grooming Basic',
        'desc': 'Mandi dan perawatan dasar untuk hewan peliharaan Anda.',
        'duration': '60 menit',
        'price': 'Rp150.000',
      },
      {
        'title': 'Grooming Medium',
        'desc': 'Mandi, perawatan, dan pemotongan bulu untuk hewan peliharaan Anda.',
        'duration': '60 menit',
        'price': 'Rp250.000',
      },
      {
        'title': 'Grooming Premium',
        'desc': 'Perawatan lengkap termasuk mandi, pemotongan bulu, dan perawatan tambahan untuk hewan peliharaan Anda.',
        'duration': '90 menit',
        'price': 'Rp350.000',
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Layanan grooming',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: MediaQuery.sizeOf(context).width >= 600 ? 2 : 1,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: 235,
            ),
            itemCount: services.length,
            itemBuilder: (context, i) {
              final service = services[i];
              return Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      service['title'] as String,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      service['desc'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.45,
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const Icon(Icons.schedule, size: 16, color: AppColors.primary),
                        const SizedBox(width: 6),
                        Text('Durasi sekitar ${service['duration']}'),
                      ],
                    ),
                    const SizedBox(height: 5),
                    const Row(
                      children: [
                        Icon(Icons.pets, size: 16, color: AppColors.primary),
                        SizedBox(width: 6),
                        Text('Satu hewan untuk satu slot'),
                      ],
                    ),
                    const Divider(height: 18),
                    Text(
                      service['price'] as String,
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
