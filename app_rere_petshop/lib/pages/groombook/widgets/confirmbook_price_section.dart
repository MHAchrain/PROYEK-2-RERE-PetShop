import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_formatters.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_surface.dart';

class ConfirmBookPriceSection extends StatelessWidget {
  const ConfirmBookPriceSection({super.key, required this.price});

  final int price;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.receipt_long_outlined, color: AppColors.primary, size: 21),
              SizedBox(width: 8),
              Text(
                'Rincian Biaya',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 10),
          GroomingBookingSurface(
            child: Column(
              children: [
                _priceRow('Layanan grooming', GroomingBookingFormatters.rupiah(price)),
                const Divider(height: 24),
                _priceRow(
                  'Total Pembayaran',
                  GroomingBookingFormatters.rupiah(price),
                  bold: true,
                  highlight: true,
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(11),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.lock_outline, size: 17, color: AppColors.textSecondary),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Pembayaran aman melalui Midtrans setelah konfirmasi booking.',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _priceRow(
    String label,
    String value, {
    bool bold = false,
    bool highlight = false,
  }) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: bold ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: highlight ? AppColors.primary : AppColors.textPrimary,
              fontWeight: bold ? FontWeight.bold : FontWeight.w600,
              fontSize: bold ? 18 : 14,
            ),
          ),
        ],
      );
}
