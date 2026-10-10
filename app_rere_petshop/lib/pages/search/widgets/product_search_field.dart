import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProductSearchField extends StatelessWidget {
  const ProductSearchField({
    super.key,
    required this.controller,
    required this.filterCount,
    required this.onChanged,
    required this.onSubmitted,
    required this.onFilterTap,
  });

  final TextEditingController controller;
  final int filterCount;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: TextField(
        controller: controller,
        autofocus: true,
        textInputAction: TextInputAction.search,
        onSubmitted: onSubmitted,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'Cari makanan, kandang, mainan...',
          hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: AppColors.grey),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (controller.text.isNotEmpty)
                IconButton(
                  tooltip: 'Hapus pencarian',
                  icon: const Icon(Icons.close, color: AppColors.grey),
                  onPressed: () {
                    controller.clear();
                    onChanged('');
                  },
                ),
              Stack(
                clipBehavior: Clip.none,
                children: [
                  IconButton(
                    tooltip: 'Filter produk',
                    icon: const Icon(Icons.tune, color: AppColors.textSecondary),
                    onPressed: onFilterTap,
                  ),
                  if (filterCount > 0)
                    Positioned(
                      right: 7,
                      top: 7,
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          filled: true,
          fillColor: const Color(0xFFF8F8F8),
          border: _border(const Color(0xFFE7E7E7)),
          enabledBorder: _border(const Color(0xFFE7E7E7)),
          focusedBorder: _border(AppColors.primary),
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(32),
        borderSide: BorderSide(color: color, width: 1.3),
      );
}
