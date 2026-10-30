import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_formatters.dart';
import 'package:flutter/material.dart';

class GroomingHistoryCard extends StatelessWidget {
  const GroomingHistoryCard({
    required this.booking,
    required this.onDetails,
    super.key,
  });

  final Map<String, dynamic> booking;
  final VoidCallback onDetails;

  @override
  Widget build(BuildContext context) {
    final code = '${booking['kodeBooking'] ?? 'Booking #${booking['id'] ?? ''}'}';
    final dateValue = '${booking['date'] ?? ''}';
    final date = DateTime.tryParse(dateValue);
    final dateLabel = date == null ? dateValue : GroomingBookingFormatters.longDate(date.toLocal());
    final time = '${booking['time'] ?? ''}';
    final petName = '${booking['petName'] ?? 'Hewan'}';
    final service = '${booking['serviceName'] ?? 'Grooming'}';
    final status = '${booking['status'] ?? 'menunggu_pembayaran'}';
    final price = GroomingBookingFormatters.number(booking['price']);
    final (statusLabel, statusColor, statusBackground) = _statusStyle(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Expanded(child: Text(code, maxLines: 1, overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700))),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: statusBackground, borderRadius: BorderRadius.circular(99)),
            child: Text(statusLabel, style: TextStyle(color: statusColor, fontSize: 9, fontWeight: FontWeight.w700)),
          ),
        ]),
        const SizedBox(height: 5),
        Text('Booking Grooming · $dateLabel${time.isEmpty ? '' : ' · $time'}',
            maxLines: 1, overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(color: AppColors.greyBg, borderRadius: BorderRadius.circular(12)),
          child: Row(children: [
            Container(
              width: 54, height: 54,
              decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(9)),
              child: const Icon(Icons.pets_outlined, color: AppColors.primary),
            ),
            const SizedBox(width: 10),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(petName, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              Text(service, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              Text('${booking['petType'] ?? ''}', maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
            ])),
            const SizedBox(width: 8),
            Text(GroomingBookingFormatters.rupiah(price),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
          ]),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onDetails,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 42),
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              shape: const StadiumBorder(),
              textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
            child: const Text('Detail Booking'),
          ),
        ),
      ]),
    );
  }

  (String, Color, Color) _statusStyle(String status) => switch (status) {
        'menunggu_pembayaran' => ('Menunggu Bayar', Colors.orange.shade800, const Color(0xFFFFF4E5)),
        'terjadwal' => ('Terjadwal', AppColors.primary, const Color(0xFFFCECEC)),
        'dikonfirmasi' => ('Dikonfirmasi', Colors.blue.shade700, const Color(0xFFEAF3FF)),
        'selesai' => ('Selesai', AppColors.success, const Color(0xFFE9F8EF)),
        'dibatalkan' => ('Dibatalkan', AppColors.textSecondary, AppColors.greyBg),
        'gagal' => ('Gagal', Colors.red.shade800, const Color(0xFFFCECEC)),
        _ => (_humanize(status), AppColors.textSecondary, AppColors.greyBg),
      };

  String _humanize(String value) => value.replaceAll('_', ' ').split(' ').map((word) =>
      word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}').join(' ');
}
