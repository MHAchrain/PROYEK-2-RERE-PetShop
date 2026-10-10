import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/cart/cart_controller.dart';
import 'package:app_rere_petshop/pages/cart/widgets/cart_bottom_bar.dart';
import 'package:app_rere_petshop/pages/cart/widgets/cart_product_list.dart';
import 'package:app_rere_petshop/pages/cart/widgets/cart_selection_header.dart';
import 'package:app_rere_petshop/pages/cart/widgets/cart_status_view.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _cart = CartController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cart.load(context));
  }

  @override
  void dispose() {
    _cart.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _cart,
      builder: (context, _) {
        final items = _cart.items;
        final busy = _cart.isDeleting || _cart.updatingItemIds.isNotEmpty;

        return Scaffold(
          backgroundColor: AppColors.white,
          appBar: AppBar(
            title: const Text('Keranjang'),
            backgroundColor: AppColors.white,
            surfaceTintColor: Colors.transparent,
          ),
          body: _buildBody(items, busy),
          bottomNavigationBar: !_cart.isLoading &&
                  _cart.error == null &&
                  items.isNotEmpty
              ? CartBottomBar(
                  total: _cart.selectedTotal,
                  selectedProductCount: _cart.selectedIds.length,
                  isBusy: busy,
                  onCheckout: _cart.selectedIds.isEmpty
                      ? null
                      : () => _showMessage(
                            'Checkout akan dilanjutkan setelah halaman checkout tersedia.',
                          ),
                )
              : null,
        );
      },
    );
  }

  Widget _buildBody(List<Map<String, dynamic>> items, bool busy) {
    if (_cart.isLoading) return const CartStatusView.loading();
    if (_cart.error != null) {
      return CartStatusView.error(
        _cart.error!,
        onRetry: () => _cart.load(context),
      );
    }
    if (items.isEmpty) {
      return const CartStatusView.message('Keranjang belanja kamu kosong.');
    }

    return Column(
      children: [
        CartSelectionHeader(
          allSelected: _cart.selectedIds.length == items.length,
          isBusy: busy,
          hasSelection: _cart.selectedIds.isNotEmpty,
          onSelectAll: _cart.toggleAll,
          onDelete: () => _runAction(_cart.deleteSelected()),
        ),
        Expanded(
          child: CartProductList(
            items: items,
            selectedItemIds: _cart.selectedItemIds,
            updatingItemIds: _cart.updatingItemIds,
            isUpdating: _cart.isDeleting,
            onItemSelected: _cart.toggleItem,
            onDecrease: (item) => _changeQuantity(item, -1),
            onIncrease: (item) => _changeQuantity(item, 1),
          ),
        ),
      ],
    );
  }

  Future<void> _changeQuantity(Map<String, dynamic> item, int delta) async {
    await _runAction(_cart.changeQuantity(item, delta));
  }

  Future<void> _runAction(Future<String?> action) async {
    final message = await action;
    if (message != null) _showMessage(message);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
