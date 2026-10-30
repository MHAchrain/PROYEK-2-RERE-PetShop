import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/booking_detail_section_heading.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_surface.dart';

class BookingPetSection extends StatelessWidget {
  const BookingPetSection({
    super.key,
    required this.name,
    required this.type,
    required this.breed,
    required this.size,
    required this.note,
  });

  final String name;
  final String type;
  final String breed;
  final String size;
  final String note;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BookingDetailSectionHeading(
            icon: Icons.pets,
            title: 'Hewan Peliharaan',
          ),
          GroomingBookingSurface(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 4),
                Text('$type · $breed · $size', style: _secondaryStyle),
                if (note.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFCECEC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.favorite_border, color: AppColors.primary, size: 18),
                        const SizedBox(width: 8),
                        Expanded(child: Text('Catatan: $note', style: _secondaryStyle)),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      );

  static const _secondaryStyle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
    height: 1.45,
  );
}
