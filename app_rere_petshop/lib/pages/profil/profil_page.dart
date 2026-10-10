import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/auth/login_page.dart';
import 'package:app_rere_petshop/pages/pesanan/pesanan_page.dart';
import 'package:app_rere_petshop/pages/profil/widgets/profile_header.dart';
import 'package:app_rere_petshop/pages/profil/widgets/profile_menu_section.dart';
import 'package:app_rere_petshop/pages/profil/widgets/profile_menu_tile.dart';
import 'package:app_rere_petshop/providers/auth_provider.dart';
import 'package:app_rere_petshop/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  final _auth = AuthService();
  Map<String, dynamic> _user = {};
  Map<String, dynamic> _customer = {};
  bool _loading = true;
  bool _loggedIn = true;

  String get _name =>
      (_user['name'] ?? _customer['nama'] ?? _customer['nama_pelanggan'])
          ?.toString() ??
      'Pelanggan';

  String get _email => (_user['email'] ?? _customer['email'])?.toString() ?? '';
  String get _phone =>
      (_customer['no_hp'] ?? _customer['telepon'])?.toString() ?? '';
  String get _address => (_customer['alamat'])?.toString() ?? '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    try {
      final hasToken = await _auth.hasAuthToken();
      if (!hasToken) {
        if (!mounted) return;
        setState(() {
          _loggedIn = false;
          _user = {};
          _customer = {};
          _loading = false;
        });
        return;
      }

      final payload = await _auth.getCurrentUser();
      if (!mounted) return;
      setState(() {
        _user = Map<String, dynamic>.from(payload['user'] as Map? ?? const {});
        _customer =
            Map<String, dynamic>.from(payload['pelanggan'] as Map? ?? const {});
        _loggedIn = true;
        _loading = false;
      });
    } catch (_) {
      final hasToken = await _auth.hasAuthToken();
      if (mounted) {
        setState(() {
          _loggedIn = hasToken;
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final providerLoggedIn = context.watch<AuthProvider>().isLoggedIn;
    if (providerLoggedIn && !_loggedIn && !_loading) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_loading) _loadProfile();
      });
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F7),
      body: _loading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : SafeArea(
              bottom: false,
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: _loadProfile,
                child: ListView(
                  padding: const EdgeInsets.only(bottom: 24),
                  children: [
                    ProfileHeader(
                      name: _name,
                      email: _email,
                      phone: _phone,
                      isLoggedIn: _loggedIn,
                    ),
                    if (!_loggedIn)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: FilledButton.icon(
                          onPressed: _openLogin,
                          icon: const Icon(Icons.login),
                          label: const Text('Masuk ke akun'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            minimumSize: const Size.fromHeight(48),
                          ),
                        ),
                      ),
                    ProfileMenuSection(
                      title: 'Akun Saya',
                      children: [
                        ProfileMenuTile(
                          icon: Icons.person_outline,
                          title: 'Data Pribadi',
                          onTap: _loggedIn ? _showProfileInfo : _openLogin,
                        ),
                        ProfileMenuTile(
                          icon: Icons.location_on_outlined,
                          title: 'Alamat Pengiriman',
                          onTap: _loggedIn ? _showAddress : _openLogin,
                        ),
                        ProfileMenuTile(
                          icon: Icons.receipt_long_outlined,
                          title: 'Pesanan Saya',
                          showDivider: false,
                          onTap: _loggedIn ? _openOrders : _openLogin,
                        ),
                      ],
                    ),
                    ProfileMenuSection(
                      title: 'Bantuan & Informasi',
                      children: [
                        ProfileMenuTile(
                          icon: Icons.help_outline,
                          title: 'Pusat Bantuan',
                          onTap: _showHelp,
                        ),
                        ProfileMenuTile(
                          icon: Icons.info_outline,
                          title: 'Tentang ReRe Petshop',
                          showDivider: false,
                          onTap: _showAbout,
                        ),
                      ],
                    ),
                    if (_loggedIn)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                        child: OutlinedButton.icon(
                          onPressed: _confirmLogout,
                          icon: const Icon(Icons.logout),
                          label: const Text('Keluar dari akun'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            minimumSize: const Size.fromHeight(48),
                            side: const BorderSide(color: Color(0xFFE5CACA)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _openLogin() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
    if (result == true) await _loadProfile();
  }

  void _openOrders() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PesananPage()),
    );
  }

  void _showProfileInfo() {
    _showDetails(
      'Data Pribadi',
      [
        _DetailRow('Nama', _name),
        _DetailRow('Email', _email),
        _DetailRow('Nomor telepon', _phone),
      ],
    );
  }

  void _showAddress() {
    _showDetails('Alamat Pengiriman', [_DetailRow('Alamat', _address)]);
  }

  void _showDetails(String title, List<_DetailRow> details) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.white,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              ...details.map(
                (detail) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(detail.label,
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.textSecondary)),
                      const SizedBox(height: 4),
                      Text(
                        detail.value.isEmpty ? 'Belum diisi' : detail.value,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showHelp() {
    _showDialog(
      'Pusat Bantuan',
      'Butuh bantuan? Hubungi tim ReRe Petshop melalui kanal layanan pelanggan yang tersedia.',
    );
  }

  void _showAbout() {
    _showDialog(
      'Tentang ReRe Petshop',
      'ReRe Petshop menyediakan kebutuhan hewan kesayangan dan layanan untuk merawat mereka.',
    );
  }

  void _showDialog(String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar dari akun?'),
        content: const Text('Kamu perlu masuk lagi untuk mengakses profil.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Keluar'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    await _auth.logout();
    if (!mounted) return;
    await context.read<AuthProvider>().refreshProfile();
    setState(() {
      _loggedIn = false;
      _user = {};
      _customer = {};
    });
  }
}

class _DetailRow {
  const _DetailRow(this.label, this.value);

  final String label;
  final String value;
}
