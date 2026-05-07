// lib/presentation/screens/contact/contact_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
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
            _buildContactCard(),
            const SizedBox(height: 16),

            // Form pesan
            _buildMessageForm(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Hubungi langsung
          _contactItem(
            icon: Icons.phone_outlined,
            title: 'Hubungi Kami',
            subtitle: 'Nomor Telepon: 0813-1941-0250',
            description:
                'Hubungi kami saat jam operasional untuk informasi stok, pesanan, dan layanan grooming.',
            onTap: _callPhone,
            buttonLabel: 'Telepon',
            buttonIcon: Icons.phone,
          ),
          const Divider(height: 24),

          // WhatsApp
          _contactItem(
            icon: Icons.chat_outlined,
            title: 'WhatsApp',
            subtitle: '0813-1941-0250',
            description: 'Chat kami via WhatsApp untuk respons lebih cepat.',
            onTap: _openWhatsApp,
            buttonLabel: 'Buka WhatsApp',
            buttonIcon: Icons.send,
          ),
          const Divider(height: 24),

          // Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.location_on_outlined,
                    color: AppColors.primary, size: 22),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Alamat Toko',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        )),
                    SizedBox(height: 4),
                    Text(
                      AppConstants.address,
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 13),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Email: ${AppConstants.email}',
                      style: TextStyle(
                          color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _contactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required VoidCallback onTap,
    required String buttonLabel,
    required IconData buttonIcon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  )),
              const SizedBox(height: 2),
              Text(subtitle,
                  style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(description,
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12)),
              const SizedBox(height: 10),
              SizedBox(
                height: 36,
                child: ElevatedButton.icon(
                  onPressed: onTap,
                  icon: Icon(buttonIcon, size: 16),
                  label:
                      Text(buttonLabel, style: const TextStyle(fontSize: 13)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMessageForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tulis Kepada Kami',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Isi formulir dan kami akan menghubungi Anda kembali.',
            style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          _inputField(_nameController, 'Masukkan Nama', Icons.person_outline),
          const SizedBox(height: 12),
          _inputField(_emailController, 'Masukkan Email', Icons.email_outlined,
              keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 12),
          _inputField(
              _phoneController, 'Masukkan Nomor Telepon', Icons.phone_outlined,
              keyboardType: TextInputType.phone),
          const SizedBox(height: 12),
          TextField(
            controller: _messageController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: 'Masukkan Pesan',
              hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
              filled: true,
              fillColor: AppColors.greyBg,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _sendEmail,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Kirim Pesan',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.grey, fontSize: 14),
        prefixIcon: Icon(icon, color: AppColors.grey, size: 20),
        filled: true,
        fillColor: AppColors.greyBg,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
    );
  }
}
