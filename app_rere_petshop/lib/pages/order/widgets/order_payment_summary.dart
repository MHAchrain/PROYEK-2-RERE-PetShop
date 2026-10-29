import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/order/widgets/order_status_card.dart';
import 'package:flutter/material.dart';

class OrderPaymentSummary extends StatelessWidget {
  const OrderPaymentSummary({
    required this.subtotal,
    required this.total,
    required this.paymentMethod,
    super.key,
  });

  final num subtotal;
  final num total;
  final String? paymentMethod;

  @override
  Widget build(BuildContext context) => orderCard(Column(children: [
        _amountRow('Subtotal Produk', _rupiah(subtotal)),
        const SizedBox(height: 8),
        _amountRow('Total Pembayaran', _rupiah(total), bold: true),
        if (paymentMethod != null) ...[
          const SizedBox(height: 8),
          _amountRow('Metode', paymentMethod!),
        ],
      ]));

  Widget _amountRow(String label, String value, {bool bold = false}) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: bold ? AppColors.primary : AppColors.textPrimary)),
        ],
      );

  String _rupiah(num amount) => 'Rp${amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (_) => '.',
      )}';
}
