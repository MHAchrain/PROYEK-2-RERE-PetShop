import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import 'package:app_rere_petshop/app/navigation.dart';

class OnboardingData {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String? localFallback;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.localFallback,
  });
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _screens = [
    OnboardingData(
      title: 'Semua Kebutuhan dalam Satu Tempat',
      subtitle:
          'Temukan berbagai produk berkualitas pilihan mulai dari makanan bernutrisi, vitamin resmi, hingga perlengkapan terbaik untuk menjaga kesehatan dan kebahagiaan hewan kesayanganmu setiap hari.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDI2trZvTJG-pwwIZrP3oGRHBpBpflDRygElDpf5bwMm9dfV2OmgkFUUtE3h0OGzBUqdQ9gfDXrS7wNoHt3c_8zxgCFOFWgAIbHYmEwqExMXKAkJE9h2ap2h0k86iQcR0dSGRrcHo98sbkMza9Q9Z5aWBOZYw23dGwRP5Emq92ol9Cr2b2fOpGZiFK4EDHBfPhXyj4AHkAp6PPrFv9-1pVNZIzPv6nAq4_nCYsMXiQ',
      localFallback: 'assets/images/about-story.png',
    ),
    OnboardingData(
      title: 'Belanja Jadi Lebih Mudah',
      subtitle:
          'Nikmati kemudahan menemukan dan memesan berbagai produk kebutuhan kucing kesayanganmu langsung dari rumah melalui ReRe Petshop.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDKI32AJL06SdcBI5tU_AvFGgmEjscOG3wKn3KO2HmYVu2c3997z_8Z8fN5eKSoUl4c7nNzWQL7ErKBZStBPrSItPIOPlmHgoemD13-bEwQYA_F3URg1K3Al_I03ORB2_nweslDYmaXS7RwwbWxhAiWeX-6HOWJ4gdiPcs0NesJk2DwuIReh7PC5c1ct1nyq_eAMSK-88M6Qsp6qZEKtBZEDbsmO5zALxIFYOxlhXTnAmiOaRwJOkA7qFkhehYFIp81w8zf9wHoWrEfNA',
      localFallback: null,
    ),
    OnboardingData(
      title: 'Perawatan untuk Kucing Kesayangan',
      subtitle:
          'Nikmati kemudahan layanan grooming profesional untuk merawat kebersihan, kesehatan bulu, dan kenyamanan kucing kesayanganmu dengan sentuhan penuh kasih sayang setiap saat.',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCduelrR1rCfLU0a68Eeecth3DuastB3c4DJNQ07-adWWulSmhrG5vHWCjKpxhTcedmcQyw5TeQr3f2QhusEEWMCNQyo3OzvAgklBy8oibnYZgOdPs6kzsTqMShhqp2oj8_B3L932YFqz3nhvhMQ3rm4H2kdd4K-Id-VMqCwk51Nca-FI7dNGn-8UtfbbyYVpSmo0COJxMcpCwtwSQC6hy53caGhpvDtlLm2wcT6Mc',
      localFallback: 'assets/images/catbat-grooming.jpg',
    ),
  ];

  Future<void> _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_onboarding', true);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainNavigation()),
    );
  }

  void _nextPage() {
    if (_currentPage < _screens.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_currentPage < _screens.length - 1)
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: TextButton(
                onPressed: _finishOnboarding,
                child: const Text(
                  'Lewati',
                  style: TextStyle(
                    color: Color(0xFF777777),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // PageView Slider dengan Responsive Layout & Anti-Overflow
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _screens.length,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  final item = _screens[index];

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final availableHeight = constraints.maxHeight;
                      // Ukuran gambar fleksibel mengikuti tinggi layar (30% - 40% tinggi layar)
                      final imageHeight = (availableHeight * 0.38).clamp(160.0, 260.0);
                      final isCompactScreen = availableHeight < 550;

                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: availableHeight),
                          child: IntrinsicHeight(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Spacer(flex: 1),

                                // Responsive Image Box
                                Container(
                                  width: double.infinity,
                                  constraints: const BoxConstraints(maxWidth: 290),
                                  height: imageHeight,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFCECEC).withOpacity(0.5),
                                    borderRadius: BorderRadius.circular(28),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF850909).withOpacity(0.06),
                                        blurRadius: 18,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(28),
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        // Ambient decorative spots
                                        Positioned(
                                          top: -15,
                                          right: -15,
                                          child: Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0xFFFE7262).withOpacity(0.2),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: -15,
                                          left: -15,
                                          child: Container(
                                            width: 90,
                                            height: 90,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: const Color(0xFFFFDAD5).withOpacity(0.35),
                                            ),
                                          ),
                                        ),
                                        // Main image
                                        CachedNetworkImage(
                                          imageUrl: item.imageUrl,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Shimmer.fromColors(
                                            baseColor: const Color(0xFFF0EDEC),
                                            highlightColor: Colors.white,
                                            child: Container(color: Colors.white),
                                          ),
                                          errorWidget: (context, url, error) {
                                            if (item.localFallback != null) {
                                              return Image.asset(
                                                item.localFallback!,
                                                fit: BoxFit.cover,
                                              );
                                            }
                                            return Center(
                                              child: Icon(
                                                Icons.pets_rounded,
                                                size: 54,
                                                color: const Color(0xFF850909).withOpacity(0.4),
                                              ),
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: isCompactScreen ? 18 : 26),

                                // Title (Auto responsive font size)
                                Text(
                                  item.title,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: isCompactScreen ? 20 : 23,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF111111),
                                    height: 1.25,
                                    letterSpacing: -0.4,
                                  ),
                                ),
                                SizedBox(height: isCompactScreen ? 8 : 12),

                                // Subtitle
                                Text(
                                  item.subtitle,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: isCompactScreen ? 12 : 13.5,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF777777),
                                    height: 1.5,
                                  ),
                                ),

                                const Spacer(flex: 2),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            // Indicator + Button Bottom Section
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _screens.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        height: 7,
                        width: _currentPage == index ? 28 : 7,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? const Color(0xFF850909)
                              : const Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF850909),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: const Color(0xFF850909).withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == _screens.length - 1
                                ? 'Mulai Sekarang'
                                : 'Selanjutnya',
                            style: const TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
