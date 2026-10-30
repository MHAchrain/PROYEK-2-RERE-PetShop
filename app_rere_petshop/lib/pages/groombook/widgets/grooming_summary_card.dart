import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_formatters.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_surface.dart';

class GroomingSummaryCard extends StatelessWidget {
  const GroomingSummaryCard({
    super.key,
    required this.petName,
    required this.petType,
    required this.service,
    required this.date,
    required this.time,
  });

  final String petName;
  final String petType;
  final Map<String, dynamic>? service;
  final DateTime? date;
  final String? time;

  static const _metaStyle = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  @override
  Widget build(BuildContext context) {
    final duration = service?['duration_minutes'] ?? service?['durationMinutes'] ?? 0;
    return GroomingBookingSurface(
      child: Column(
        children: [
          _row('Anabul', '$petName · $petType'),
          const Divider(height: 20),
          _row('Paket', '${service?['name'] ?? '-'}'),
          const SizedBox(height: 10),
          _row(
            'Tanggal',
            date == null ? 'Pilih tanggal' : GroomingBookingFormatters.longDate(date!),
          ),
          const SizedBox(height: 10),
          _row('Waktu', time ?? 'Pilih slot waktu'),
          const SizedBox(height: 10),
          _row('Durasi', '$duration menit'),
          const Divider(height: 20),
          _row(
            'Estimasi biaya',
            GroomingBookingFormatters.rupiah(
              GroomingBookingFormatters.number(service?['price']),
            ),
            valueColor: AppColors.primary,
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color? valueColor, bool bold = false}) =>
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: _metaStyle),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                color: valueColor ?? AppColors.textPrimary,
                fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              ),
            ),
          ),
        ],
      );
}
