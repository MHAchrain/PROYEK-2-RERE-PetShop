import 'package:app_rere_petshop/pages/order/widgets/order_status_card.dart';
import 'package:flutter/material.dart';

class OrderShippingSection extends StatelessWidget {
  const OrderShippingSection({required this.shipping, required this.statusLabel, super.key});
  final Map? shipping;
  final String Function(String?) statusLabel;

  @override
  Widget build(BuildContext context) => orderCard(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OrderSectionHeading(icon: Icons.local_shipping_outlined, title: 'Pengiriman'),
          const SizedBox(height: 8),
          Text(shipping == null
              ? 'Menunggu konfirmasi toko'
              : '${shipping!['kurir'] ?? 'Kurir'} · ${statusLabel(shipping!['status_kirim']?.toString())}'),
          if ((shipping?['resi']?.toString() ?? '').isNotEmpty)
            Text('No. resi: ${shipping!['resi']}'),
        ],
      ));
}
