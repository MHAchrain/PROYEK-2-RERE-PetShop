import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';

class GroomingSlotGroup extends StatelessWidget {
  const GroomingSlotGroup({
    super.key,
    required this.title,
    required this.subtitle,
    required this.slots,
    required this.selectedTime,
    required this.isAvailable,
    required this.onSelect,
  });

  final String title;
  final String subtitle;
  final List<Map<String, dynamic>> slots;
  final String? selectedTime;
  final bool Function(Map<String, dynamic>) isAvailable;
  final ValueChanged<String> onSelect;

  static const _metaStyle = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.wb_sunny_outlined, size: 18, color: AppColors.primary),
              const SizedBox(width: 7),
              Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(width: 6),
              Text(subtitle, style: _metaStyle),
            ],
          ),
          const SizedBox(height: 9),
          if (slots.isEmpty)
            const Text('Tidak ada slot pada sesi ini.', style: _metaStyle)
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: slots.map(_slotButton).toList(),
            ),
        ],
      );

  Widget _slotButton(Map<String, dynamic> slot) {
    final rawTime = '${slot['time'] ?? ''}';
    final time = rawTime.length >= 5 ? rawTime.substring(0, 5) : rawTime;
    final available = isAvailable(slot);
    final selected = selectedTime == time;
    return InkWell(
      onTap: available ? () => onSelect(time) : null,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 94,
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : (available ? AppColors.white : const Color(0xFFF1F1F1)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFE5E5E5),
          ),
        ),
        child: Column(
          children: [
            Text(
              time,
              style: TextStyle(
                color: selected
                    ? Colors.white
                    : (available ? AppColors.textPrimary : AppColors.grey),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              available ? (selected ? 'Terpilih' : 'Tersedia') : 'Penuh',
              style: TextStyle(
                fontSize: 11,
                color: selected
                    ? Colors.white70
                    : (available ? Colors.green : AppColors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
