import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_formatters.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_surface.dart';

class ConfirmBookScheduleSection extends StatelessWidget {
  const ConfirmBookScheduleSection({
    super.key,
    required this.date,
    required this.time,
    required this.durationMinutes,
    required this.onEdit,
  });

  final DateTime date;
  final String time;
  final int durationMinutes;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined, color: AppColors.primary, size: 21),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Jadwal Kedatangan',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
              ),
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_calendar_outlined, size: 16),
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
                    const Icon(Icons.event_available, color: AppColors.primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Hari & Tanggal', style: _labelStyle),
                          Text(
                            GroomingBookingFormatters.longDate(date),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    const Text('Slot terpilih', style: TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
                const Divider(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: _timeDetail('Waktu Kedatangan', '$time WIB'),
                    ),
                    Container(width: 1, height: 42, color: AppColors.divider),
                    Expanded(
                      child: _timeDetail(
                        'Estimasi Durasi',
                        '$durationMinutes menit',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  Widget _timeDetail(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: _labelStyle),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      );

  static const _labelStyle = TextStyle(
    color: AppColors.textSecondary,
    fontSize: 12,
  );
}
