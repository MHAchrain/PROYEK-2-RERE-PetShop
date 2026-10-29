import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_spacing.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_typography.dart';
import 'package:flutter/material.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({required this.isRegister, super.key});

  final bool isRegister;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(AuthSpacing.x6, AuthSpacing.x4, AuthSpacing.x6, AuthSpacing.x6),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(AuthSpacing.x8)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AuthSpacing.x4),
                Text(isRegister ? 'Buat Akun Baru' : 'ReRe Petshop', style: const TextStyle(color: Colors.white, fontSize: AuthTypography.screenTitle, fontWeight: FontWeight.w800, letterSpacing: -.8)),
                const SizedBox(height: AuthSpacing.x2),
                Text(
                  isRegister ? 'Temukan kebutuhan terbaik untuk hewan kesayanganmu.' : 'Semua kebutuhan hewan kesayanganmu.',
                  style: TextStyle(color: Colors.white.withOpacity(.9), fontSize: AuthTypography.helper, height: 1.4, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          const SizedBox(width: AuthSpacing.x4),
          Container(
            width: 88,
            height: 88,
            padding: const EdgeInsets.all(AuthSpacing.x3),
            child: Image.asset('assets/images/logo-rere.png', fit: BoxFit.contain),
          ),
        ],
      ),
    );
  }
}
