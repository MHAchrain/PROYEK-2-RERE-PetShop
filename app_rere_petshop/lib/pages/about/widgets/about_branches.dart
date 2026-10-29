import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/about/about_data.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutBranches extends StatelessWidget {
  const AboutBranches({super.key});

  Future<void> _openMaps(BuildContext context, AboutBranch branch) async {
    final target = branch.mapsUrl.trim().isNotEmpty
        ? Uri.parse(branch.mapsUrl.trim())
        : Uri.https('www.google.com', '/maps/search/', {'api': '1', 'query': branch.address});
    final opened = await launchUrl(target, mode: LaunchMode.externalApplication);
    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Maps tidak bisa dibuka.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Cabang Kami', style: TextStyle(fontSize: 19,
              fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const SizedBox(height: 5),
          const Text(
            'Temukan lokasi ReRe Petshop terdekat untuk kebutuhan anabul kamu.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary, height: 1.5),
          ),
          const SizedBox(height: 12),
          for (var index = 0; index < aboutBranches.length; index++)
            _branchCard(context, aboutBranches[index], index + 1),
        ]),
      );

  Widget _branchCard(BuildContext context, AboutBranch branch, int index) => Container(
        margin: const EdgeInsets.only(bottom: 11),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.divider),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: const Icon(Icons.storefront_outlined, color: AppColors.primary),
            ),
            const SizedBox(width: 11),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(branch.name, style: const TextStyle(fontSize: 14,
                  fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
              const SizedBox(height: 3),
              Text('Cabang $index', style: const TextStyle(fontSize: 11,
                  color: AppColors.textSecondary)),
            ])),
          ]),
          const SizedBox(height: 13),
          _branchDetail(Icons.location_on_outlined, branch.address),
          const SizedBox(height: 9),
          _branchDetail(Icons.access_time_outlined, branch.hours),
          const SizedBox(height: 9),
          _branchDetail(Icons.phone_outlined, branch.phone),
          const SizedBox(height: 13),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: OutlinedButton.icon(
              onPressed: () => _openMaps(context, branch),
              icon: const Icon(Icons.map_outlined, size: 17),
              label: const Text('Buka di Google Maps'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary.withOpacity(0.25)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ]),
      );

  Widget _branchDetail(IconData icon, String text) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 12,
              color: AppColors.textSecondary, height: 1.4))),
        ],
      );
}
