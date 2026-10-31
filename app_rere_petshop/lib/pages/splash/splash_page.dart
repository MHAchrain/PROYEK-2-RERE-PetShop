// lib/presentation/screens/splash/splash_screen.dart
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/app/navigation.dart';
import 'package:app_rere_petshop/pages/onboarding/onboarding_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _scribbleController;
  late AnimationController _catPlayController;

  late Animation<double> _bgScribbleAnimation;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _pawPrintProgress;
  late Animation<double> _textFade;
  late Animation<double> _catWiggle;

  @override
  void initState() {
    super.initState();

    // 1. Controller utama durasi 2.8 detik
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    // 2. Controller loop coretan & cat doodle animasi
    _scribbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _catPlayController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    // Timeline animasi bertahap
    _bgScribbleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.0, 0.65, curve: Curves.easeInOutCubic),
      ),
    );

    _logoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.15, 0.60, curve: Curves.elasticOut),
      ),
    );

    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.1, 0.45, curve: Curves.easeIn),
      ),
    );

    _pawPrintProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.40, 0.85, curve: Curves.easeInOut),
      ),
    );

    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _mainController,
        curve: const Interval(0.45, 0.80, curve: Curves.easeOut),
      ),
    );

    _catWiggle = Tween<double>(begin: -0.06, end: 0.06).animate(
      CurvedAnimation(
        parent: _catPlayController,
        curve: Curves.easeInOutSine,
      ),
    );

    _mainController.forward();

    // Navigasi setelah animasi selesai
    Future.delayed(const Duration(milliseconds: 3200), () async {
      if (!mounted) return;
      final prefs = await SharedPreferences.getInstance();
      final hasSeen = prefs.getBool('has_seen_onboarding') ?? false;

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (_, __, ___) =>
              hasSeen ? const MainNavigation() : const OnboardingPage(),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _mainController.dispose();
    _scribbleController.dispose();
    _catPlayController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primary, // #850909 RERe Maroon
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Animated Scribble / Doodle Canvas
          AnimatedBuilder(
            animation: Listenable.merge([_mainController, _scribbleController]),
            builder: (context, child) {
              return CustomPaint(
                painter: CatScribblePainter(
                  drawProgress: _bgScribbleAnimation.value,
                  pulse: _scribbleController.value,
                ),
              );
            },
          ),

          // Main Center Content
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // Animated Cat Doodle + Logo Box
                  AnimatedBuilder(
                    animation: Listenable.merge([_mainController, _catPlayController]),
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _logoScale.value,
                        child: Opacity(
                          opacity: _logoFade.value.clamp(0.0, 1.0),
                          child: Stack(
                            alignment: Alignment.center,
                            clipBehavior: Clip.none,
                            children: [
                              // Playful Peeking Cat Ears & Whiskers Doodle di atas Logo
                              Positioned(
                                top: -38,
                                child: Transform.rotate(
                                  angle: _catWiggle.value,
                                  child: SizedBox(
                                    width: 140,
                                    height: 50,
                                    child: CustomPaint(
                                      painter: PeekingCatPainter(
                                        wiggle: _catWiggle.value,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              // Scribble glow ring di belakang logo
                              Container(
                                width: 124,
                                height: 124,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.18 + (_scribbleController.value * 0.12)),
                                    width: 3.5,
                                  ),
                                ),
                              ),

                              // Logo Container White Card
                              Container(
                                width: 104,
                                height: 104,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.35),
                                      blurRadius: 24,
                                      offset: const Offset(0, 12),
                                    ),
                                    BoxShadow(
                                      color: Colors.white.withValues(alpha: 0.2),
                                      blurRadius: 10,
                                      offset: const Offset(-2, -2),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(28),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Image.asset(
                                      'assets/images/logo-rere.png',
                                      fit: BoxFit.contain,
                                      errorBuilder: (_, __, ___) => const Center(
                                        child: Text(
                                          'ReRe',
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 28,
                                            letterSpacing: -0.5,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Animated Paw Trail (Jejak Kaki Kucing Animasi)
                  AnimatedBuilder(
                    animation: _pawPrintProgress,
                    builder: (context, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          // Opacity bertahap untuk jejak kaki kucing
                          final trigger = index * 0.22;
                          final alpha = ((_pawPrintProgress.value - trigger) / 0.25)
                              .clamp(0.0, 1.0);
                          final tilt = (index % 2 == 0) ? -0.15 : 0.15;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 7),
                            child: Transform.rotate(
                              angle: tilt,
                              child: Opacity(
                                opacity: alpha,
                                child: const Icon(
                                  Icons.pets_rounded,
                                  color: Color(0xFFFFD4D4),
                                  size: 18,
                                ),
                              ),
                            ),
                          );
                        }),
                      );
                    },
                  ),

                  const SizedBox(height: 22),

                  // Brand Text & Tagline
                  AnimatedBuilder(
                    animation: _textFade,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _textFade.value.clamp(0.0, 1.0),
                        child: Column(
                          children: [
                            const Text(
                              'ReRe Petshop',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.25),
                                  width: 1,
                                ),
                              ),
                              child: const Text(
                                '🐾 Sahabat Terbaik Kucing Kesayanganmu',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  const Spacer(flex: 4),

                  // Footer kecil
                  AnimatedBuilder(
                    animation: _textFade,
                    builder: (context, child) {
                      return Opacity(
                        opacity: (_textFade.value * 0.7).clamp(0.0, 1.0),
                        child: const Padding(
                          padding: EdgeInsets.only(bottom: 24),
                          child: Text(
                            'Versi 1.0.0 • Made with ❤️ for Cats',
                            style: TextStyle(
                              color: Color(0xFFF0B8B8),
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// CustomPainter untuk coretan (scribble / doodles / cat yarn) di latar belakang
class CatScribblePainter extends CustomPainter {
  final double drawProgress;
  final double pulse;

  CatScribblePainter({
    required this.drawProgress,
    required this.pulse,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (drawProgress <= 0.01) return;

    final chalkPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.10 + (pulse * 0.05))
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final softPaint = Paint()
      ..color = const Color(0xFFFFC0C0).withValues(alpha: 0.09)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final w = size.width;
    final h = size.height;

    // 1. Coretan garis benang kucing (Yarn swirl scribble) di kiri atas
    final pathTopLeft = Path();
    pathTopLeft.moveTo(w * 0.08, h * 0.12);
    pathTopLeft.cubicTo(
      w * 0.25, h * 0.06,
      w * 0.35, h * 0.18,
      w * 0.15, h * 0.22,
    );
    pathTopLeft.cubicTo(
      w * 0.02, h * 0.25,
      w * 0.12, h * 0.32,
      w * 0.28, h * 0.28,
    );
    _drawAnimatedPath(canvas, pathTopLeft, chalkPaint, drawProgress);

    // 2. Coretan spiral benang di kanan atas
    final pathTopRight = Path();
    pathTopRight.moveTo(w * 0.85, h * 0.10);
    pathTopRight.cubicTo(
      w * 0.70, h * 0.15,
      w * 0.95, h * 0.22,
      w * 0.78, h * 0.27,
    );
    _drawAnimatedPath(canvas, pathTopRight, softPaint, drawProgress);

    // 3. Coretan kumis & senyum kucing lucu di kanan bawah
    final catWhiskerRight = Path();
    catWhiskerRight.moveTo(w * 0.72, h * 0.72);
    catWhiskerRight.quadraticBezierTo(w * 0.82, h * 0.70, w * 0.92, h * 0.68);
    catWhiskerRight.moveTo(w * 0.72, h * 0.74);
    catWhiskerRight.quadraticBezierTo(w * 0.83, h * 0.74, w * 0.94, h * 0.75);
    catWhiskerRight.moveTo(w * 0.72, h * 0.76);
    catWhiskerRight.quadraticBezierTo(w * 0.82, h * 0.78, w * 0.90, h * 0.82);
    _drawAnimatedPath(canvas, catWhiskerRight, chalkPaint, drawProgress);

    // 4. Coretan kumis kucing di kiri bawah
    final catWhiskerLeft = Path();
    catWhiskerLeft.moveTo(w * 0.28, h * 0.72);
    catWhiskerLeft.quadraticBezierTo(w * 0.18, h * 0.70, w * 0.08, h * 0.68);
    catWhiskerLeft.moveTo(w * 0.28, h * 0.74);
    catWhiskerLeft.quadraticBezierTo(w * 0.17, h * 0.74, w * 0.06, h * 0.75);
    catWhiskerLeft.moveTo(w * 0.28, h * 0.76);
    catWhiskerLeft.quadraticBezierTo(w * 0.18, h * 0.78, w * 0.10, h * 0.82);
    _drawAnimatedPath(canvas, catWhiskerLeft, chalkPaint, drawProgress);

    // 5. Coretan bintang-bintang / spark doodle kecil
    _drawChalkStar(canvas, Offset(w * 0.18, h * 0.42), 9, chalkPaint, drawProgress);
    _drawChalkStar(canvas, Offset(w * 0.82, h * 0.40), 11, softPaint, drawProgress);
    _drawChalkStar(canvas, Offset(w * 0.25, h * 0.82), 8, softPaint, drawProgress);
    _drawChalkStar(canvas, Offset(w * 0.78, h * 0.85), 10, chalkPaint, drawProgress);

    // 6. Coretan lingkaran bola benang (yarn ball sketch) di pojok kiri bawah
    final yarnBall = Path();
    yarnBall.addOval(Rect.fromCircle(center: Offset(w * 0.15, h * 0.88), radius: 24));
    yarnBall.moveTo(w * 0.10, h * 0.88);
    yarnBall.quadraticBezierTo(w * 0.15, h * 0.82, w * 0.20, h * 0.88);
    yarnBall.moveTo(w * 0.15, h * 0.83);
    yarnBall.quadraticBezierTo(w * 0.20, h * 0.88, w * 0.15, h * 0.93);
    _drawAnimatedPath(canvas, yarnBall, softPaint, drawProgress);
  }

  void _drawAnimatedPath(Canvas canvas, Path path, Paint paint, double progress) {
    for (final metric in path.computeMetrics()) {
      final extractLength = metric.length * progress.clamp(0.0, 1.0);
      final extracted = metric.extractPath(0.0, extractLength);
      canvas.drawPath(extracted, paint);
    }
  }

  void _drawChalkStar(
      Canvas canvas, Offset center, double size, Paint paint, double progress) {
    if (progress < 0.3) return;
    final starPath = Path();
    starPath.moveTo(center.dx - size, center.dy);
    starPath.lineTo(center.dx + size, center.dy);
    starPath.moveTo(center.dx, center.dy - size);
    starPath.lineTo(center.dx, center.dy + size);
    starPath.moveTo(center.dx - (size * 0.6), center.dy - (size * 0.6));
    starPath.lineTo(center.dx + (size * 0.6), center.dy + (size * 0.6));
    starPath.moveTo(center.dx - (size * 0.6), center.dy + (size * 0.6));
    starPath.lineTo(center.dx + (size * 0.6), center.dy - (size * 0.6));
    canvas.drawPath(starPath, paint);
  }

  @override
  bool shouldRepaint(covariant CatScribblePainter oldDelegate) {
    return oldDelegate.drawProgress != drawProgress || oldDelegate.pulse != pulse;
  }
}

/// CustomPainter untuk coretan kuping & kepala kucing ngintip di atas box
class PeekingCatPainter extends CustomPainter {
  final double wiggle;

  PeekingCatPainter({required this.wiggle});

  @override
  void paint(Canvas canvas, Size size) {
    final catPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final earPink = Paint()
      ..color = const Color(0xFFFFB3B3)
      ..style = PaintingStyle.fill;

    final w = size.width;
    final h = size.height;

    // Kuping Kiri (Sketchy Ear)
    final leftEar = Path();
    leftEar.moveTo(w * 0.22, h);
    leftEar.lineTo(w * 0.26, h * 0.15 + (wiggle * 20));
    leftEar.lineTo(w * 0.42, h * 0.65);

    // Kuping Kanan (Sketchy Ear)
    final rightEar = Path();
    rightEar.moveTo(w * 0.58, h * 0.65);
    rightEar.lineTo(w * 0.74, h * 0.15 - (wiggle * 20));
    rightEar.lineTo(w * 0.78, h);

    // Bagian dalam kuping warna pink lembut
    final leftEarInner = Path();
    leftEarInner.moveTo(w * 0.26, h * 0.85);
    leftEarInner.lineTo(w * 0.28, h * 0.35 + (wiggle * 20));
    leftEarInner.lineTo(w * 0.38, h * 0.72);
    leftEarInner.close();

    final rightEarInner = Path();
    rightEarInner.moveTo(w * 0.62, h * 0.72);
    rightEarInner.lineTo(w * 0.72, h * 0.35 - (wiggle * 20));
    rightEarInner.lineTo(w * 0.74, h * 0.85);
    rightEarInner.close();

    // Kepala lengkung atas
    final headCurve = Path();
    headCurve.moveTo(w * 0.40, h * 0.70);
    headCurve.quadraticBezierTo(w * 0.50, h * 0.58, w * 0.60, h * 0.70);

    // Mata kucing ngintip (^ . ^) lucu coretan
    final leftEye = Path();
    leftEye.moveTo(w * 0.36, h * 0.90);
    leftEye.quadraticBezierTo(w * 0.40, h * 0.78, w * 0.44, h * 0.90);

    final rightEye = Path();
    rightEye.moveTo(w * 0.56, h * 0.90);
    rightEye.quadraticBezierTo(w * 0.60, h * 0.78, w * 0.64, h * 0.90);

    // Gambar komponen
    canvas.drawPath(leftEarInner, earPink);
    canvas.drawPath(rightEarInner, earPink);
    canvas.drawPath(leftEar, catPaint);
    canvas.drawPath(rightEar, catPaint);
    canvas.drawPath(headCurve, catPaint);
    canvas.drawPath(leftEye, catPaint);
    canvas.drawPath(rightEye, catPaint);
  }

  @override
  bool shouldRepaint(covariant PeekingCatPainter oldDelegate) {
    return oldDelegate.wiggle != wiggle;
  }
}
