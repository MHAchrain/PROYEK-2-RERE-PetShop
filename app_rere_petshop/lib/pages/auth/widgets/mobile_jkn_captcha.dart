import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_spacing.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_typography.dart';

/// Widget Captcha Angka bergaya Mobile JKN (BPJS)
/// Dilengkapi noise canvas painter, tombol refresh berputar, dan input field yang serasi.
class MobileJknCaptcha extends StatefulWidget {
  const MobileJknCaptcha({
    required this.controller,
    required this.captchaCode,
    required this.onRefresh,
    this.isLoading = false,
    this.validator,
    super.key,
  });

  final TextEditingController controller;
  final String? captchaCode;
  final VoidCallback onRefresh;
  final bool isLoading;
  final String? Function(String?)? validator;

  @override
  State<MobileJknCaptcha> createState() => _MobileJknCaptchaState();
}

class _MobileJknCaptchaState extends State<MobileJknCaptcha>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _handleRefresh() {
    _animController.forward(from: 0.0);
    widget.onRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Kode Keamanan',
              style: TextStyle(
                fontSize: AuthTypography.label,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.verified_user_outlined,
                  size: 14,
                  color: AppColors.primary.withValues(alpha: 0.8),
                ),
                const SizedBox(width: 4),
                Text(
                  'Verifikasi Angka',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AuthSpacing.x2),

        // Box Display Captcha & Tombol Refresh
        Row(
          children: [
            Expanded(
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(AuthSpacing.x3),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AuthSpacing.x3),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Noise & Security Lines Background
                      Positioned.fill(
                        child: CustomPaint(
                          painter: _CaptchaNoisePainter(
                            seed: widget.captchaCode?.hashCode ?? 42,
                          ),
                        ),
                      ),

                      // Teks Captcha Angka
                      widget.isLoading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.primary,
                              ),
                            )
                          : _buildCaptchaText(widget.captchaCode ?? '-----'),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: AuthSpacing.x2),

            // Tombol Refresh Captcha
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.isLoading ? null : _handleRefresh,
                borderRadius: BorderRadius.circular(AuthSpacing.x3),
                child: Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                    borderRadius: BorderRadius.circular(AuthSpacing.x3),
                    border: Border.all(color: const Color(0xFFE2E5E9)),
                  ),
                  child: Center(
                    child: RotationTransition(
                      turns: _animController,
                      child: const Icon(
                        Icons.refresh_rounded,
                        color: AppColors.primary,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AuthSpacing.x2),

        // Input Field Captcha
        TextFormField(
          controller: widget.controller,
          keyboardType: TextInputType.number,
          maxLength: 5,
          style: const TextStyle(
            fontSize: AuthTypography.label,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.0,
            color: AppColors.textPrimary,
          ),
          validator: widget.validator,
          decoration: InputDecoration(
            counterText: '',
            hintText: 'Masukkan 5 angka di atas',
            hintStyle: const TextStyle(
              color: Color(0xFF9AA1AD),
              fontSize: AuthTypography.label,
              letterSpacing: 0,
            ),
            prefixIcon: const Icon(
              Icons.shield_outlined,
              size: 20,
              color: Color(0xFF8290A3),
            ),
            prefixIconConstraints: const BoxConstraints(
              minWidth: AuthSpacing.controlHeight,
              minHeight: AuthSpacing.controlHeight,
            ),
            filled: true,
            fillColor: const Color(0xFFF7F8FA),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AuthSpacing.x4,
              vertical: 0,
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

  Widget _buildCaptchaText(String code) {
    // Tampilkan setiap angka dengan sedikit rotasi dan offset seperti di Mobile JKN
    final chars = code.split('');
    final colors = [
      AppColors.primary,
      const Color(0xFF1E293B),
      const Color(0xFF991B1B),
      const Color(0xFF0F172A),
      AppColors.primary,
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(chars.length, (i) {
        final randomAngle = ((i % 2 == 0 ? 1 : -1) * (0.05 + (i * 0.02)));
        return Transform.rotate(
          angle: randomAngle,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(
              chars[i],
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: colors[i % colors.length],
                fontFamily: 'monospace',
                letterSpacing: 3,
                decoration: TextDecoration.lineThrough,
                decorationThickness: 1.5,
                decorationColor: Colors.black26,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    offset: const Offset(1, 1),
                    blurRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  OutlineInputBorder _border({Color color = const Color(0xFFE2E5E9)}) =>
      OutlineInputBorder(
        borderRadius: BorderRadius.circular(AuthSpacing.x3),
        borderSide: BorderSide(color: color),
      );
}

/// CustomPainter untuk menggambar garis acak dan titik noise keamanan captcha (Mobile JKN style)
class _CaptchaNoisePainter extends CustomPainter {
  _CaptchaNoisePainter({required this.seed});
  final int seed;

  @override
  void paint(Canvas canvas, Size size) {
    final rand = math.Random(seed);

    // Garis diagonal & kurva keamanan
    final linePaint = Paint()
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 4; i++) {
      linePaint.color = Color.fromRGBO(
        rand.nextInt(100) + 100,
        rand.nextInt(100) + 100,
        rand.nextInt(100) + 100,
        0.35,
      );

      final path = Path()
        ..moveTo(0, rand.nextDouble() * size.height)
        ..quadraticBezierTo(
          rand.nextDouble() * size.width,
          rand.nextDouble() * size.height,
          size.width,
          rand.nextDouble() * size.height,
        );
      canvas.drawPath(path, linePaint);
    }

    // Titik noise
    final dotPaint = Paint()..style = PaintingStyle.fill;
    for (int i = 0; i < 25; i++) {
      dotPaint.color = Colors.black.withValues(alpha: rand.nextDouble() * 0.08 + 0.02);
      canvas.drawCircle(
        Offset(rand.nextDouble() * size.width, rand.nextDouble() * size.height),
        rand.nextDouble() * 1.5 + 0.5,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _CaptchaNoisePainter oldDelegate) =>
      oldDelegate.seed != seed;
}
