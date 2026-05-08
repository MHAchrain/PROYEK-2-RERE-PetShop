// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/app_colors.dart';
import '../../providers/product_provider.dart';
import '../../widgets/product_card.dart';
import '../product/product_detail_screen.dart';
import '../catalog/catalog_screen.dart';
import '../grooming/grooming_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Equipment', 'icon': Icons.build_outlined},
    {'name': 'Toys', 'icon': Icons.toys_outlined},
    {'name': 'Medicine', 'icon': Icons.medication_outlined},
    {'name': 'Food', 'icon': Icons.restaurant_outlined},
    {'name': 'Grooming', 'icon': Icons.content_cut_outlined},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().fetchHomeData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => context.read<ProductProvider>().fetchHomeData(),
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(child: _buildBanner()),
            SliverToBoxAdapter(child: _buildCategories()),
            SliverToBoxAdapter(child: _buildFeaturedSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }

  // ─── APP BAR ─────────────────────────────────────────────

  Widget _buildAppBar() {
    return SliverAppBar(
      floating: true,
      backgroundColor: AppColors.white,
      elevation: 1,
      titleSpacing: 16,
      title: Image.asset(
        'assets/images/logo-rere.png',
        height: 40,
        fit: BoxFit.contain,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined,
              color: AppColors.textPrimary),
          onPressed: () {},
        ),
      ],
    );
  }

  // ─── BANNER ───────────────────────────────────────────────

  Widget _buildBanner() {
    return Column(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: 200,
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
      margin: const EdgeInsets.symmetric(vertical: 8),
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
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white54),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    banner['tag']!,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 11,
                      letterSpacing: 1,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  banner['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  banner['subtitle']!,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
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

  // ─── CATEGORIES ───────────────────────────────────────────

  Widget _buildCategories() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(
            height: 90,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, i) {
                final cat = _categories[i];
                return GestureDetector(
                  onTap: () {
                    // 🔥 CEK: Kalau Grooming → ke halaman Grooming
                    if (cat['name'] == 'Grooming') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GroomingScreen(),
                        ),
                      );
                    } else {
                      // Kategori lain → ke Catalog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CatalogScreen(
                            initialCategory: cat['name'] as String,
                          ),
                        ),
                      );
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.06),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          cat['icon'] as IconData,
                          color: AppColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat['name'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // ─── FEATURED PRODUCTS ────────────────────────────────────

  Widget _buildFeaturedSection() {
    return Consumer<ProductProvider>(
      builder: (context, provider, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 18,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Rekomendasi Produk',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Padding(
                        padding: EdgeInsets.only(left: 12),
                        child: Text(
                          'Pilihan terbaik untuk anabul kamu',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CatalogScreen(),
                        ),
                      );
                    },
                    child: const Text(
                      'Lihat Semua',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Product grid
              if (provider.isLoading)
                _buildShimmerGrid()
              else if (provider.error != null)
                _buildError(provider)
              else if (provider.featuredProducts.isEmpty)
                _buildEmpty()
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: provider.featuredProducts.length,
                  itemBuilder: (context, i) {
                    final product = provider.featuredProducts[i];
                    return ProductCard(
                      product: product,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailScreen(productId: product.id),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: 6,
      itemBuilder: (_, __) => Container(
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildError(ProductProvider provider) {
    return Center(
      child: Column(
        children: [
          const Icon(Icons.wifi_off, size: 48, color: AppColors.grey),
          const SizedBox(height: 8),
          Text(provider.error!, style: const TextStyle(color: AppColors.grey)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => provider.fetchHomeData(),
            child: const Text('Coba Lagi'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(
      child: Column(
        children: [
          Icon(Icons.pets, size: 48, color: AppColors.grey),
          SizedBox(height: 8),
          Text('Belum ada produk', style: TextStyle(color: AppColors.grey)),
        ],
      ),
    );
  }
}
