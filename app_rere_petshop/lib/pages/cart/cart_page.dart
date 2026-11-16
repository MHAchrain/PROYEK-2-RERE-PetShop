import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/auth/login_page.dart';
import 'package:app_rere_petshop/pages/cart/cart_controller.dart';
import 'package:app_rere_petshop/pages/cart/widgets/cart_bottom_bar.dart';
import 'package:app_rere_petshop/pages/cart/widgets/cart_product_list.dart';
import 'package:app_rere_petshop/pages/cart/widgets/cart_selection_header.dart';
import 'package:app_rere_petshop/pages/cart/widgets/cart_status_view.dart';
import 'package:app_rere_petshop/pages/checkout/checkout_page.dart';
import 'package:app_rere_petshop/providers/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  final _cart = CartController();
  bool? _lastLoggedIn;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cart.load(context));
  }

  void refresh() {
    if (mounted) {
      _cart.load(context);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final isLoggedIn = context.watch<AuthProvider>().isLoggedIn;
    if (_lastLoggedIn != null && _lastLoggedIn != isLoggedIn && isLoggedIn) {
      _cart.load(context);
    }
    _lastLoggedIn = isLoggedIn;
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
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => CheckoutPage(
                                items: items
                                    .where((item) => _cart.selectedIds.contains(
                                        int.tryParse(item['id_item']?.toString() ?? '')))
                                    .toList(),
                              ),
                            ),
                          ).then((_) {
                            if (mounted) _cart.load(context);
                          }),
                )
              : null,
        );
      },
    );
  }

  Widget _buildBody(List<Map<String, dynamic>> items, bool busy) {
    if (_cart.isLoading) return const CartStatusView.loading();

    return RefreshIndicator(
      onRefresh: () => _cart.load(context),
      child: _buildScrollableContent(items, busy),
    );
  }

  Widget _buildScrollableContent(List<Map<String, dynamic>> items, bool busy) {
    if (_cart.isNotLoggedIn) {
      return CartStatusView.error(
        'Masuk untuk melihat isi keranjang belanja kamu.',
        onRetry: () => _cart.load(context),
        actionButton: ElevatedButton(
          onPressed: () async {
            final loggedIn = await Navigator.push<bool>(
              context,
              MaterialPageRoute(builder: (_) => const LoginPage()),
            );
            if (loggedIn == true && mounted) {
              _cart.load(context);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: const Text('Masuk Sekarang'),
        ),
      );
    }
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
