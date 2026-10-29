import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/services/auth_service.dart';
import 'package:flutter/material.dart';

class AlamatPengirimanPage extends StatefulWidget {
  const AlamatPengirimanPage({super.key});

  @override
  State<AlamatPengirimanPage> createState() => _AlamatPengirimanPageState();
}

class _AlamatPengirimanPageState extends State<AlamatPengirimanPage> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _address = TextEditingController();
  bool _loading = true;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final result = await _auth.getCurrentUser();
      final customer = result['pelanggan'] as Map? ?? const {};
      _address.text = customer['alamat']?.toString() ?? '';
    } catch (error) {
      _error = error.toString();
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await _auth.updateCustomerProfile(address: _address.text.trim());
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) _message(error.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Alamat Pengiriman'), backgroundColor: AppColors.white),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      Text(_error!, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton(onPressed: _load, child: const Text('Coba Lagi')),
                    ]),
                  ))
                : Form(
                    key: _formKey,
                    child: ListView(padding: const EdgeInsets.all(16), children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Row(children: [
                            Icon(Icons.location_on_outlined, color: AppColors.primary),
                            SizedBox(width: 8),
                            Text('Alamat Utama', style: TextStyle(fontWeight: FontWeight.w600)),
                          ]),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _address,
                            minLines: 4,
                            maxLines: 6,
                            textCapitalization: TextCapitalization.sentences,
                            validator: (value) => (value?.trim().isEmpty ?? true)
                                ? 'Alamat pengiriman wajib diisi.'
                                : null,
                            decoration: InputDecoration(
                              hintText: 'Nama jalan, nomor rumah, kelurahan, kecamatan, kota, kode pos',
                              alignLabelWithHint: true,
                              filled: true,
                              fillColor: AppColors.greyBg,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Nomor telepon pengiriman mengikuti nomor telepon di Data Pribadi.',
                            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
                          ),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _saving ? null : _save,
                          child: _saving
                              ? const SizedBox(width: 18, height: 18,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Simpan Alamat'),
                        ),
                      ),
                    ]),
                  ),
      );

  void _message(String value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
}
