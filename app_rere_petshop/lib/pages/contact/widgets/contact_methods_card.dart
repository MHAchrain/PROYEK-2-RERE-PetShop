import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/constants/app_constants.dart';

class ContactMethodsCard extends StatelessWidget {
  const ContactMethodsCard(
      {super.key, required this.onCall, required this.onWhatsApp});

  final VoidCallback onCall;
  final VoidCallback onWhatsApp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Hubungi langsung
          _contactItem(
            icon: Icons.phone_outlined,
            title: 'Hubungi Kami',
            subtitle: 'Nomor Telepon: 0813-1941-0250',
            description:
                'Hubungi kami saat jam operasional untuk informasi stok, pesanan, dan layanan grooming.',
            onTap: onCall,
            buttonLabel: 'Telepon',
            buttonIcon: Icons.phone,
          ),
          const Divider(height: 24),

          // WhatsApp
          _contactItem(
            icon: Icons.chat_outlined,
            title: 'WhatsApp',
            subtitle: '0813-1941-0250',
            description: 'Chat kami via WhatsApp untuk respons lebih cepat.',
            onTap: onWhatsApp,
            buttonLabel: 'Buka WhatsApp',
            buttonIcon: Icons.send,
          ),
          const Divider(height: 24),

          // Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.location_on_outlined,
                    color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Alamat Toko',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        )),
                    SizedBox(height: 4),
                    Text(
                      AppConstants.address,
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 13),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Email: ${AppConstants.email}',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required VoidCallback onTap,
    required String buttonLabel,
    required IconData buttonIcon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  )),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(description,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(height: 10),
              SizedBox(
                height: 36,
                child: ElevatedButton.icon(
                  onPressed: onTap,
                  icon: Icon(buttonIcon, size: 16),
                  label:
                      Text(buttonLabel, style: const TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
