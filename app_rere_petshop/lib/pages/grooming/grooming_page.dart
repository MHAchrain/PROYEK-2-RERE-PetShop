import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/grooming/widgets/grooming_app_bar.dart';
import 'package:app_rere_petshop/pages/grooming/widgets/grooming_hero_section.dart';
import 'package:app_rere_petshop/pages/grooming/widgets/grooming_services_section.dart';
import 'package:app_rere_petshop/pages/grooming/widgets/grooming_features_section.dart';
import 'package:app_rere_petshop/pages/grooming/widgets/grooming_schedule_section.dart';
import 'package:app_rere_petshop/pages/groombook/groombook_page.dart';
import 'package:app_rere_petshop/pages/auth/login_page.dart';
import 'package:app_rere_petshop/services/auth_service.dart';

class GroomingPage extends StatelessWidget {
  const GroomingPage({super.key});

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
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _openBooking(context),
              icon: const Icon(Icons.calendar_month_outlined),
              label: const Text('Booking Grooming'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.white,
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openBooking(BuildContext context) async {
    if (!await AuthService().hasAuthToken()) {
      if (!context.mounted) return;
      final loggedIn = await Navigator.push<bool>(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      if (loggedIn != true || !context.mounted) return;
    }

    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => const GroomBookPage()),
    );
  }
}
