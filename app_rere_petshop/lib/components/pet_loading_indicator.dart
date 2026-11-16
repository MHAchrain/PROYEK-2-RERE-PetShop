import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';

/// Loading indicator melingkar dengan garis putus-putus berputar halus
class PetLoadingIndicator extends StatefulWidget {
  final String? message;
  final double size;
  final Color? color;

  const PetLoadingIndicator({
    super.key,
    this.message = 'Memuat data...',
    this.size = 46,
    this.color,
  });

  @override
  State<PetLoadingIndicator> createState() => _PetLoadingIndicatorState();
}

class _PetLoadingIndicatorState extends State<PetLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ringColor = widget.color ?? AppColors.primary;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              return Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _DashedCircleSpinnerPainter(
                    color: ringColor,
                    strokeWidth: 3.5,
                    dashCount: 8,
                    gapRatio: 0.35,
                  ),
                ),
              );
            },
          ),
          if (widget.message != null && widget.message!.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              widget.message!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DashedCircleSpinnerPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final int dashCount;
  final double gapRatio;

  _DashedCircleSpinnerPainter({
    required this.color,
    required this.strokeWidth,
    required this.dashCount,
    required this.gapRatio,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final totalAngle = 2 * math.pi;
    final sectionAngle = totalAngle / dashCount;
    final dashAngle = sectionAngle * (1 - gapRatio);

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < dashCount; i++) {
      final startAngle = i * sectionAngle;
      // Berikan gradasi opasitas tiap segmen putus-putus agar terlihat efek putaran mengalir
      final alpha = ((i + 1) / dashCount).clamp(0.15, 1.0);
      paint.color = color.withValues(alpha: alpha);

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        dashAngle,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _DashedCircleSpinnerPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.dashCount != dashCount;
  }
}
