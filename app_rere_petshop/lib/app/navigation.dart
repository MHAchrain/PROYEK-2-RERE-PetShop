// lib/app/navigation.dart
import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/catalog/catalog_page.dart';
import 'package:app_rere_petshop/pages/home/home_page.dart';
import 'package:app_rere_petshop/pages/pesanan/pesanan_page.dart';
import 'package:app_rere_petshop/pages/arpet/arpet_page.dart';
import 'package:app_rere_petshop/pages/profil/profil_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final _pesananKey = GlobalKey<PesananPageState>();

  late final List<Widget> _screens = [
    const HomePage(),
    const CatalogPage(showBackButton: false),
    const ArpetPage(),
    PesananPage(key: _pesananKey),
    const ProfilPage(),
  ];

  void _onTabTapped(int index) {
    if (_currentIndex == index) {
      if (index == 3) {
        _pesananKey.currentState?.refresh();
      }
      return;
    }

    setState(() {
      _currentIndex = index;
    });

    if (index == 3) {
      _pesananKey.currentState?.refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;
    
    return Scaffold(
      backgroundColor: AppColors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 16,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        padding: EdgeInsets.only(bottom: bottomPadding > 0 ? bottomPadding : 6, top: 6),
        child: Row(
          children: [
            _buildNavItem(0, Icons.home_outlined, Icons.home_rounded, 'Beranda'),
            _buildNavItem(1, Icons.grid_view_outlined, Icons.grid_view_rounded,
                'Katalog'),
            _buildArpetNavItem(2),
            _buildNavItem(3, Icons.assignment_outlined,
                Icons.assignment_rounded, 'Pesanan'),
            _buildNavItem(4, Icons.person_outline_rounded,
                Icons.person_rounded, 'Profil'),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, IconData activeIcon, String label) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onTabTapped(index),
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.primary.withValues(alpha: 0.12),
          highlightColor: AppColors.primary.withValues(alpha: 0.06),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withValues(alpha: 0.10) : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    size: 24,
                    color: isSelected ? AppColors.primary : AppColors.grey,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                    color: isSelected ? AppColors.primary : AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildArpetNavItem(int index) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onTabTapped(index),
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.primary.withValues(alpha: 0.15),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  width: 44,
                  height: 34,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.auto_awesome_rounded,
                      size: 20,
                      color: isSelected ? Colors.white : AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'ARPET',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.primary : AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

