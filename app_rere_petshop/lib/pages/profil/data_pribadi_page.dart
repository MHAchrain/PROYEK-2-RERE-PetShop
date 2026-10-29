import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/services/auth_service.dart';
import 'package:flutter/material.dart';

class DataPribadiPage extends StatefulWidget {
  const DataPribadiPage({super.key});

  @override
  State<DataPribadiPage> createState() => _DataPribadiPageState();
}

class _DataPribadiPageState extends State<DataPribadiPage> {
  final _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
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
      final user = result['user'] as Map? ?? const {};
      final customer = result['pelanggan'] as Map? ?? const {};
      _name.text = (customer['nama'] ?? user['name'] ?? '').toString();
      _email.text = (customer['email'] ?? user['email'] ?? '').toString();
      _phone.text = (customer['no_hp'] ?? '').toString();
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
      await _auth.updateCustomerProfile(
        name: _name.text.trim(),
        phone: _phone.text.trim(),
      );
      if (mounted) Navigator.pop(context, true);
    } catch (error) {
      if (mounted) _message(error.toString());
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Data Pribadi'), backgroundColor: AppColors.white),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? _loadError()
                : Form(
                    key: _formKey,
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _field(
                          controller: _name,
                          label: 'Nama lengkap',
                          icon: Icons.person_outline,
                          validator: (value) => (value?.trim().isEmpty ?? true)
                              ? 'Nama lengkap wajib diisi.'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        _field(
                          controller: _email,
                          label: 'Email',
                          icon: Icons.email_outlined,
                          readOnly: true,
                          helperText: 'Email belum bisa diubah.',
                        ),
                        const SizedBox(height: 14),
                        _field(
                          controller: _phone,
                          label: 'Nomor telepon',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          validator: (value) => (value?.length ?? 0) > 15
                              ? 'Nomor telepon maksimal 15 karakter.'
                              : null,
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _saving ? null : _save,
                            child: _saving
                                ? const SizedBox(width: 18, height: 18,
                                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                                : const Text('Simpan Perubahan'),
                          ),
                        ),
                      ],
                    ),
                  ),
      );

  Widget _field({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    String? helperText,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) => TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          helperText: helperText,
          prefixIcon: Icon(icon),
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide.none),
        ),
      );

  Widget _loadError() => Center(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_error!, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _load, child: const Text('Coba Lagi')),
        ]),
      ));

  void _message(String value) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value)));
}
