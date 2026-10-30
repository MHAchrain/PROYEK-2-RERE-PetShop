import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_section_title.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_surface.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_service_card.dart';

class GroomBookDetailsStep extends StatelessWidget {
  const GroomBookDetailsStep({
    super.key,
    required this.formKey,
    required this.petName,
    required this.petType,
    required this.petBreed,
    required this.petSize,
    required this.petNote,
    required this.services,
    required this.loadingServices,
    required this.selectedService,
    required this.onSelectService,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController petName;
  final TextEditingController petType;
  final TextEditingController petBreed;
  final TextEditingController petSize;
  final TextEditingController petNote;
  final List<Map<String, dynamic>> services;
  final bool loadingServices;
  final Map<String, dynamic>? selectedService;
  final ValueChanged<Map<String, dynamic>> onSelectService;

  @override
  Widget build(BuildContext context) => Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const GroomingBookingSectionTitle(
              title: 'Data Anabul',
              subtitle: 'Isi informasi hewan yang akan grooming.',
            ),
            const SizedBox(height: 14),
            GroomingBookingSurface(
              child: Column(
                children: [
                  _textField(petName, 'Nama hewan', 'Contoh: Mochi'),
                  const SizedBox(height: 12),
                  _textField(petType, 'Jenis hewan', 'Contoh: Kucing'),
                  const SizedBox(height: 12),
                  _textField(petBreed, 'Ras', 'Contoh: Persia'),
                  const SizedBox(height: 12),
                  _textField(petSize, 'Ukuran', 'Contoh: Kecil'),
                  const SizedBox(height: 12),
                  _textField(
                    petNote,
                    'Catatan tambahan (opsional)',
                    'Info khusus untuk groomer',
                    required: false,
                    maxLines: 3,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const GroomingBookingSectionTitle(
              title: 'Pilih Layanan',
              subtitle: 'Pilih paket grooming untuk anabul.',
            ),
            const SizedBox(height: 14),
            if (loadingServices)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              )
            else
              ...services.map(
                (service) => GroomingServiceCard(
                  service: service,
                  selected: '${selectedService?['id']}' == '${service['id']}',
                  onTap: () => onSelectService(service),
                ),
              ),
          ],
        ),
      );

  Widget _textField(
    TextEditingController controller,
    String label,
    String hint, {
    bool required = true,
    int maxLines = 1,
  }) => TextFormField(
        controller: controller,
        maxLines: maxLines,
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          filled: true,
          fillColor: const Color(0xFFF8F8F8),
          contentPadding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 1.4),
          ),
        ),
        validator: !required
            ? null
            : (value) => value == null || value.trim().isEmpty
                ? '$label wajib diisi.'
                : null,
      );
}
