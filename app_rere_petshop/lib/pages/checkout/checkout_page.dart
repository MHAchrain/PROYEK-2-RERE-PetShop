import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/order/order_detail_page.dart';
import 'package:app_rere_petshop/pages/pembayaran/snap_payment_page.dart';
import 'package:app_rere_petshop/services/api_service.dart';
import 'package:app_rere_petshop/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:app_rere_petshop/providers/cart_provider.dart';
import 'package:provider/provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({required this.items, super.key});
  final List<Map<String, dynamic>> items;

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _api = ApiService();
  final _auth = AuthService();
  final _address = TextEditingController();
  final _phone = TextEditingController();
  bool _loadingProfile = true;
  bool _submitting = false;
  int? _createdOrderId;
  String? _profileError;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      final result = await _auth.getCurrentUser();
      final customer = result['pelanggan'] as Map? ?? const {};
      _address.text = customer['alamat']?.toString() ?? '';
      _phone.text = customer['no_hp']?.toString() ?? '';
    } catch (error) {
      _profileError = error.toString();
    } finally {
      if (mounted) setState(() => _loadingProfile = false);
    }
  }

  num get _subtotal => widget.items.fold<num>(
        0,
        (sum, item) => sum + (num.tryParse(item['subtotal']?.toString() ?? '') ?? 0),
      );

  Future<void> _pay() async {
    if (_address.text.trim().isEmpty || _phone.text.trim().isEmpty) {
      _message('Isi alamat dan nomor telepon untuk melanjutkan.');
      return;
    }
    setState(() => _submitting = true);
    try {
      final orderId = _createdOrderId ?? await _createOrder();
      _createdOrderId = orderId;
      final payment = await _api.createPayment(orderId);
      if (!mounted) return;
      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (_) => SnapPaymentPage(
            url: payment['url']!,
            orderId: orderId,
          ),
        ),
      );
      if (!mounted) return;
      await Navigator.pushReplacement<void, void>(
        context,
        MaterialPageRoute(builder: (_) => OrderDetailPage(orderId: orderId)),
      );
    } catch (error) {
      if (mounted) _message(error.toString());
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<int> _createOrder() async {
    final order = await _api.createOrder(
      itemIds: widget.items
          .map((item) => int.tryParse(item['id_item']?.toString() ?? ''))
          .whereType<int>()
          .toList(),
      address: _address.text.trim(),
      phone: _phone.text.trim(),
    );
    final orderId = int.parse(order['id_pesanan'].toString());
    _createdOrderId = orderId;
    if (mounted) context.read<CartProvider>().refreshCount();
    return orderId;
  }

  @override
  void dispose() {
    _address.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Checkout'), backgroundColor: AppColors.white),
      body: _loadingProfile
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                _section(
                  icon: Icons.location_on_outlined,
                  title: 'Alamat Pengiriman',
                  child: Column(children: [
                    _field(_address, 'Alamat lengkap', Icons.home_outlined, maxLines: 3),
                    const SizedBox(height: 10),
                    _field(_phone, 'Nomor telepon', Icons.phone_outlined,
                        keyboardType: TextInputType.phone),
                    if (_profileError != null) ...[
                      const SizedBox(height: 8),
                      Text('Profil tidak termuat: $_profileError',
                          style: const TextStyle(color: AppColors.primary, fontSize: 12)),
                    ],
                  ]),
                ),
                const SizedBox(height: 12),
                _section(
                  icon: Icons.storefront_outlined,
                  title: 'Produk (${widget.items.length})',
                  child: Column(
                    children: [
                      for (final item in widget.items) _itemRow(item),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                _section(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Metode Pembayaran',
                  child: const ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.verified_user_outlined, color: AppColors.primary),
                    title: Text('Midtrans Snap'),
                    subtitle: Text('Transfer bank, QRIS, dan e-wallet'),
                    trailing: Icon(Icons.check_circle, color: AppColors.success),
                  ),
                ),
                const SizedBox(height: 12),
                _section(
                  icon: Icons.receipt_long_outlined,
                  title: 'Rincian Pembayaran',
                  child: Column(children: [
                    _amountRow('Subtotal Produk', _subtotal),
                    const SizedBox(height: 8),
                    _amountRow('Total Pembayaran', _subtotal, bold: true),
                    const SizedBox(height: 4),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Ongkir dihitung oleh toko setelah pesanan dibuat.',
                          style: TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                    ),
                  ]),
                ),
              ],
            ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
          decoration: const BoxDecoration(color: AppColors.white,
              border: Border(top: BorderSide(color: AppColors.divider))),
          child: Row(children: [
            Expanded(child: Column(mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text('Total Tagihan', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
              Text(_rupiah(_subtotal), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 19, color: AppColors.primary)),
            ])),
            SizedBox(height: 48, child: ElevatedButton.icon(
              onPressed: _submitting || _loadingProfile ? null : _pay,
              icon: _submitting
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Icon(Icons.lock_outline, size: 18),
              label: Text(_submitting ? 'Memproses...' : 'Bayar Sekarang'),
            )),
          ]),
        ),
      ),
    );
  }

  Widget _section({required IconData icon, required String title, required Widget child}) =>
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Icon(icon, color: AppColors.primary, size: 20), const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600))]),
          const SizedBox(height: 14), child,
        ]),
      );

  Widget _field(TextEditingController controller, String label, IconData icon,
          {int maxLines = 1, TextInputType? keyboardType}) =>
      TextField(
        controller: controller, maxLines: maxLines, keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon),
          filled: true, fillColor: AppColors.greyBg,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
      );

  Widget _itemRow(Map<String, dynamic> item) {
    final product = item['produk'] as Map? ?? const {};
    final name = product['nama_produk']?.toString() ?? 'Produk';
    final qty = int.tryParse(item['qty']?.toString() ?? '') ?? 1;
    final subtotal = num.tryParse(item['subtotal']?.toString() ?? '') ?? 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Container(width: 56, height: 56, alignment: Alignment.center,
          decoration: BoxDecoration(color: AppColors.greyBg, borderRadius: BorderRadius.circular(10)),
          child: const Icon(Icons.pets_outlined, color: AppColors.primary)),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w500)),
          Text('$qty item', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
        ])),
        Text(_rupiah(subtotal), style: const TextStyle(fontWeight: FontWeight.w600)),
      ]),
    );
  }

  Widget _amountRow(String label, num amount, {bool bold = false}) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.normal)),
      Text(_rupiah(amount), style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
          color: bold ? AppColors.primary : AppColors.textPrimary))],
  );

  String _rupiah(num amount) => 'Rp${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => '.')}';
  void _message(String value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
}
