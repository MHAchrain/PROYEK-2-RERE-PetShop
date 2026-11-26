import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_primary_button.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_spacing.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_text_field.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_typography.dart';
import 'package:app_rere_petshop/services/auth_service.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  final String? initialEmail;

  const ForgotPasswordPage({super.key, this.initialEmail});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _email;
  final _code = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();

  int _step = 0; // 0: Email, 1: OTP, 2: Password baru
  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirm = true;

  @override
  void initState() {
    super.initState();
    _email = TextEditingController(text: widget.initialEmail ?? '');
  }

  @override
  void dispose() {
    _email.dispose();
    _code.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    super.dispose();
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? AppColors.primary : null,
        ),
      );
  }

  Future<void> _sendCode() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final msg = await _auth.sendResetCode(_email.text.trim());
      if (!mounted) return;
      _showMessage(msg);
      setState(() => _step = 1);
    } catch (e) {
      _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _verifyCode() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final msg = await _auth.verifyResetCode(
        email: _email.text.trim(),
        code: _code.text.trim(),
      );
      if (!mounted) return;
      _showMessage(msg);
      setState(() => _step = 2);
    } catch (e) {
      _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      final msg = await _auth.resetPassword(
        email: _email.text.trim(),
        code: _code.text.trim(),
        password: _password.text,
        passwordConfirmation: _confirmPassword.text,
      );
      if (!mounted) return;
      _showMessage(msg);
      Navigator.pop(context, true);
    } catch (e) {
      _showMessage(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String get _subtitle {
    switch (_step) {
      case 1:
        return 'Masukkan 6 digit kode OTP yang telah dikirim ke ${_email.text.trim()}';
      case 2:
        return 'Buat kata sandi baru untuk akun Anda';
      default:
        return 'Masukkan email terdaftar untuk menerima kode OTP reset kata sandi';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Lupa Kata Sandi'),
        backgroundColor: AppColors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AuthSpacing.x6),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  _subtitle,
                  style: const TextStyle(
                    fontSize: AuthTypography.helper,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: AuthSpacing.x6),
            if (_step == 0) ...[
              AuthTextField(
                controller: _email,
                label: 'Email',
                hint: 'Masukkan email Anda',
                keyboardType: TextInputType.emailAddress,
                icon: Icons.email_outlined,
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Email wajib diisi';
                  if (!v.contains('@')) return 'Format email tidak valid';
                  return null;
                },
              ),
              const SizedBox(height: AuthSpacing.x6),
              AuthPrimaryButton(
                label: 'Kirim Kode OTP',
                loading: _loading,
                onPressed: _sendCode,
              ),
            ] else if (_step == 1) ...[
              AuthTextField(
                controller: _code,
                label: 'Kode OTP (6 Digit)',
                hint: 'Masukkan 6 digit kode OTP',
                keyboardType: TextInputType.number,
                icon: Icons.verified_user_outlined,
                validator: (value) {
                  final v = value?.trim() ?? '';
                  if (v.isEmpty) return 'Kode OTP wajib diisi';
                  if (v.length != 6) return 'Kode OTP harus 6 digit';
                  return null;
                },
              ),
              const SizedBox(height: AuthSpacing.x3),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _loading ? null : _sendCode,
                  child: const Text(
                    'Kirim Ulang Kode OTP',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: AuthTypography.helper,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AuthSpacing.x4),
              AuthPrimaryButton(
                label: 'Verifikasi Kode',
                loading: _loading,
                onPressed: _verifyCode,
              ),
            ] else ...[
              AuthTextField(
                controller: _password,
                label: 'Kata Sandi Baru',
                hint: 'Minimal 6 karakter',
                obscureText: _obscurePassword,
                icon: Icons.lock_outline,
                onVisibilityPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Kata sandi baru wajib diisi';
                  }
                  if (value.length < 6) {
                    return 'Kata sandi minimal 6 karakter';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AuthSpacing.x4),
              AuthTextField(
                controller: _confirmPassword,
                label: 'Konfirmasi Kata Sandi Baru',
                hint: 'Ulangi kata sandi baru',
                obscureText: _obscureConfirm,
                icon: Icons.lock_outline,
                onVisibilityPressed: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Konfirmasi kata sandi wajib diisi';
                  }
                  if (value != _password.text) {
                    return 'Konfirmasi kata sandi tidak cocok';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AuthSpacing.x6),
              AuthPrimaryButton(
                label: 'Simpan Kata Sandi Baru',
                loading: _loading,
                onPressed: _resetPassword,
              ),
            ],
          ],
        ),
          ),
        ),
      ),
    );
  }
}
