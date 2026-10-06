import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/constants/app_constants.dart';
import 'package:app_rere_petshop/pages/grooming/widgets/grooming_app_bar.dart';
import 'package:app_rere_petshop/pages/grooming/widgets/grooming_hero_section.dart';
import 'package:app_rere_petshop/pages/grooming/widgets/grooming_services_section.dart';
import 'package:app_rere_petshop/pages/grooming/widgets/grooming_features_section.dart';
import 'package:app_rere_petshop/pages/grooming/widgets/grooming_schedule_section.dart';
import 'package:app_rere_petshop/pages/grooming/widgets/grooming_contact_cta.dart';
import 'package:app_rere_petshop/pages/grooming/widgets/grooming_contact_button.dart';

class GroomingPage extends StatelessWidget {
  const GroomingPage({super.key});

  Future<void> _contactWhatsApp() async {
    final url = Uri.parse(
      'https://wa.me/${AppConstants.whatsappNumber}?text=Halo, saya tertarik dengan layanan grooming untuk hewan peliharaan saya. Mohon info lebih lanjut.',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          const GroomingAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const GroomingHeroSection(),
                const GroomingServicesSection(),
                const GroomingFeaturesSection(),
                const GroomingScheduleSection(),
                GroomingContactCta(onContact: _contactWhatsApp),
                const SizedBox(height: 80),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: GroomingContactButton(onContact: _contactWhatsApp),
    );
  }
}
