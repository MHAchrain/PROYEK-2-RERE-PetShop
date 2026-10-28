import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_spacing.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_typography.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.obscureText = false,
    this.onVisibilityPressed,
    super.key,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final bool obscureText;
  final VoidCallback? onVisibilityPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: AuthTypography.label, fontWeight: FontWeight.w700)),
        const SizedBox(height: AuthSpacing.x2),
        TextFormField(
          controller: controller,
          style: const TextStyle(
            fontSize: AuthTypography.label,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          validator: validator,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          maxLines: maxLines,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF9AA1AD), fontSize: AuthTypography.label),
            prefixIcon: Icon(icon, size: 20, color: const Color(0xFF8290A3)),
            prefixIconConstraints: const BoxConstraints(
              minWidth: AuthSpacing.controlHeight,
              minHeight: AuthSpacing.controlHeight,
            ),
            suffixIcon: onVisibilityPressed == null ? null : IconButton(
              icon: Icon(obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 16, color: const Color(0xFF8290A3)),
              onPressed: onVisibilityPressed,
            ),
            filled: true,
            fillColor: const Color(0xFFF7F8FA),
            contentPadding: EdgeInsets.symmetric(
              horizontal: AuthSpacing.x4,
              vertical: maxLines > 1 ? AuthSpacing.x3 : 0,
            ),
            border: _border(),
            enabledBorder: _border(),
            focusedBorder: _border(color: AppColors.primary),
            errorBorder: _border(color: Colors.red),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border({Color color = const Color(0xFFE2E5E9)}) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AuthSpacing.x3),
    borderSide: BorderSide(color: color),
  );
}
