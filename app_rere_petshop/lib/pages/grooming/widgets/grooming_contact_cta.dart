import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';

class GroomingContactCta extends StatelessWidget {
  const GroomingContactCta({super.key, required this.onContact});

  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.phone_in_talk,
            color: Colors.white,
            size: 40,
          ),
          const SizedBox(height: 12),
          const Text(
            '*Konsultasi gratis & Booking jadwal',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hubungi kami untuk info lebih lanjut',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
