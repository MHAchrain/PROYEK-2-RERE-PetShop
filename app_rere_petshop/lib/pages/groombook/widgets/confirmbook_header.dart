import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_surface.dart';

class ConfirmBookHeader extends StatelessWidget {
  const ConfirmBookHeader({super.key});

  @override
  Widget build(BuildContext context) => const GroomingBookingSurface(
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFFFCECEC),
              child: Icon(Icons.fact_check_outlined, color: AppColors.primary),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Periksa Detail Booking',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  SizedBox(height: 3),
                  Text(
                    'Pastikan data anabul, layanan, dan jadwal sudah sesuai.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
