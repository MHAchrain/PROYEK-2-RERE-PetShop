import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class SnapPaymentPage extends StatefulWidget {
  const SnapPaymentPage({required this.url, required this.orderId, super.key});
  final String url;
  final int orderId;

  @override
  State<SnapPaymentPage> createState() => _SnapPaymentPageState();
}

class _SnapPaymentPageState extends State<SnapPaymentPage> {
  WebViewController? _controller;
  late final bool _supportedPlatform;
  int _progress = 0;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _supportedPlatform = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);
    if (!_supportedPlatform) return;

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {
          if (mounted) setState(() => _progress = progress);
        },
        onWebResourceError: (error) {
          if (error.isForMainFrame == true && mounted) {
            setState(() => _loadError =
                'Halaman pembayaran gagal dimuat. Periksa koneksi lalu coba lagi.');
          }
        },
        onNavigationRequest: (request) async {
          final uri = Uri.tryParse(request.url);
          if (uri == null) return NavigationDecision.prevent;
          if (uri.scheme == 'http' || uri.scheme == 'https') {
            return NavigationDecision.navigate;
          }
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return NavigationDecision.prevent;
        },
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Pembayaran Midtrans'),
          backgroundColor: AppColors.white,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        ),
        body: !_supportedPlatform
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'Pembayaran di dalam app tersedia di Android atau iOS. Jalankan ReRe sebagai aplikasi mobile untuk membuka Midtrans Snap.',
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            : Column(
                children: [
                  if (_progress < 100 && _loadError == null)
                    LinearProgressIndicator(
                      value: _progress / 100,
                      color: AppColors.primary,
                    ),
                  Expanded(
                    child: _loadError == null
                        ? WebViewWidget(controller: _controller!)
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.wifi_off,
                                      size: 42, color: AppColors.grey),
                                  const SizedBox(height: 12),
                                  Text(_loadError!, textAlign: TextAlign.center),
                                  const SizedBox(height: 12),
                                  ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _loadError = null;
                                        _progress = 0;
                                      });
                                      _controller?.reload();
                                    },
                                    child: const Text('Coba Lagi'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ],
              ),
      );
}
