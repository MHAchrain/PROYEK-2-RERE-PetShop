import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_formatters.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_surface.dart';

class ConfirmBookServiceSection extends StatelessWidget {
  const ConfirmBookServiceSection({
    super.key,
    required this.service,
    required this.onEdit,
  });

  final Map<String, dynamic> service;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final duration = service['duration_minutes'] ?? service['durationMinutes'] ?? 0;
    final price = GroomingBookingFormatters.number(service['price']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.content_cut, color: AppColors.primary, size: 21),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Layanan Grooming',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            TextButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined, size: 16),
              label: const Text('Ubah'),
            ),
          ],
        ),
        GroomingBookingSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${service['name'] ?? 'Grooming'}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(
                    GroomingBookingFormatters.rupiah(price),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${service['description'] ?? ''}',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 17, color: AppColors.primary),
                  const SizedBox(width: 7),
                  Text('Durasi sekitar $duration menit'),
                  const Spacer(),
                  const Icon(Icons.pets, size: 17, color: AppColors.primary),
                  const SizedBox(width: 6),
                  const Text('1 hewan per slot'),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
