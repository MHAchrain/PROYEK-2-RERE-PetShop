import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_formatters.dart';

class GroomingServiceCard extends StatelessWidget {
  const GroomingServiceCard({
    super.key,
    required this.service,
    required this.selected,
    required this.onTap,
  });

  final Map<String, dynamic> service;
  final bool selected;
  final VoidCallback onTap;

  static const _metaStyle = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  @override
  Widget build(BuildContext context) {
    final price = GroomingBookingFormatters.number(service['price']);
    final duration = service['duration_minutes'] ?? service['durationMinutes'] ?? 60;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.primary : const Color(0xFFE5E5E5),
            width: selected ? 1.5 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0A111111),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${service['name'] ?? 'Grooming'}',
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Icon(
                        selected ? Icons.check_circle : Icons.circle,
                        color: selected ? AppColors.primary : AppColors.greyLight,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${service['description'] ?? ''}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      height: 1.45,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.schedule, size: 15, color: AppColors.textSecondary),
                      const SizedBox(width: 5),
                      Text('Durasi $duration menit', style: _metaStyle),
                      const SizedBox(width: 14),
                      const Icon(Icons.pets, size: 15, color: AppColors.textSecondary),
                      const SizedBox(width: 5),
                      Text('Kucing & Anjing', style: _metaStyle),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Color(0xFFFAFAFA),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Harga layanan', style: _metaStyle),
                  Text(
                    GroomingBookingFormatters.rupiah(price),
                    style: TextStyle(
                      color: selected ? AppColors.primary : AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
