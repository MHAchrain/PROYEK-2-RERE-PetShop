import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_formatters.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_section_title.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_surface.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_slot_group.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_summary_card.dart';

class GroomBookScheduleStep extends StatelessWidget {
  const GroomBookScheduleStep({
    super.key,
    required this.petName,
    required this.petType,
    required this.petBreed,
    required this.service,
    required this.selectedDate,
    required this.selectedTime,
    required this.slots,
    required this.loadingSlots,
    required this.slotsError,
    required this.onSelectDate,
    required this.onPickOtherDate,
    required this.onSelectTime,
    required this.isSlotAvailable,
    required this.onEditDetails,
  });

  final String petName;
  final String petType;
  final String petBreed;
  final Map<String, dynamic>? service;
  final DateTime? selectedDate;
  final String? selectedTime;
  final List<Map<String, dynamic>> slots;
  final bool loadingSlots;
  final String? slotsError;
  final ValueChanged<DateTime> onSelectDate;
  final VoidCallback onPickOtherDate;
  final ValueChanged<String> onSelectTime;
  final bool Function(Map<String, dynamic>) isSlotAvailable;
  final VoidCallback onEditDetails;

  @override
  Widget build(BuildContext context) {
    final days = List.generate(
      7,
      (index) => DateUtils.dateOnly(DateTime.now()).add(Duration(days: index)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GroomingBookingSurface(
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFFCECEC),
                child: Icon(Icons.pets, color: AppColors.primary),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$petName · ${service?['name'] ?? ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('$petType · $petBreed', style: _metaStyle),
                  ],
                ),
              ),
              TextButton(onPressed: onEditDetails, child: const Text('Ubah')),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const GroomingBookingSectionTitle(
          title: 'Pilih Tanggal',
          subtitle: 'Pilih hari yang paling nyaman.',
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 90,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: days.length + 1,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              if (index == days.length) return _otherDateButton();
              final day = days[index];
              final selected = DateUtils.isSameDay(day, selectedDate);
              return _dateCard(day, selected);
            },
          ),
        ),
        const SizedBox(height: 22),
        GroomingBookingSectionTitle(
          title: 'Pilih Waktu',
          subtitle: selectedDate == null
              ? 'Pilih tanggal terlebih dahulu.'
              : GroomingBookingFormatters.longDate(selectedDate!),
        ),
        const SizedBox(height: 12),
        if (loadingSlots)
          const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(color: AppColors.primary),
            ),
          )
        else if (slotsError != null)
          GroomingBookingSurface(
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: AppColors.textSecondary),
                const SizedBox(width: 10),
                Expanded(child: Text(slotsError!, style: _metaStyle)),
              ],
            ),
          )
        else ...[
          GroomingSlotGroup(
            title: 'Sesi Pagi',
            subtitle: '(09:00–12:00)',
            slots: slots
                .where((slot) => GroomingBookingFormatters.hour(slot) < 12)
                .toList(),
            selectedTime: selectedTime,
            isAvailable: isSlotAvailable,
            onSelect: onSelectTime,
          ),
          const SizedBox(height: 16),
          GroomingSlotGroup(
            title: 'Sesi Siang & Sore',
            subtitle: '(13:00–17:00)',
            slots: slots
                .where((slot) => GroomingBookingFormatters.hour(slot) >= 12)
                .toList(),
            selectedTime: selectedTime,
            isAvailable: isSlotAvailable,
            onSelect: onSelectTime,
          ),
        ],
        const SizedBox(height: 22),
        const GroomingBookingSectionTitle(
          title: 'Ringkasan Booking',
          subtitle: 'Periksa detail sebelum melanjutkan.',
        ),
        const SizedBox(height: 12),
        GroomingSummaryCard(
          petName: petName,
          petType: petType,
          service: service,
          date: selectedDate,
          time: selectedTime,
        ),
      ],
    );
  }

  Widget _dateCard(DateTime day, bool selected) => InkWell(
        onTap: () => onSelectDate(day),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 68,
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.primary : const Color(0xFFE5E5E5),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                GroomingBookingFormatters.weekday(day),
                style: TextStyle(
                  color: selected ? Colors.white70 : AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '${day.day}',
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                GroomingBookingFormatters.monthShort(day.month),
                style: TextStyle(
                  color: selected ? Colors.white70 : AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _otherDateButton() => OutlinedButton.icon(
        onPressed: onPickOtherDate,
        icon: const Icon(Icons.calendar_month_outlined, size: 18),
        label: const Text('Lainnya'),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: Color(0xFFE5E5E5)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      );

  static const _metaStyle = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );
}
