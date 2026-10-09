import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/auth/login_page.dart';
import 'package:app_rere_petshop/services/api_service.dart';
import 'package:app_rere_petshop/services/auth_service.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});
  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _api = ApiService();
  final _auth = AuthService();
  bool _loading = true;
  String? _error;
  Map<String, dynamic> _cart = {};

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      if (!await _auth.hasAuthToken()) {
        if (!mounted) return;
        final loggedIn = await Navigator.push<bool>(context, MaterialPageRoute(builder: (_) => const LoginPage()));
        if (loggedIn != true) { setState(() { _loading = false; _error = 'Masuk untuk melihat keranjang.'; }); return; }
      }
      final cart = await _api.getCart();
      if (mounted) setState(() { _cart = cart; _loading = false; });
    } catch (e) { if (mounted) setState(() { _error = e.toString(); _loading = false; }); }
  }

  @override
  Widget build(BuildContext context) {
    final items = (_cart['items'] as List? ?? const []).cast<dynamic>();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Keranjang'), backgroundColor: AppColors.white),
      body: _loading 
        ? const Center(
            child: CircularProgressIndicator(color: AppColors.primary)
          )
          : _error != null 
            ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24), 
                child: Column(
                  mainAxisSize: MainAxisSize.min, 
                  children: [
                    Text(_error!, textAlign: TextAlign.center), 
                    const SizedBox(height: 12), 
                    ElevatedButton(
                      onPressed: _load, 
                      child: const Text('Coba Lagi'),
                      ),
                    ],
                  ),
                ),
              )
          : items.isEmpty ? const Center(child: Text('Keranjang belanja kamu kosong.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: items.length + 1,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                if (index == items.length) {
                  final total = num.tryParse(_cart['total']?.toString() ?? '') ?? 0;
                  return Card(child: Padding(padding: const EdgeInsets.all(16), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [const Text('Total', style: TextStyle(fontWeight: FontWeight.bold)), Text('Rp ${total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary))])));
                }
                final item = Map<String, dynamic>.from(items[index] as Map);
                final product = Map<String, dynamic>.from(item['produk'] as Map? ?? {});
                final qty = item['qty'] ?? 1;
                final name = product['nama_produk']?.toString() ?? 'Produk';
                final amount = num.tryParse(item['subtotal']?.toString() ?? '') ?? 0;
                return Card(child: ListTile(leading: const CircleAvatar(backgroundColor: AppColors.greyBg, child: Icon(Icons.pets, color: AppColors.primary)), title: Text(name, maxLines: 2, overflow: TextOverflow.ellipsis), subtitle: Text('Jumlah: $qty'), trailing: Text('Rp ${amount.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w600))));
              },
            ),
    );
  }
}
