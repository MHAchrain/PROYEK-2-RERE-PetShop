import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_rere_petshop/components/pet_loading_indicator.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/auth/login_page.dart';
import 'package:app_rere_petshop/pages/about/about_page.dart';
import 'package:app_rere_petshop/pages/profil/alamat_pengiriman_page.dart';
import 'package:app_rere_petshop/pages/profil/data_pribadi_page.dart';
import 'package:app_rere_petshop/pages/profil/pusat_bantuan_page.dart';
import 'package:app_rere_petshop/pages/profil/wishlist_page.dart';
import 'package:app_rere_petshop/pages/profil/widgets/profile_header.dart';
import 'package:app_rere_petshop/pages/profil/widgets/profile_menu_section.dart';
import 'package:app_rere_petshop/pages/profil/widgets/profile_menu_tile.dart';
import 'package:app_rere_petshop/providers/auth_provider.dart';
import 'package:app_rere_petshop/providers/wishlist_provider.dart';
import 'package:app_rere_petshop/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
  int? _avatarIndex;
  String? _avatarImagePath;

  String get _name =>
      (_user['name'] ?? _customer['nama'] ?? _customer['nama_pelanggan'])
          ?.toString() ??
      'Pelanggan';

  String get _email => (_user['email'] ?? _customer['email'])?.toString() ?? '';
  String get _phone =>
      (_customer['no_hp'] ?? _customer['telepon'])?.toString() ?? '';

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
    await _loadSavedAvatar();
  }

  Future<void> _loadSavedAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final keyPrefix = await _auth.getCurrentUserKey();
    final type = prefs.getString('${keyPrefix}_avatar_type');
    final value = prefs.getString('${keyPrefix}_avatar_value');
    if (!mounted) return;
    setState(() {
      if (type == 'template' && value != null) {
        _avatarIndex = int.tryParse(value);
        _avatarImagePath = null;
      } else if (type == 'gallery' && value != null) {
        _avatarImagePath = value;
        _avatarIndex = null;
      } else {
        _avatarIndex = null;
        _avatarImagePath = null;
      }
    });
  }

  Future<void> _saveAvatarTemplate(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final keyPrefix = await _auth.getCurrentUserKey();
    await prefs.setString('${keyPrefix}_avatar_type', 'template');
    await prefs.setString('${keyPrefix}_avatar_value', '$index');
    if (!mounted) return;
    setState(() {
      _avatarIndex = index;
      _avatarImagePath = null;
    });
  }

  Future<void> _pickAvatarFromGallery() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
      maxWidth: 600,
    );
    if (picked == null) return;
    final prefs = await SharedPreferences.getInstance();
    final keyPrefix = await _auth.getCurrentUserKey();
    await prefs.setString('${keyPrefix}_avatar_type', 'gallery');
    await prefs.setString('${keyPrefix}_avatar_value', picked.path);
    if (!mounted) return;
    setState(() {
      _avatarImagePath = picked.path;
      _avatarIndex = null;
    });
  }

  Future<void> _resetAvatar() async {
    final prefs = await SharedPreferences.getInstance();
    final keyPrefix = await _auth.getCurrentUserKey();
    await prefs.remove('${keyPrefix}_avatar_type');
    await prefs.remove('${keyPrefix}_avatar_value');
    if (!mounted) return;
    setState(() {
      _avatarIndex = null;
      _avatarImagePath = null;
    });
  }

  Future<void> _openAvatarPicker() async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetCtx) {
        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Pilih Foto Profil',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 14),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: kProfileAvatarTemplates.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 1.0,
                  ),
                  itemBuilder: (_, i) {
                    final tpl = kProfileAvatarTemplates[i];
                    final selected =
                        _avatarImagePath == null && _avatarIndex == i;
                    return GestureDetector(
                      onTap: () async {
                        Navigator.pop(sheetCtx);
                        await _saveAvatarTemplate(i);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.primary.withValues(alpha: 0.06)
                              : const Color(0xFFFAF8F7),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected
                                ? AppColors.primary
                                : const Color(0xFFE5E7EB),
                            width: selected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            PetAvatarArtwork(template: tpl, size: 52),
                            const SizedBox(height: 6),
                            Text(
                              tpl.label,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: selected
                                    ? AppColors.primary
                                    : AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),
                OutlinedButton.icon(
                  onPressed: () async {
                    Navigator.pop(sheetCtx);
                    await _pickAvatarFromGallery();
                  },
                  icon: const Icon(Icons.photo_library_outlined),
                  label: const Text('Pilih dari Galeri'),
                ),
                if (_avatarIndex != null || _avatarImagePath != null) ...[
                  const SizedBox(height: 6),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(sheetCtx);
                      await _resetAvatar();
                    },
                    child: const Text('Gunakan Inisial Nama'),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
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
          ? const PetLoadingIndicator(
              message: 'Memuat profil kamu...',
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
                      avatarIndex: _avatarIndex,
                      avatarImagePath: _avatarImagePath,
                      onTapAvatar: _loggedIn ? _openAvatarPicker : null,
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
                          onTap: _loggedIn ? _openPersonalData : _openLogin,
                        ),
                        ProfileMenuTile(
                          icon: Icons.location_on_outlined,
                          title: 'Alamat Pengiriman',
                          onTap: _loggedIn ? _openShippingAddress : _openLogin,
                        ),
                        ProfileMenuTile(
                          icon: Icons.favorite_border,
                          title: 'Wishlist',
                          showDivider: false,
                          onTap: _openWishlist,
                        ),
                      ],
                    ),
                    ProfileMenuSection(
                      title: 'Bantuan & Informasi',
                      children: [
                        ProfileMenuTile(
                          icon: Icons.help_outline,
                          title: 'Pusat Bantuan',
                          onTap: _openHelp,
                        ),
                        ProfileMenuTile(
                          icon: Icons.info_outline,
                          title: 'Tentang ReRe Petshop',
                          showDivider: false,
                          onTap: _openAbout,
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
    if (result == true) {
      await _loadProfile();
      if (!mounted) return;
      await context.read<WishlistProvider>().load(force: true);
    }
  }

  Future<void> _openWishlist() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const WishlistPage()),
    );
    if (!mounted) return;
    await context.read<WishlistProvider>().load(force: true);
  }

  Future<void> _openPersonalData() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const DataPribadiPage()),
    );
    if (saved == true) await _refreshAccountData();
  }

  Future<void> _openShippingAddress() async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AlamatPengirimanPage()),
    );
    if (saved == true) await _refreshAccountData();
  }

  Future<void> _refreshAccountData() async {
    await _loadProfile();
    if (mounted) await context.read<AuthProvider>().refreshProfile();
  }

  void _openHelp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PusatBantuanPage()),
    );
  }

  void _openAbout() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AboutPage()),
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

    try {
      await GoogleSignIn().signOut();
    } catch (_) {}

    await _auth.logout();
    if (!mounted) return;
    context.read<WishlistProvider>().reset();
    await context.read<AuthProvider>().refreshProfile();
    setState(() {
      _loggedIn = false;
      _user = {};
      _customer = {};
    });
  }
}
