import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';

class HomeBanner extends StatefulWidget {
  const HomeBanner({super.key});

  @override
  State<HomeBanner> createState() => _HomeBannerState();
}

class _HomeBannerState extends State<HomeBanner> {
  int _currentBanner = 0;
  final List<Map<String, String>> _banners = [
    {
      'title': 'Semua Kebutuhan Hewan\nPeliharaan Ada di Sini!',
      'subtitle':
          'Temukan makanan, aksesoris, dan layanan terbaik untuk anabul.',
      'tag': 'PROMO PILIHAN',
    },
    {
      'title': 'Flash Sale!\nDiskon Hingga 50%',
      'subtitle': 'Dapatkan produk pilihan dengan harga spesial hari ini.',
      'tag': 'FLASH SALE',
    },
    {
      'title': 'Grooming\nTersedia di ReRe!',
      'subtitle': 'Layanan grooming profesional untuk anabul kesayangan kamu.',
      'tag': 'LAYANAN',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return _buildBanner();
  }

  Widget _buildBanner() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 205,
            viewportFraction: 0.92,
            enlargeCenterPage: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, _) => setState(() => _currentBanner = index),
          ),
          items: _banners.map((banner) => _bannerItem(banner)).toList(),
        ),
        const SizedBox(height: 10),
        // Dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _banners.asMap().entries.map((entry) {
            return Container(
              width: _currentBanner == entry.key ? 24 : 8,
              height: 8,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: _currentBanner == entry.key
                    ? AppColors.primary
                    : AppColors.greyLight,
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _bannerItem(Map<String, String> banner) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4A4A4A), Color(0xFF2A2A2A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Background paw icon (decorative)
          Positioned(
            right: -20,
            bottom: -20,
            child: Icon(
              Icons.pets,
              size: 150,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white54),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    banner['tag']!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10.5,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  banner['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    height: 1.25,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  banner['subtitle']!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 11.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
