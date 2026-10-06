// lib/presentation/screens/home/home_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/providers/product_provider.dart';
import 'package:app_rere_petshop/pages/home/widgets/home_banner.dart';
import 'package:app_rere_petshop/pages/home/widgets/home_categories.dart';
import 'package:app_rere_petshop/pages/home/widgets/featured_products_section.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
            const SliverToBoxAdapter(child: HomeBanner()),
            const SliverToBoxAdapter(child: HomeCategories()),
            const SliverToBoxAdapter(child: FeaturedSection()),
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
}
