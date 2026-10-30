import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_surface.dart';

class BookingResultHeader extends StatelessWidget {
  const BookingResultHeader({
    super.key,
    required this.status,
    required this.bookingCode,
    required this.createdAt,
  });

  final String status;
  final String bookingCode;
  final String? createdAt;

  bool get _success =>
      status == 'terjadwal' || status == 'dikonfirmasi' || status == 'selesai';

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const SizedBox(height: 14),
          Icon(
            _success ? Icons.check_circle : Icons.receipt_long_outlined,
            color: _success ? const Color(0xFF22C55E) : AppColors.primary,
            size: 58,
          ),
          const SizedBox(height: 12),
          Text(
            _success ? 'Booking Berhasil!' : 'Detail Booking Grooming',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _success
                ? 'Jadwal grooming anabul sudah tercatat di ReRe Petshop.'
                : 'Status terbaru booking grooming anabul kamu.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textSecondary,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          GroomingBookingSurface(
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'KODE BOOKING',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                          letterSpacing: .4,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        bookingCode,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      if (createdAt != null) ...[
                        const SizedBox(height: 5),
                        Text(
                          'Dibuat ${_formatCreatedAt(createdAt!)}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    await Clipboard.setData(ClipboardData(text: bookingCode));
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Kode booking disalin.')),
                    );
                  },
                  icon: const Icon(Icons.copy, size: 16),
                  label: const Text('Salin'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: Color(0xFFE5E5E5)),
                    shape: const StadiumBorder(),
                  ),
                ),
              ],
            ),
          ),
        ],
      );

  static String _formatCreatedAt(String value) {
    final parsed = DateTime.tryParse(value)?.toLocal();
    if (parsed == null) return value;
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des',
    ];
    return '${parsed.day} ${months[parsed.month - 1]} ${parsed.year} · ${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}';
  }
}
