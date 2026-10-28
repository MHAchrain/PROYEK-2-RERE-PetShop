import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_spacing.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_typography.dart';
import 'package:flutter/material.dart';

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({required this.prompt, required this.action, required this.onTap, super.key});
  final String prompt;
  final String action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Center(child: Wrap(crossAxisAlignment: WrapCrossAlignment.center, children: [
    Text(prompt, style: const TextStyle(color: AppColors.textSecondary, fontSize: AuthTypography.helper)),
    TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: AuthSpacing.x1), minimumSize: Size.zero, tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      child: Text(action, style: const TextStyle(color: AppColors.primary, fontSize: AuthTypography.helper, fontWeight: FontWeight.w800)),
    ),
  ]));
}
