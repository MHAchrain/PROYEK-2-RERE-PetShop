import 'dart:convert';

import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/constants/app_constants.dart';
import 'package:app_rere_petshop/pages/order/widgets/order_status_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class OrderProductSection extends StatelessWidget {
  const OrderProductSection({required this.details, super.key});
  final List details;

  @override
  Widget build(BuildContext context) => orderCard(Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const OrderSectionHeading(icon: Icons.inventory_2_outlined, title: 'Produk'),
          const SizedBox(height: 12),
          for (final raw in details) _productRow(raw as Map),
        ],
      ));

  Widget _productRow(Map item) {
    final product = item['produk'] as Map? ?? const {};
    final qty = int.tryParse(item['qty']?.toString() ?? '') ?? 0;
    final subtotal = num.tryParse(item['subtotal']?.toString() ?? '') ?? 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        _productImage(product),
        const SizedBox(width: 10),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(product['nama_produk']?.toString() ?? 'Produk', maxLines: 2,
              overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text('$qty item', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ])),
        Text(_rupiah(subtotal), style: const TextStyle(fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _productImage(Map product) {
    final base64Image = product['foto_base64']?.toString();
    if (base64Image != null && base64Image.isNotEmpty) {
      try {
        final encoded = base64Image.contains(',')
            ? base64Image.substring(base64Image.indexOf(',') + 1)
            : base64Image;
        return ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(
            base64Decode(encoded),
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _placeholder(),
          ),
        );
      } catch (_) {
        // Fall back to the image endpoint below if the inline data is invalid.
      }
    }

    final foto = product['foto']?.toString();
    if (foto != null && foto.isNotEmpty) {
      final imageUrl = foto.startsWith('http://') || foto.startsWith('https://')
          ? foto
          : '${AppConstants.baseUrl}/image/${foto.split('/').map((part) => Uri.encodeComponent(part)).join('/')}';
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          placeholder: (_, __) => _placeholder(),
          errorWidget: (_, __, ___) => _placeholder(),
        ),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.greyBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.pets_outlined, color: AppColors.primary),
      );

  String _rupiah(num amount) => 'Rp${amount.toStringAsFixed(0).replaceAllMapped(
        RegExp(r'\B(?=(\d{3})+(?!\d))'),
        (_) => '.',
      )}';
}
