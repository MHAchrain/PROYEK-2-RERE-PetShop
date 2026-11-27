import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';

class GroomingSnapPage extends StatefulWidget {
  const GroomingSnapPage({super.key, required this.token});

  final String token;

  @override
  State<GroomingSnapPage> createState() => _GroomingSnapPageState();
}

class _GroomingSnapPageState extends State<GroomingSnapPage> {
  WebViewController? _controller;
  bool _loading = true;
  bool _returnedFromPayment = false;

  Uri get _snapUri => Uri.parse(
      'https://app.sandbox.midtrans.com/snap/v2/vtweb/${widget.token}');

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _loading = false;
      WidgetsBinding.instance.addPostFrameCallback((_) => _openWebSnap());
      return;
    }

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
      ..loadRequest(_snapUri);
  }

  Future<void> _openWebSnap() async {
    await launchUrl(_snapUri, mode: LaunchMode.externalApplication);
  }

  void _checkPaymentReturn(String url) {
    if (_returnedFromPayment) return;
    if (url.toLowerCase().contains('example.com')) {
      _returnedFromPayment = true;
      Navigator.pop(context, 'settlement');
      return;
    }
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
        body: kIsWeb
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.payment, size: 56, color: AppColors.primary),
                      const SizedBox(height: 16),
                      const Text(
                        'Halaman pembayaran Midtrans dibuka di tab baru.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: _openWebSnap,
                        icon: const Icon(Icons.open_in_new),
                        label: const Text('Buka Pembayaran'),
                      ),
                      const SizedBox(height: 10),
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context, 'pending'),
                        child: const Text('Selesai / Cek Status'),
                      ),
                    ],
                  ),
                ),
              )
            : Stack(
                children: [
                  if (_controller != null) WebViewWidget(controller: _controller!),
                  if (_loading)
                    const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    ),
                ],
              ),
      );
}
