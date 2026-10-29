import 'dart:convert';

import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:flutter/material.dart';

class OrderHistoryCard extends StatelessWidget {
  const OrderHistoryCard({
    required this.order,
    required this.onDetails,
    this.onTrack,
    super.key,
  });

  final Map<String, dynamic> order;
  final VoidCallback onDetails;
  final VoidCallback? onTrack;

  @override
  Widget build(BuildContext context) {
    final details = (order['details'] as List? ?? const [])
        .whereType<Map>()
        .toList();
    final payment = order['pembayaran'] as Map?;
    final shipping = order['pengiriman'] as Map?;
    final rawStatus = order['status_pesanan']?.toString() ?? 'baru';
    final status = _presentationStatus(rawStatus);
    final firstDetail = details.isEmpty ? null : details.first;
    final firstProduct = firstDetail?['produk'] as Map? ?? const {};
    final orderId = int.tryParse(order['id_pesanan']?.toString() ?? '') ?? 0;
    final title = order['kode_pesanan']?.toString() ?? 'Pesanan #$orderId';
    final totalQuantity = details.fold<int>(
      0,
      (sum, item) => sum + (int.tryParse(item['qty']?.toString() ?? '') ?? 0),
    );
    final date = _formatDate(order['tanggal_pesanan']?.toString());
    final isShipped = rawStatus == 'dikirim';

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
          Expanded(
            child: Text(title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 8),
          _statusBadge(status),
        ]),
        const SizedBox(height: 5),
        Text(
          _subtitle(rawStatus, date, payment, shipping),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
        ),
        if (firstDetail != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.greyBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(children: [
              _productImage(firstProduct),
              const SizedBox(width: 10),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(
                  firstProduct['nama_produk']?.toString() ?? 'Produk',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                if (details.length > 1)
                  Text('+${details.length - 1} produk lainnya',
                      style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                Text('Total ($totalQuantity item)',
                    style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
              ])),
              const SizedBox(width: 8),
              Text(
                _rupiah(num.tryParse(order['total']?.toString() ?? '') ?? 0),
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ]),
          ),
        ],
        const SizedBox(height: 10),
        Row(children: [
          if (isShipped && onTrack != null) ...[
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onTrack,
                icon: const Icon(Icons.local_shipping_outlined, size: 16),
                label: const Text('Lacak Pengiriman', maxLines: 1, overflow: TextOverflow.ellipsis),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.greyLight),
                  minimumSize: const Size(0, 42),
                  textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          Expanded(
            child: ElevatedButton(
              onPressed: onDetails,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(0, 42),
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                shape: const StadiumBorder(),
                textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
              ),
              child: const Text('Detail Pesanan'),
            ),
          ),
        ]),
      ]),
    );
  }

  Widget _statusBadge(String status) {
    final (label, color, background) = switch (status) {
      'diproses' => ('Diproses', Colors.red.shade800, const Color(0xFFFCECEC)),
      'dikirim' => ('Dikirim', AppColors.primary, const Color(0xFFFCECEC)),
      'selesai' => ('Selesai', AppColors.success, const Color(0xFFE9F8EF)),
      'batal' => ('Dibatalkan', AppColors.textSecondary, AppColors.greyBg),
      'baru' => ('Menunggu Bayar', Colors.orange.shade800, const Color(0xFFFFF4E5)),
      _ => (_humanize(status), AppColors.textSecondary, AppColors.greyBg),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: background, borderRadius: BorderRadius.circular(99)),
      child: Text(label, style: TextStyle(color: color, fontSize: 9, fontWeight: FontWeight.w700)),
    );
  }

  String _subtitle(String status, String date, Map? payment, Map? shipping) {
    if (status == 'dikirim' && shipping != null) {
      final courier = _courierName(shipping['kurir']?.toString());
      final tracking = shipping['resi']?.toString();
      return tracking == null || tracking.isEmpty || tracking == '-'
          ? '$courier · Dalam pengiriman'
          : '$courier · Resi: $tracking';
    }
    if (status == 'diproses' && payment?['status_bayar'] == 'paid') {
      return 'Dipesan $date · Pembayaran berhasil';
    }
    if (status == 'baru') return 'Dipesan $date · Menunggu pembayaran';
    return 'Dipesan $date';
  }

  Widget _productImage(Map product) {
    final raw = product['foto_base64']?.toString();
    if (raw != null && raw.isNotEmpty) {
      try {
        final encoded = raw.contains(',') ? raw.substring(raw.indexOf(',') + 1) : raw;
        return ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: Image.memory(
            base64Decode(encoded),
            width: 54,
            height: 54,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _imagePlaceholder(),
          ),
        );
      } catch (_) {
        return _imagePlaceholder();
      }
    }
    return _imagePlaceholder();
  }

  Widget _imagePlaceholder() => Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(9)),
        child: const Icon(Icons.pets_outlined, color: AppColors.primary),
      );

  String _courierName(String? courier) {
    if (courier == null || courier.isEmpty || courier == 'menunggu_kurir') return 'Menunggu kurir';
    return courier.replaceAll('_', ' ').split(' ').map((word) =>
        word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}').join(' ');
  }

  String _formatDate(String? value) {
    if (value == null) return 'tanggal tidak tersedia';
    final date = DateTime.tryParse(value)?.toLocal();
    if (date == null) return value;
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _humanize(String value) => value.replaceAll('_', ' ').split(' ').map((word) =>
      word.isEmpty ? word : '${word[0].toUpperCase()}${word.substring(1)}').join(' ');

  String _presentationStatus(String value) => value;

  String _rupiah(num amount) => 'Rp${amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (_) => '.',
      )}';
}
