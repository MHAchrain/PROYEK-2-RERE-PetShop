// lib/presentation/screens/about/about_screen.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
            _buildHero(),

            // Kenapa kami memulainya
            _buildWhySection(),

            // Stats
            _buildStats(),

            // Values
            _buildValues(),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildHero() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      color: AppColors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kami membangun pengalaman belanja pet shop yang terasa hangat, mudah dipahami, dan membantu pemilik hewan menemukan kebutuhan terbaik dalam satu tempat.',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          // Logo besar
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Center(
                child: Text(
                  'ReRe',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'ReRe Petshop',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          const Center(
            child: Text(
              'Untuk Anabul Kesayangan Kamu 🐾',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWhySection() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kenapa kami memulainya',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
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
            child: const Column(
              children: [
                Text(
                  'Berawal dari kecintaan kami terhadap hewan peliharaan, kami menyadari bahwa menemukan produk dan layanan terbaik untuk mereka tidak selalu mudah. Banyak pemilik hewan harus mencari ke berbagai tempat hanya untuk memastikan kebutuhan si kesayangan terpenuhi.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Dari situlah platform ini lahir, untuk menghadirkan kemudahan dalam satu genggaman. Kami menyediakan akses ke makanan berkualitas, vitamin, perlengkapan, hingga layanan grooming profesional.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Karena bagi kami, hewan peliharaan bukan sekadar teman. Mereka adalah keluarga yang pantas mendapatkan perhatian dan kasih sayang terbaik setiap hari.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStats() {
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

  Widget _buildValues() {
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
