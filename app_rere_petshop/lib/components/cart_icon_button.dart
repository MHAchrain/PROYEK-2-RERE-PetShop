import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/cart/cart_page.dart';
import 'package:app_rere_petshop/providers/cart_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Icon keranjang dengan badge jumlah item.
///
/// Dipakai di AppBar (kanan icon notifikasi) karena tab keranjang
/// di bottom navigation sudah dihapus.
class CartIconButton extends StatelessWidget {
  const CartIconButton({this.color, super.key});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? AppColors.textPrimary;

    return Consumer<CartProvider>(
      builder: (context, cart, _) {
        return IconButton(
          tooltip: 'Keranjang',
          onPressed: () {
            cart.refreshCount();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const CartPage()),
            );
          },
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(Icons.shopping_cart_outlined, color: iconColor),
              if (cart.itemCount > 0)
                Positioned(
                  right: -7,
                  top: -5,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    constraints:
                        const BoxConstraints(minWidth: 16, minHeight: 16),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      cart.itemCount > 99 ? '99+' : '${cart.itemCount}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
