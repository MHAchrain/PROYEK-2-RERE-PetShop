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
      'tag': 'PROMO SPESIAL',
      'asset': 'assets/images/banner-promo-merchandise.png',
    },
    {
      'tag': 'DISKON 30%',
      'asset': 'assets/images/banner-diskon-30.png',
    },
    {
      'tag': 'GROOMING',
      'asset': 'assets/images/banner-promo-grooming.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return _buildBanner();
  }

  Widget _buildBanner() {
    return Column(
      children: [
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: CarouselSlider(
              options: CarouselOptions(
                // Semua banner sekarang berupa gambar 1664x640 (rasio 2.6:1),
                // jadi aspectRatio disamakan supaya tidak terpotong.
                aspectRatio: 2.6,
                viewportFraction: 0.92,
                enlargeCenterPage: true,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 4),
                onPageChanged: (index, _) =>
                    setState(() => _currentBanner = index),
              ),
              items: _banners.map((banner) => _bannerItem(banner)).toList(),
            ),
          ),
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
    // Banner berbasis gambar (mis. promo grooming)
    final asset = banner['asset'];
    if (asset != null && asset.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Semantics(
                label: banner['tag'] ?? 'Banner promo',
                image: true,
                child: Image.asset(
                  asset,
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                  errorBuilder: (_, __, ___) => Container(
                    color: AppColors.greyLight,
                    child: const Center(
                      child: Icon(Icons.image_not_supported_outlined,
                          size: 40, color: AppColors.grey),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

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
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  // FittedBox(scaleDown) membuat teks mengecil otomatis
                  // kalau layar sempit / font sistem diperbesar,
                  // jadi tidak ada RenderFlex overflow.
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: SizedBox(
                        width: constraints.maxWidth,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 9, vertical: 3),
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
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
