import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:flutter/material.dart';

class ProductActionBar extends StatelessWidget {
  const ProductActionBar({
    super.key,
    required this.isInStock,
    required this.isAddingToCart,
    required this.isBuyingNow,
    required this.onChat,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  final bool isInStock;
  final bool isAddingToCart;
  final bool isBuyingNow;
  final VoidCallback onChat;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  @override
  Widget build(BuildContext context) {
    final canPurchase = isInStock && !isAddingToCart && !isBuyingNow;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: onChat,
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: const CircleBorder(),
                  side: const BorderSide(color: Color(0xFFE5E7EB)),
                  foregroundColor: AppColors.textPrimary,
                ),
                child: const Icon(Icons.chat_bubble_outline, size: 24),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: canPurchase ? onAddToCart : null,
                icon: isAddingToCart
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.shopping_bag_outlined, size: 24),
                label: const Text('Tambah Barang', maxLines: 1),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: Color(0xFFD1D5DB)),
                  shape: const StadiumBorder(),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: canPurchase ? onBuyNow : null,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 48),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: const StadiumBorder(),
                  elevation: 2,
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                child: isBuyingNow
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Text(
                              isInStock ? 'Beli Sekarang' : 'Stok Habis',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (isInStock) ...[
                            const SizedBox(width: 5),
                            const Icon(Icons.chevron_right, size: 20),
                          ],
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
