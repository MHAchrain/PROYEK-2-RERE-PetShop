import 'dart:async';

import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/order/widgets/order_address_section.dart';
import 'package:app_rere_petshop/pages/order/widgets/order_payment_summary.dart';
import 'package:app_rere_petshop/pages/order/widgets/order_product_section.dart';
import 'package:app_rere_petshop/pages/order/widgets/order_shipping_section.dart';
import 'package:app_rere_petshop/pages/order/widgets/order_status_card.dart';
import 'package:app_rere_petshop/pages/pembayaran/snap_payment_page.dart';
import 'package:app_rere_petshop/services/api_service.dart';
import 'package:flutter/material.dart';

class OrderDetailPage extends StatefulWidget {
  const OrderDetailPage({required this.orderId, super.key});
  final int orderId;

  @override
  State<OrderDetailPage> createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  final _api = ApiService();
  Map<String, dynamic>? _order;
  bool _loading = true;
  bool _paying = false;
  String? _error;
  Timer? _poller;

  bool get _isPending =>
      (_order?['pembayaran'] as Map?)?['status_bayar'] == 'pending';

  @override
  void initState() {
    super.initState();
    _load();
    _poller = Timer.periodic(const Duration(seconds: 6), (_) {
      if (_isPending) _load(showLoading: false);
    });
  }

  Future<void> _load({bool showLoading = true}) async {
    if (showLoading && mounted) setState(() => _loading = true);
    try {
      final result = await _api.getOrder(widget.orderId);
      if (mounted) setState(() { _order = result; _error = null; });
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted && showLoading) setState(() => _loading = false);
    }
  }

  Future<void> _retryPayment() async {
    setState(() => _paying = true);
    try {
      final payment = await _api.createPayment(widget.orderId);
      if (!mounted) return;
      await Navigator.push<void>(context, MaterialPageRoute(
        builder: (_) => SnapPaymentPage(url: payment['url']!, orderId: widget.orderId),
      ));
      await _load();
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) setState(() => _paying = false);
    }
  }

  @override
  void dispose() {
    _poller?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final order = _order;
    final payment = order?['pembayaran'] as Map?;
    final details = order?['details'] as List? ?? const [];
    final status = payment?['status_bayar']?.toString() ?? 'pending';
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Detail Pesanan'),
        backgroundColor: AppColors.white,
        actions: [IconButton(onPressed: _load, icon: const Icon(Icons.refresh))],
      ),
      body: _body(order, payment, details, status),
      bottomNavigationBar: order != null && status != 'paid' && order['status_pesanan'] != 'batal'
          ? SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _paying ? null : _retryPayment,
                    icon: _paying
                        ? const SizedBox(width: 17, height: 17,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Icon(Icons.lock_outline),
                    label: Text(_paying ? 'Memuat Pembayaran...' : 'Bayar Sekarang'),
                  ),
                ),
              ),
            )
          : null,
    );
  }

  Widget _body(Map<String, dynamic>? order, Map? payment, List details, String status) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null && order == null) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_error!, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _load, child: const Text('Coba Lagi')),
        ]),
      ));
    }
    if (order == null) return const SizedBox.shrink();

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          OrderStatusCard(
            orderCode: 'Pesanan ${order['kode_pesanan'] ?? '#${order['id_pesanan']}'}',
            orderStatus: _label(order['status_pesanan']?.toString()),
            paymentStatus: status,
          ),
          const SizedBox(height: 12),
          OrderProductSection(details: details),
          const SizedBox(height: 12),
          OrderAddressSection(
            address: order['alamat_kirim']?.toString() ?? '-',
            phone: order['no_telp']?.toString() ?? '',
          ),
          const SizedBox(height: 12),
          OrderShippingSection(
            shipping: order['pengiriman'] as Map?,
            statusLabel: _label,
          ),
          const SizedBox(height: 12),
          OrderPaymentSummary(
            subtotal: _amount(details),
            total: num.tryParse(order['total']?.toString() ?? '') ?? 0,
            paymentMethod: payment?['metode_bayar']?.toString(),
          ),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text('Status belum berhasil diperbarui: $_error',
                  style: const TextStyle(color: AppColors.primary)),
            ),
          const SizedBox(height: 88),
        ],
      ),
    );
  }

  num _amount(List details) => details.fold<num>(
        0,
        (sum, raw) => sum + (num.tryParse((raw as Map)['subtotal']?.toString() ?? '') ?? 0),
      );

  String _label(String? value) => (value ?? 'Belum tersedia')
      .replaceAll('_', ' ')
      .split(' ')
      .map((part) => part.isEmpty ? part : '${part[0].toUpperCase()}${part.substring(1)}')
      .join(' ');
}
