import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_status.dart';

class BookingStatusCard extends StatelessWidget {
  const BookingStatusCard({super.key, required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = GroomingBookingStatus.color(status);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: GroomingBookingStatus.background(status),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(.15)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_iconFor(status), color: color, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Status Booking',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          GroomingBookingStatus.label(status),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  GroomingBookingStatus.description(status),
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(String value) => switch (value) {
        'menunggu_pembayaran' => Icons.hourglass_top_rounded,
        'terjadwal' || 'dikonfirmasi' => Icons.event_available,
        'selesai' => Icons.check_circle_outline,
        'dibatalkan' || 'gagal' => Icons.cancel_outlined,
        _ => Icons.info_outline,
      };
}
