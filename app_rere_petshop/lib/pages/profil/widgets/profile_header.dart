import 'dart:io';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

enum PetAvatarKind { catFace, pawPrint, catEars, fishSnack, yarnBall, petHeart }

class ProfileAvatarTemplate {
  const ProfileAvatarTemplate({
    required this.kind,
    required this.label,
    required this.background,
    required this.accent,
  });

  final PetAvatarKind kind;
  final String label;
  final Color background;
  final Color accent;
}

const List<ProfileAvatarTemplate> kProfileAvatarTemplates = [
  ProfileAvatarTemplate(
    kind: PetAvatarKind.catFace,
    label: 'Kucing',
    background: Color(0xFFFDECEC),
    accent: AppColors.primary,
  ),
  ProfileAvatarTemplate(
    kind: PetAvatarKind.pawPrint,
    label: 'Jejak Kaki',
    background: Color(0xFFF2E9E7),
    accent: Color(0xFF6D2E2E),
  ),
  ProfileAvatarTemplate(
    kind: PetAvatarKind.catEars,
    label: 'Telinga',
    background: Color(0xFFFEF3C7),
    accent: Color(0xFFB45309),
  ),
  ProfileAvatarTemplate(
    kind: PetAvatarKind.fishSnack,
    label: 'Ikan',
    background: Color(0xFFE0F2FE),
    accent: Color(0xFF0369A1),
  ),
  ProfileAvatarTemplate(
    kind: PetAvatarKind.yarnBall,
    label: 'Mainan',
    background: Color(0xFFF3E8FF),
    accent: Color(0xFF7E22CE),
  ),
  ProfileAvatarTemplate(
    kind: PetAvatarKind.petHeart,
    label: 'Sayang',
    background: Color(0xFFDCFCE7),
    accent: Color(0xFF15803D),
  ),
];

class PetAvatarArtwork extends StatelessWidget {
  const PetAvatarArtwork({
    required this.template,
    required this.size,
    super.key,
  });

  final ProfileAvatarTemplate template;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: template.background,
        border: Border.all(
          color: template.accent.withValues(alpha: 0.18),
          width: 1.5,
        ),
      ),
      child: CustomPaint(
        painter: _PetAvatarPainter(template.kind, template.accent),
      ),
    );
  }
}

class _PetAvatarPainter extends CustomPainter {
  const _PetAvatarPainter(this.kind, this.color);

  final PetAvatarKind kind;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final fill = Paint()..color = color..style = PaintingStyle.fill;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.055
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    switch (kind) {
      case PetAvatarKind.catFace:
        // Telinga kiri & kanan
        final leftEar = Path()
          ..moveTo(w * 0.25, h * 0.44)
          ..lineTo(w * 0.28, h * 0.22)
          ..lineTo(w * 0.42, h * 0.35)
          ..close();
        final rightEar = Path()
          ..moveTo(w * 0.75, h * 0.44)
          ..lineTo(w * 0.72, h * 0.22)
          ..lineTo(w * 0.58, h * 0.35)
          ..close();
        canvas.drawPath(leftEar, fill);
        canvas.drawPath(rightEar, fill);
        // Kepala bulat
        canvas.drawOval(
          Rect.fromCenter(center: Offset(w * 0.5, h * 0.55), width: w * 0.52, height: h * 0.44),
          fill,
        );
        // Mata & kumis putih
        final whitePaint = Paint()..color = Colors.white..style = PaintingStyle.fill;
        canvas.drawCircle(Offset(w * 0.41, h * 0.52), w * 0.04, whitePaint);
        canvas.drawCircle(Offset(w * 0.59, h * 0.52), w * 0.04, whitePaint);
        final whisker = Paint()
          ..color = Colors.white
          ..strokeWidth = w * 0.03
          ..strokeCap = StrokeCap.round;
        canvas.drawLine(Offset(w * 0.22, h * 0.54), Offset(w * 0.34, h * 0.56), whisker);
        canvas.drawLine(Offset(w * 0.22, h * 0.61), Offset(w * 0.34, h * 0.60), whisker);
        canvas.drawLine(Offset(w * 0.78, h * 0.54), Offset(w * 0.66, h * 0.56), whisker);
        canvas.drawLine(Offset(w * 0.78, h * 0.61), Offset(w * 0.66, h * 0.60), whisker);
        break;

      case PetAvatarKind.pawPrint:
        // Bantalan utama
        canvas.drawOval(
          Rect.fromCenter(center: Offset(w * 0.5, h * 0.63), width: w * 0.36, height: h * 0.28),
          fill,
        );
        // 4 jari kaki kucing
        canvas.drawCircle(Offset(w * 0.29, h * 0.45), w * 0.075, fill);
        canvas.drawCircle(Offset(w * 0.42, h * 0.34), w * 0.075, fill);
        canvas.drawCircle(Offset(w * 0.58, h * 0.34), w * 0.075, fill);
        canvas.drawCircle(Offset(w * 0.71, h * 0.45), w * 0.075, fill);
        break;

      case PetAvatarKind.catEars:
        // Siluet telinga kucing + bando lengkung
        final ears = Path()
          ..moveTo(w * 0.24, h * 0.66)
          ..quadraticBezierTo(w * 0.24, h * 0.50, w * 0.28, h * 0.28)
          ..lineTo(w * 0.43, h * 0.44)
          ..quadraticBezierTo(w * 0.50, h * 0.42, w * 0.57, h * 0.44)
          ..lineTo(w * 0.72, h * 0.28)
          ..quadraticBezierTo(w * 0.76, h * 0.50, w * 0.76, h * 0.66);
        canvas.drawPath(ears, stroke);
        canvas.drawCircle(Offset(w * 0.5, h * 0.63), w * 0.045, fill);
        break;

      case PetAvatarKind.fishSnack:
        // Badan ikan + ekor
        final fish = Path()
          ..moveTo(w * 0.24, h * 0.5)
          ..quadraticBezierTo(w * 0.46, h * 0.28, w * 0.66, h * 0.5)
          ..quadraticBezierTo(w * 0.46, h * 0.72, w * 0.24, h * 0.5)
          ..close();
        canvas.drawPath(fish, fill);
        final tail = Path()
          ..moveTo(w * 0.63, h * 0.5)
          ..lineTo(w * 0.78, h * 0.36)
          ..lineTo(w * 0.78, h * 0.64)
          ..close();
        canvas.drawPath(tail, fill);
        canvas.drawCircle(Offset(w * 0.34, h * 0.47), w * 0.035, Paint()..color = Colors.white);
        break;

      case PetAvatarKind.yarnBall:
        // Bola benang mainan kucing
        canvas.drawCircle(Offset(w * 0.5, h * 0.5), w * 0.24, stroke);
        canvas.drawArc(
          Rect.fromCircle(center: Offset(w * 0.5, h * 0.5), radius: w * 0.22),
          0.2,
          2.4,
          false,
          stroke,
        );
        canvas.drawArc(
          Rect.fromCircle(center: Offset(w * 0.5, h * 0.5), radius: w * 0.22),
          3.4,
          2.2,
          false,
          stroke,
        );
        final tailThread = Path()
          ..moveTo(w * 0.68, h * 0.66)
          ..quadraticBezierTo(w * 0.80, h * 0.76, w * 0.74, h * 0.82);
        canvas.drawPath(tailThread, stroke);
        break;

      case PetAvatarKind.petHeart:
        // Hati dengan jejak kaki kecil di tengah
        final heart = Path()
          ..moveTo(w * 0.5, h * 0.74)
          ..cubicTo(w * 0.20, h * 0.56, w * 0.22, h * 0.30, w * 0.38, h * 0.30)
          ..cubicTo(w * 0.46, h * 0.30, w * 0.50, h * 0.38, w * 0.50, h * 0.40)
          ..cubicTo(w * 0.50, h * 0.38, w * 0.54, h * 0.30, w * 0.62, h * 0.30)
          ..cubicTo(w * 0.78, h * 0.30, w * 0.80, h * 0.56, w * 0.5, h * 0.74)
          ..close();
        canvas.drawPath(heart, fill);
        final whiteDot = Paint()..color = Colors.white;
        canvas.drawCircle(Offset(w * 0.5, h * 0.54), w * 0.055, whiteDot);
        canvas.drawCircle(Offset(w * 0.43, h * 0.45), w * 0.028, whiteDot);
        canvas.drawCircle(Offset(w * 0.50, h * 0.42), w * 0.028, whiteDot);
        canvas.drawCircle(Offset(w * 0.57, h * 0.45), w * 0.028, whiteDot);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _PetAvatarPainter oldDelegate) =>
      oldDelegate.kind != kind || oldDelegate.color != color;
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    required this.name,
    required this.email,
    required this.phone,
    required this.isLoggedIn,
    this.avatarIndex,
    this.avatarImagePath,
    this.onTapAvatar,
    super.key,
  });

  final String name;
  final String email;
  final String phone;
  final bool isLoggedIn;
  final int? avatarIndex;
  final String? avatarImagePath;
  final VoidCallback? onTapAvatar;

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
                GestureDetector(
                  onTap: onTapAvatar,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _buildAvatar(displayName),
                      if (onTapAvatar != null)
                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.white,
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 14,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                    ],
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
  Widget _buildAvatar(String displayName) {
    if (avatarImagePath != null && avatarImagePath!.isNotEmpty) {
      if (kIsWeb) {
        return CircleAvatar(
          radius: 48,
          backgroundImage: NetworkImage(avatarImagePath!),
          backgroundColor: const Color(0xFFF2E9E7),
        );
      }
      final file = File(avatarImagePath!);
      if (file.existsSync()) {
        return CircleAvatar(
          radius: 48,
          backgroundImage: FileImage(file),
          backgroundColor: const Color(0xFFF2E9E7),
        );
      }
    }

    if (avatarIndex != null &&
        avatarIndex! >= 0 &&
        avatarIndex! < kProfileAvatarTemplates.length) {
      return PetAvatarArtwork(
        template: kProfileAvatarTemplates[avatarIndex!],
        size: 96,
      );
    }

    return CircleAvatar(
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
