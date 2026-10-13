import 'package:app_rere_petshop/models/product_model.dart';
import 'package:app_rere_petshop/pages/cart/widgets/cart_guarantee_card.dart';
import 'package:app_rere_petshop/pages/cart/widgets/cart_item_tile.dart';
import 'package:flutter/material.dart';

class CartProductList extends StatelessWidget {
  const CartProductList({
    required this.items,
    required this.selectedItemIds,
    required this.updatingItemIds,
    required this.isUpdating,
    required this.onItemSelected,
    required this.onDecrease,
    required this.onIncrease,
    super.key,
  });

  final List<Map<String, dynamic>> items;
  final Set<int> selectedItemIds;
  final Set<int> updatingItemIds;
  final bool isUpdating;
  final void Function(int id, bool selected) onItemSelected;
  final void Function(Map<String, dynamic> item) onDecrease;
  final void Function(Map<String, dynamic> item) onIncrease;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: items.length + 1,
      separatorBuilder: (_, __) => const Divider(
        height: 1,
        indent: 16,
        endIndent: 16,
        color: Color(0xFFF0F0F0),
      ),
      itemBuilder: (context, index) {
        if (index == items.length) return const CartGuaranteeCard();

        final item = items[index];
        final itemId = int.tryParse(item['id_item']?.toString() ?? '');
        final productJson = Map<String, dynamic>.from(
          item['produk'] as Map? ?? const {},
        );
        final product = Product.fromJson(productJson);
        final quantity = int.tryParse(item['qty']?.toString() ?? '') ?? 1;
        final unitPrice = _unitPrice(item, quantity);
        final itemIsUpdating = itemId != null && updatingItemIds.contains(itemId);

        return CartItemTile(
          name: product.name,
          imageUrl: product.image,
          unitPrice: unitPrice,
          quantity: quantity,
          selected: itemId != null && selectedItemIds.contains(itemId),
          enabled: !isUpdating && !itemIsUpdating,
          onSelected: itemId == null
              ? null
              : (selected) => onItemSelected(itemId, selected),
          onDecrease: isUpdating || itemIsUpdating ? null : () => onDecrease(item),
          onIncrease: isUpdating || itemIsUpdating ? null : () => onIncrease(item),
        );
      },
    );
  }

  num _unitPrice(Map<String, dynamic> item, int quantity) {
    final storedPrice = num.tryParse(item['harga_satuan']?.toString() ?? '');
    if (storedPrice != null) return storedPrice;
    if (quantity <= 0) return 0;
    return (num.tryParse(item['subtotal']?.toString() ?? '') ?? 0) / quantity;
  }
}
