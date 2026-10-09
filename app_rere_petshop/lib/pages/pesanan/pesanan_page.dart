import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/pesanan/widgets/pesanan_placeholder.dart';

class PesananPage extends StatelessWidget {
  const PesananPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Pesanan'), backgroundColor: AppColors.white),
      body: const PesananPlaceholder(),
    );
  }
}
