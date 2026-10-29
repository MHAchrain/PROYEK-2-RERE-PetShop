import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_spacing.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_typography.dart';
import 'package:flutter/material.dart';

class AuthPrimaryButton extends StatelessWidget {
  const AuthPrimaryButton({required this.label, required this.onPressed, required this.loading, super.key});

  final String label;
  final VoidCallback? onPressed;
  final bool loading;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: double.infinity,
    height: AuthSpacing.buttonHeight,
    child: ElevatedButton(
      onPressed: loading ? null : onPressed,
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, disabledBackgroundColor: AppColors.primary.withOpacity(.65), elevation: 0, shape: const StadiumBorder()),
      child: loading
        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
        : Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(label, style: const TextStyle(fontSize: AuthTypography.button, fontWeight: FontWeight.w800)), const SizedBox(width: AuthSpacing.x2), const Icon(Icons.arrow_forward_rounded, size: 20)]),
    ),
  );
}
