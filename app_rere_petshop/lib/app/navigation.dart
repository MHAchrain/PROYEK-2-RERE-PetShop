// lib/app/navigation.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/auth/login_page.dart';
import 'package:app_rere_petshop/pages/cart/cart_page.dart';
import 'package:app_rere_petshop/providers/cart_provider.dart';
import 'package:app_rere_petshop/providers/auth_provider.dart';
import 'package:app_rere_petshop/services/auth_service.dart';
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
  bool _cartHasBeenOpened = false;
  final AuthService _auth = AuthService();

  List<Widget> get _screens => [
    const HomePage(),
    const PesananPage(),
    const ArpetPage(),
    _cartHasBeenOpened ? const CartPage() : const SizedBox.shrink(),
    const ProfilPage(),
  ];

  Future<void> _onTabTapped(int index) async {
    if (index == 1 || index == 3) {
      if (!await _auth.hasAuthToken()) {
        if (!mounted) return;
        final loggedIn = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
        if (!mounted || loggedIn != true) return;
      }
      if (mounted) {
        await Future.wait([
          context.read<AuthProvider>().refreshProfile(),
          context.read<CartProvider>().refreshCount(),
        ]);
      }
    }
    if (mounted) {
      setState(() {
        if (index == 3) _cartHasBeenOpened = true;
        _currentIndex = index;
      });
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
            _buildNavItem(1, Icons.assignment_outlined, Icons.assignment_rounded, 'Pesanan'),
            _buildArpetNavItem(2),
            _buildCartNavItem(3),
            _buildNavItem(4, Icons.person_outline_rounded, Icons.person_rounded, 'Profil'),
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

  Widget _buildCartNavItem(int index) {
    final isSelected = _currentIndex == index;
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _onTabTapped(index),
          borderRadius: BorderRadius.circular(16),
          splashColor: AppColors.primary.withValues(alpha: 0.12),
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
                  child: Consumer<CartProvider>(
                    builder: (context, cart, _) => Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Icon(
                          isSelected ? Icons.shopping_cart_rounded : Icons.shopping_cart_outlined,
                          size: 24,
                          color: isSelected ? AppColors.primary : AppColors.grey,
                        ),
                        if (cart.itemCount > 0)
                          Positioned(
                            right: -8,
                            top: -4,
                            child: Container(
                              padding: const EdgeInsets.all(3),
                              constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                cart.itemCount > 99 ? '99+' : '${cart.itemCount}',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Keranjang',
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
}
