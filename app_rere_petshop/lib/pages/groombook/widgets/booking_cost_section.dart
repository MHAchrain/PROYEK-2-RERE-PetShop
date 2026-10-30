import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/booking_detail_section_heading.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_formatters.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_surface.dart';

class BookingCostSection extends StatelessWidget {
  const BookingCostSection({super.key, required this.price});

  final int price;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BookingDetailSectionHeading(icon: Icons.receipt_long_outlined, title: 'Rincian Biaya'),
          GroomingBookingSurface(
            child: Column(
              children: [
                _row('Paket grooming', GroomingBookingFormatters.rupiah(price)),
                const Divider(height: 24),
                _row(
                  'Total Pembayaran',
                  GroomingBookingFormatters.rupiah(price),
                  total: true,
                ),
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Icon(Icons.lock_outline, size: 17, color: AppColors.textSecondary),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Pembayaran diproses melalui Midtrans.',
                        style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );

  Widget _row(String label, String value, {bool total = false}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: total ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: total ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: total ? AppColors.primary : AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: total ? 18 : 14,
            ),
          ),
        ],
      );
}
