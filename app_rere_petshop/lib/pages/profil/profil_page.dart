import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/profil/widgets/profil_placeholder.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Profil'), backgroundColor: AppColors.white),
      body: const ProfilPlaceholder(),
    );
  }
}
