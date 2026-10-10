import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:flutter/material.dart';

class CartSelectionHeader extends StatelessWidget {
  const CartSelectionHeader({
    required this.allSelected,
    required this.isBusy,
    required this.hasSelection,
    required this.onSelectAll,
    required this.onDelete,
    super.key,
  });

  final bool allSelected;
  final bool isBusy;
  final bool hasSelection;
  final ValueChanged<bool> onSelectAll;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFF0F0F0))),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: allSelected,
              activeColor: AppColors.primary,
              visualDensity: VisualDensity.compact,
              onChanged: isBusy ? null : (value) => onSelectAll(value == true),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Pilih semua produk',
            style: TextStyle(fontSize: 13, color: AppColors.textPrimary),
          ),
          const Spacer(),
          TextButton(
            onPressed: isBusy || !hasSelection ? null : onDelete,
            style: TextButton.styleFrom(
              foregroundColor: AppColors.primary,
              padding: EdgeInsets.zero,
              minimumSize: const Size(48, 36),
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
