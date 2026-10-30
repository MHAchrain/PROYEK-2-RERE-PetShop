import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/booking_detail_section_heading.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_formatters.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_surface.dart';

class BookingServiceSection extends StatelessWidget {
  const BookingServiceSection({super.key, required this.service});

  final Map<String, dynamic> service;

  @override
  Widget build(BuildContext context) {
    final duration = service['duration_minutes'] ?? service['durationMinutes'] ?? 0;
    final price = GroomingBookingFormatters.number(service['price']);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BookingDetailSectionHeading(icon: Icons.content_cut, title: 'Layanan Grooming'),
        GroomingBookingSurface(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${service['name'] ?? 'Grooming'}',
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ),
                  Text(
                    GroomingBookingFormatters.rupiah(price),
                    style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                '${service['description'] ?? ''}',
                style: const TextStyle(color: AppColors.textSecondary, fontSize: 13, height: 1.45),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.schedule, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  Text('Durasi sekitar $duration menit', style: _metaStyle),
                  const Spacer(),
                  const Icon(Icons.pets, size: 16, color: AppColors.primary),
                  const SizedBox(width: 6),
                  const Text('1 hewan per slot', style: _metaStyle),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  static const _metaStyle = TextStyle(fontSize: 12, color: AppColors.textSecondary);
}
