import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/order/widgets/order_status_card.dart';
import 'package:flutter/material.dart';

class OrderAddressSection extends StatelessWidget {
  const OrderAddressSection({required this.address, required this.phone, super.key});
  final String address;
  final String phone;

  @override
  Widget build(BuildContext context) => orderCard(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OrderSectionHeading(icon: Icons.location_on_outlined, title: 'Alamat Pengiriman'),
          const SizedBox(height: 8),
          Text(address),
          if (phone.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(phone, style: const TextStyle(color: AppColors.textSecondary)),
          ],
        ],
      ));
}
