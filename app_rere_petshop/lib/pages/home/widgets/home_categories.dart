import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/catalog/catalog_page.dart';
import 'package:app_rere_petshop/pages/grooming/grooming_page.dart';

class HomeCategories extends StatefulWidget {
  const HomeCategories({super.key});

  @override
  State<HomeCategories> createState() => _HomeCategoriesState();
}

class _HomeCategoriesState extends State<HomeCategories> {
  int? _selectedIndex;

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Equipment', 'icon': Icons.build_outlined},
    {'name': 'Toys', 'icon': Icons.toys_outlined},
    {'name': 'Medicine', 'icon': Icons.medication_outlined},
    {'name': 'Food', 'icon': Icons.restaurant_outlined},
    {'name': 'Grooming', 'icon': Icons.content_cut_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return _buildCategories();
  }

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
                final isSelected = _selectedIndex == i;
                return GestureDetector(
                  onTap: () async {
                    setState(() {
                      _selectedIndex = i;
                    });
                    // 🔥 CEK: Kalau Grooming → ke halaman Grooming
                    if (cat['name'] == 'Grooming') {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GroomingPage(),
                        ),
                      );
                    } else {
                      // Kategori lain → ke Catalog
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CatalogPage(
                            initialCategory: cat['name'] as String,
                          ),
                        ),
                      );
                    }

                    if (mounted) {
                      setState(() {
                        _selectedIndex = null;
                      });
                    }
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.white,
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
                          color: isSelected ? AppColors.white : AppColors.primary,
                          size: 28,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cat['name'] as String,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected ? AppColors.primary : AppColors.textSecondary,
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
}