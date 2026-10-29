import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:flutter/material.dart';

class OrderStatusCard extends StatelessWidget {
  const OrderStatusCard({
    required this.orderCode,
    required this.orderStatus,
    required this.paymentStatus,
    super.key,
  });

  final String orderCode;
  final String orderStatus;
  final String paymentStatus;

  @override
  Widget build(BuildContext context) {
    final color = switch (paymentStatus) {
      'paid' => AppColors.success,
      'failed' => AppColors.primary,
      _ => Colors.orange.shade800,
    };
    final icon = switch (paymentStatus) {
      'paid' => Icons.check_circle_outline,
      'failed' => Icons.error_outline,
      _ => Icons.schedule,
    };
    final label = switch (paymentStatus) {
      'paid' => 'Pembayaran berhasil',
      'failed' => 'Pembayaran gagal atau kedaluwarsa',
      _ => 'Menunggu pembayaran',
    };
    return orderCard(Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(orderCode, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
      const SizedBox(height: 12),
      Row(children: [
        Icon(icon, color: color),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600))),
      ]),
      const SizedBox(height: 8),
      Text('Status pesanan: $orderStatus', style: const TextStyle(color: AppColors.textSecondary)),
    ]));
  }
}

Widget orderCard(Widget child) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: child,
    );

class OrderSectionHeading extends StatelessWidget {
  const OrderSectionHeading({required this.icon, required this.title, super.key});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) => Row(children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
      ]);
}
