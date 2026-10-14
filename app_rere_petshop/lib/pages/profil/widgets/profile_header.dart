import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    required this.name,
    required this.email,
    required this.phone,
    required this.isLoggedIn,
    super.key,
  });

  final String name;
  final String email;
  final String phone;
  final bool isLoggedIn;

  @override
  Widget build(BuildContext context) {
    final displayName = isLoggedIn ? name : 'Selamat datang';

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Profil Pengguna',
            style: TextStyle(
              color: Colors.black,
              fontSize: 30,
              height: 1.15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Kelola akun dan anabul kesayangan',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 34),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.035),
                  blurRadius: 18,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: const Color(0xFFF2E9E7),
                  child: Text(
                    displayName.trim().isEmpty
                        ? '?'
                        : displayName.trim()[0].toUpperCase(),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 38,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 18),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      if (isLoggedIn) ...[
                        const SizedBox(height: 8),
                        _ProfileDetail(text: email),
                        const SizedBox(height: 3),
                        _ProfileDetail(text: phone),
                      ] else ...[
                        const SizedBox(height: 6),
                        const _ProfileDetail(text: 'Masuk untuk melihat akun'),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileDetail extends StatelessWidget {
  const _ProfileDetail({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text.isEmpty ? 'Belum diisi' : text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 14,
      ),
    );
  }
}
