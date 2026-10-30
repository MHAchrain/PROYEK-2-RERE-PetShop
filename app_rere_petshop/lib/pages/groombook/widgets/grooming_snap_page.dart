import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';

class GroomingSnapPage extends StatefulWidget {
  const GroomingSnapPage({super.key, required this.token});

  final String token;

  @override
  State<GroomingSnapPage> createState() => _GroomingSnapPageState();
}

class _GroomingSnapPageState extends State<GroomingSnapPage> {
  late final WebViewController _controller;
  bool _loading = true;
  bool _returnedFromPayment = false;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: _checkPaymentReturn,
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
        ),
      )
      ..loadRequest(
        Uri.parse('https://app.sandbox.midtrans.com/snap/v2/vtweb/${widget.token}'),
      );
  }

  void _checkPaymentReturn(String url) {
    if (_returnedFromPayment) return;
    final status = Uri.tryParse(url)?.queryParameters['transaction_status'];
    const paymentStatuses = {
      'settlement',
      'capture',
      'success',
      'pending',
      'deny',
      'cancel',
      'expire',
    };
    if (paymentStatuses.contains(status)) {
      _returnedFromPayment = true;
      Navigator.pop(context, status);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.textPrimary,
          title: const Text('Pembayaran Grooming'),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_loading)
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
          ],
        ),
      );
}
