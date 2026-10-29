import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/constants/app_constants.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_footer_link.dart';
import 'package:app_rere_petshop/pages/auth/widgets/google_sign_in_button.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_header.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_info_section.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_primary_button.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_spacing.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_typography.dart';
import 'package:app_rere_petshop/pages/auth/widgets/auth_text_field.dart';
import 'package:app_rere_petshop/providers/auth_provider.dart';
import 'package:app_rere_petshop/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirmPassword = TextEditingController();
  final _phone = TextEditingController();
  final _address = TextEditingController();
  final _auth = AuthService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId: kIsWeb ? AppConstants.googleClientId : null,
    serverClientId: kIsWeb ? null : AppConstants.googleClientId,
    scopes: ['email', 'profile'],
  );
  bool _isRegister = false;
  bool _loading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _rememberMe = false;
  bool _acceptedTerms = false;

  Future<void> _handleGoogleSignIn() async {
    setState(() => _loading = true);
    try {
      final account = await _googleSignIn.signIn();
      if (account == null) {
        // User membatalkan dialog login
        return;
      }
      final auth = await account.authentication;
      final token = auth.accessToken ?? auth.idToken;
      if (token == null || token.isEmpty) {
        throw Exception('Gagal mendapatkan token Google.');
      }

      await _auth.loginWithGoogle(token);
      if (mounted) await context.read<AuthProvider>().refreshProfile();
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) _showMessage('Login Google gagal: ${e.toString()}');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isRegister && !_acceptedTerms) {
      _showMessage('Setujui Syarat & Ketentuan untuk melanjutkan.');
      return;
    }
    setState(() => _loading = true);
    try {
      if (_isRegister) {
        await _auth.register(
          name: _name.text.trim(),
          email: _email.text.trim(),
          password: _password.text,
          phone: _phone.text,
          address: _address.text,
        );
        if (!mounted) return;
        _switchMode(false);
        _showMessage('Pendaftaran berhasil. Silakan masuk.');
      } else {
        await _auth.login(_email.text.trim(), _password.text);
        if (mounted) await context.read<AuthProvider>().refreshProfile();
        if (mounted) Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) _showMessage(e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _switchMode(bool register) {
    setState(() {
      _isRegister = register;
      _password.clear();
      _confirmPassword.clear();
      _acceptedTerms = false;
      _formKey.currentState?.reset();
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return 'Email wajib diisi';
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      return 'Masukkan email yang valid';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Kata sandi wajib diisi';
    if (_isRegister && value.length < 6) return 'Minimal 6 karakter';
    return null;
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    _confirmPassword.dispose();
    _phone.dispose();
    _address.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          AuthHeader(isRegister: _isRegister),
          Expanded(child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(AuthSpacing.x6, AuthSpacing.x6, AuthSpacing.x6, AuthSpacing.x8),
            child: Form(key: _formKey, child: _isRegister ? _registerForm() : _loginForm()),
          )),
        ]),
      ),
    );
  }

  Widget _loginForm() => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text('Selamat Datang Kembali', style: TextStyle(fontSize: AuthTypography.screenTitle, fontWeight: FontWeight.w800, letterSpacing: -.5)),
    const SizedBox(height: AuthSpacing.x2),
    const Text('Silakan masuk untuk melanjutkan pesanan Anda.', style: TextStyle(color: AppColors.textSecondary, fontSize: AuthTypography.helper, fontWeight: FontWeight.w500)),
    const SizedBox(height: AuthSpacing.x6),
    AuthTextField(controller: _email, label: 'Email', hint: 'Masukkan email Anda', icon: Icons.mail_outline_rounded, keyboardType: TextInputType.emailAddress, validator: _validateEmail),
    const SizedBox(height: AuthSpacing.x4),
    AuthTextField(controller: _password, label: 'Kata Sandi', hint: 'Masukkan kata sandi Anda', icon: Icons.lock_outline_rounded, obscureText: _obscurePassword, onVisibilityPressed: () => setState(() => _obscurePassword = !_obscurePassword), validator: _validatePassword),
    const SizedBox(height: AuthSpacing.x2),
    Row(children: [
      Checkbox(value: _rememberMe, visualDensity: VisualDensity.compact, activeColor: AppColors.primary, onChanged: _loading ? null : (value) => setState(() => _rememberMe = value ?? false)),
      const Text('Ingat saya', style: TextStyle(fontSize: AuthTypography.helper, fontWeight: FontWeight.w500, color: AppColors.textSecondary)),
      const Spacer(),
      TextButton(onPressed: null, child: Text('Lupa Kata Sandi?', style: TextStyle(color: AppColors.primary, fontSize: AuthTypography.helper, fontWeight: FontWeight.w700))),
    ]),
    const SizedBox(height: AuthSpacing.x6),
    AuthPrimaryButton(label: 'Masuk', loading: _loading, onPressed: _submit),
    const SizedBox(height: AuthSpacing.x5),
    const Row(children: [
      Expanded(child: Divider(color: Color(0xFFE8EAED))),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: AuthSpacing.x3),
        child: Text('Atau masuk dengan', style: TextStyle(color: AppColors.textSecondary, fontSize: AuthTypography.helper)),
      ),
      Expanded(child: Divider(color: Color(0xFFE8EAED))),
    ]),
    const SizedBox(height: AuthSpacing.x5),
    GoogleSignInButton(
      onPressed: _loading ? null : _handleGoogleSignIn,
    ),
    const SizedBox(height: AuthSpacing.x6),
    AuthFooterLink(prompt: 'Belum punya akun?', action: 'Daftar', onTap: _loading ? null : () => _switchMode(true)),
  ]);

  Widget _registerForm() => Column(children: [
    AuthInfoSection(title: 'Informasi Pribadi', icon: Icons.badge_outlined, child: Column(children: [
      AuthTextField(controller: _name, label: 'Nama Lengkap', hint: 'Masukkan nama lengkap', icon: Icons.person_outline_rounded, textCapitalization: TextCapitalization.words, validator: (value) => value == null || value.trim().isEmpty ? 'Nama lengkap wajib diisi' : null),
      const SizedBox(height: AuthSpacing.x4),
      AuthTextField(controller: _phone, label: 'Nomor Handphone', hint: 'Masukkan nomor handphone', icon: Icons.phone_outlined, keyboardType: TextInputType.phone, validator: (value) => value == null || value.trim().isEmpty ? 'Nomor handphone wajib diisi' : null),
      const SizedBox(height: AuthSpacing.x4),
      AuthTextField(controller: _address, label: 'Alamat', hint: 'Masukkan alamat lengkap', icon: Icons.location_on_outlined, textCapitalization: TextCapitalization.sentences, maxLines: 3, validator: (value) => value == null || value.trim().isEmpty ? 'Alamat wajib diisi' : null),
    ])),
    const SizedBox(height: AuthSpacing.x4),
    AuthInfoSection(title: 'Informasi Akun', icon: Icons.lock_outline_rounded, child: Column(children: [
      AuthTextField(controller: _email, label: 'Email', hint: 'Masukkan email aktif', icon: Icons.mail_outline_rounded, keyboardType: TextInputType.emailAddress, validator: _validateEmail),
      const SizedBox(height: AuthSpacing.x4),
      AuthTextField(controller: _password, label: 'Kata Sandi', hint: 'Buat kata sandi', icon: Icons.lock_outline_rounded, obscureText: _obscurePassword, onVisibilityPressed: () => setState(() => _obscurePassword = !_obscurePassword), validator: _validatePassword),
      const SizedBox(height: AuthSpacing.x4),
      AuthTextField(controller: _confirmPassword, label: 'Konfirmasi Kata Sandi', hint: 'Ulangi kata sandi', icon: Icons.lock_outline_rounded, obscureText: _obscureConfirmPassword, onVisibilityPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword), validator: (value) => value != _password.text ? 'Kata sandi belum sama' : null),
    ])),
    const SizedBox(height: AuthSpacing.x3),
    Container(
      padding: const EdgeInsets.symmetric(horizontal: AuthSpacing.x2, vertical: AuthSpacing.x2),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AuthSpacing.x3), border: Border.all(color: const Color(0xFFF0F0F0))),
      child: CheckboxListTile(contentPadding: EdgeInsets.zero, controlAffinity: ListTileControlAffinity.leading, dense: true, value: _acceptedTerms, activeColor: AppColors.primary, onChanged: _loading ? null : (value) => setState(() => _acceptedTerms = value ?? false), title: const Text('Saya menyetujui Syarat & Ketentuan serta Kebijakan Privasi ReRe Petshop.', style: TextStyle(fontSize: AuthTypography.helper, fontWeight: FontWeight.w600, color: AppColors.textSecondary))),
    ),
    const SizedBox(height: AuthSpacing.x4),
    AuthPrimaryButton(label: 'Daftar Sekarang', loading: _loading, onPressed: _submit),
    const SizedBox(height: AuthSpacing.x5),
    AuthFooterLink(prompt: 'Sudah punya akun?', action: 'Masuk', onTap: _loading ? null : () => _switchMode(false)),
  ]);
}
