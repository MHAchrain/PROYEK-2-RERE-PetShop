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
          LayoutBuilder(
            builder: (context, constraints) {
              final itemWidth = constraints.maxWidth / _categories.length;
              final iconSize = (itemWidth - 8).clamp(40.0, 60.0).toDouble();

              return SizedBox(
                height: 90,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(_categories.length, (i) {
                    final cat = _categories[i];
                    final isSelected = _selectedIndex == i;

                    return SizedBox(
                      width: itemWidth,
                      child: GestureDetector(
                        onTap: () async {
                          setState(() {
                            _selectedIndex = i;
                          });

                          if (cat['name'] == 'Grooming') {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const GroomingPage(),
                              ),
                            );
                          } else {
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
                              width: iconSize,
                              height: iconSize,
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
                                color: isSelected
                                    ? AppColors.white
                                    : AppColors.primary,
                                size: iconSize * 0.47,
                              ),
                            ),
                            const SizedBox(height: 6),
                            SizedBox(
                              width: itemWidth,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  cat['name'] as String,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
