import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class PusatBantuanPage extends StatelessWidget {
  const PusatBantuanPage({super.key});

  Future<void> _openLink(BuildContext context, Uri uri) async {
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Aplikasi untuk membuka tautan tidak ditemukan.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(title: const Text('Pusat Bantuan'), backgroundColor: AppColors.white),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider),
              ),
              child: const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(Icons.support_agent_outlined, color: AppColors.primary, size: 30),
                SizedBox(height: 12),
                Text('Ada yang bisa kami bantu?',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                SizedBox(height: 6),
                Text('Hubungi tim ReRe Petshop melalui salah satu kanal berikut.',
                    style: TextStyle(color: AppColors.textSecondary)),
              ]),
            ),
            const SizedBox(height: 12),
            _contactTile(
              context,
              icon: Icons.chat_outlined,
              title: 'WhatsApp',
              detail: AppConstants.whatsappNumber,
              onTap: () => _openLink(
                context,
                Uri.parse('https://wa.me/${AppConstants.whatsappNumber}'),
              ),
            ),
            const SizedBox(height: 10),
            _contactTile(
              context,
              icon: Icons.email_outlined,
              title: 'Email',
              detail: AppConstants.email,
              onTap: () => _openLink(
                context,
                Uri(scheme: 'mailto', path: AppConstants.email),
              ),
            ),
          ],
        ),
      );

  Widget _contactTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String detail,
    required VoidCallback onTap,
  }) => Card(
        color: AppColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.divider),
        ),
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: AppColors.primary),
          title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Text(detail),
          trailing: const Icon(Icons.open_in_new, size: 18, color: AppColors.grey),
        ),
      );
}
