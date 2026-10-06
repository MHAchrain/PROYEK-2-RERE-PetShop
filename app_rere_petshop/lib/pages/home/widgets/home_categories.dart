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
                return GestureDetector(
                  onTap: () {
                    // 🔥 CEK: Kalau Grooming → ke halaman Grooming
                    if (cat['name'] == 'Grooming') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const GroomingPage(),
                        ),
                      );
                    } else {
                      // Kategori lain → ke Catalog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CatalogPage(
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
}