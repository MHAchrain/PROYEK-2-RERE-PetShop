import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'snap_payment_web.dart' if (dart.library.io) 'snap_payment_stub.dart' as platform_snap;

class SnapPaymentPage extends StatefulWidget {
  const SnapPaymentPage({
    required this.url,
    this.snapToken,
    required this.orderId,
    super.key,
  });

  final String url;
  final String? snapToken;
  final int orderId;

  @override
  State<SnapPaymentPage> createState() => _SnapPaymentPageState();
}

class _SnapPaymentPageState extends State<SnapPaymentPage> {
  WebViewController? _controller;
  late final bool _isMobileWebview;
  int _progress = 0;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _isMobileWebview = !kIsWeb &&
        (defaultTargetPlatform == TargetPlatform.android ||
            defaultTargetPlatform == TargetPlatform.iOS);

    if (kIsWeb) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerWebSnap();
      });
      return;
    }

    if (_isMobileWebview) {
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
  }

  void _triggerWebSnap() {
    final token = widget.snapToken;
    if (token != null && token.isNotEmpty) {
      platform_snap.openSnapWeb(
        snapToken: token,
        onSuccess: (result) {
          if (mounted) {
            Navigator.pop(context, true);
          }
        },
        onPending: (result) {
          if (mounted) {
            Navigator.pop(context, true);
          }
        },
        onError: (result) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Pembayaran gagal atau dibatalkan.')),
            );
          }
        },
        onClose: () {
          if (mounted) {
            Navigator.pop(context, false);
          }
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pembayaran Midtrans Snap'),
        backgroundColor: AppColors.white,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
      body: kIsWeb
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.payment_rounded,
                        color: AppColors.primary,
                        size: 48,
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Menampilkan Midtrans Snap...',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Selesaikan pembayaran Anda pada popup Midtrans Snap yang muncul.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Buka Ulang Snap'),
                      onPressed: _triggerWebSnap,
                    ),
                  ],
                ),
              ),
            )
          : !_isMobileWebview
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.payment,
                            size: 48, color: AppColors.primary),
                        const SizedBox(height: 16),
                        const Text(
                          'Buka Pembayaran Midtrans',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () => launchUrl(
                            Uri.parse(widget.url),
                            mode: LaunchMode.externalApplication,
                          ),
                          child: const Text('Buka di Browser'),
                        ),
                      ],
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
                                    Text(_loadError!,
                                        textAlign: TextAlign.center),
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
}
