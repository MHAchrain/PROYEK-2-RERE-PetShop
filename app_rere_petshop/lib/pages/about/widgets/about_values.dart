import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';

class AboutValues extends StatelessWidget {
  const AboutValues({super.key});

  @override
  Widget build(BuildContext context) {
    final values = [
      {
        'icon': Icons.storefront_outlined,
        'title': 'Produk Berkualitas',
        'desc':
            'Kami hanya menjual produk terpercaya yang aman untuk hewan peliharaan.',
      },
      {
        'icon': Icons.delivery_dining_outlined,
        'title': 'Pengiriman Cepat',
        'desc': 'Pesanan dikirim dengan cepat dan aman ke seluruh wilayah.',
      },
      {
        'icon': Icons.support_agent_outlined,
        'title': 'Layanan Responsif',
        'desc': 'Tim kami siap membantu menjawab pertanyaan kamu kapan saja.',
      },
      {
        'icon': Icons.monetization_on_outlined,
        'title': 'Harga Terjangkau',
        'desc': 'Harga yang kompetitif tanpa mengorbankan kualitas produk.',
      },
    ];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nilai Kami',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: values
                .map(
                  (v) => Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            v['icon'] as IconData,
                            color: AppColors.primary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          v['title'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          v['desc'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                            height: 1.4,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
