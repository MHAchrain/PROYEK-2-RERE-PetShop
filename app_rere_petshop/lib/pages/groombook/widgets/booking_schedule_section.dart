import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/booking_detail_section_heading.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_formatters.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_surface.dart';

class BookingScheduleSection extends StatelessWidget {
  const BookingScheduleSection({
    super.key,
    required this.date,
    required this.time,
  });

  final DateTime date;
  final String time;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BookingDetailSectionHeading(
            icon: Icons.calendar_month_outlined,
            title: 'Jadwal Kedatangan',
          ),
          GroomingBookingSurface(
            child: Row(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Waktu', style: _labelStyle),
                    Text('$time WIB', style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  static const _labelStyle = TextStyle(color: AppColors.textSecondary, fontSize: 12);
}
