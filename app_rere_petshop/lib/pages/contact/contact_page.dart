// lib/presentation/screens/contact/contact_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/constants/app_constants.dart';
import 'package:app_rere_petshop/pages/contact/widgets/contact_methods_card.dart';
import 'package:app_rere_petshop/pages/contact/widgets/contact_message_form.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _messageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _callPhone() async {
    final url = Uri.parse('tel:${AppConstants.whatsappNumber}');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  Future<void> _openWhatsApp() async {
    final url = Uri.parse('https://wa.me/${AppConstants.whatsappNumber}');
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _sendEmail() async {
    final name = _nameController.text.trim();
    final message = _messageController.text.trim();
    if (name.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama dan pesan wajib diisi')),
      );
      return;
    }

    final subject = Uri.encodeComponent('Pesan dari $name - ReRe Petshop App');
    final body = Uri.encodeComponent(
      'Nama: $name\nEmail: ${_emailController.text}\nTelp: ${_phoneController.text}\n\nPesan:\n$message',
    );
    final url =
        Uri.parse('mailto:${AppConstants.email}?subject=$subject&body=$body');
    if (await canLaunchUrl(url)) await launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 1,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'KONTAK',
              style: TextStyle(
                fontSize: 10,
                color: AppColors.primary,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Text(
              'Hubungi Kami',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Deskripsi
            const Text(
              'Kalau ada pertanyaan soal produk, pesanan, atau grooming, tim ReRe Petshop siap membantu dengan jawaban yang cepat dan jelas.',
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),

            // Card Kontak Langsung
            ContactMethodsCard(onCall: _callPhone, onWhatsApp: _openWhatsApp),
            const SizedBox(height: 16),

            // Form pesan
            ContactMessageForm(
              nameController: _nameController,
              emailController: _emailController,
              phoneController: _phoneController,
              messageController: _messageController,
              onSend: _sendEmail,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
