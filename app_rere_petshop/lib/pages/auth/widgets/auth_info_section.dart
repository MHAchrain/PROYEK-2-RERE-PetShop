import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_spacing.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_typography.dart';
import 'package:flutter/material.dart';

class AuthInfoSection extends StatelessWidget {
  const AuthInfoSection({required this.title, required this.icon, required this.child, super.key});
  final String title;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AuthSpacing.x4),
    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AuthSpacing.x5), border: Border.all(color: const Color(0xFFF0F0F0))),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(children: [Icon(icon, color: AppColors.primary, size: 20), const SizedBox(width: AuthSpacing.x2), Text(title, style: const TextStyle(fontSize: AuthTypography.sectionTitle, fontWeight: FontWeight.w800))]),
      const Padding(padding: EdgeInsets.symmetric(vertical: AuthSpacing.x3), child: Divider(height: 1, color: Color(0xFFF0F0F0))),
      child,
    ]),
  );
}
