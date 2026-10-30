import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_formatters.dart';

class GroomBookBottomBar extends StatelessWidget {
  const GroomBookBottomBar({
    super.key,
    required this.step,
    required this.price,
    required this.selectedDate,
    required this.selectedTime,
    required this.submitting,
    required this.onContinue,
  });

  final int step;
  final int price;
  final DateTime? selectedDate;
  final String? selectedTime;
  final bool submitting;
  final VoidCallback onContinue;

  static const _metaStyle = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: const Border(top: BorderSide(color: Color(0xFFE5E5E5))),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.05),
                blurRadius: 14,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: [
              if (step == 1) ...[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Estimasi biaya', style: _metaStyle),
                      Text(
                        GroomingBookingFormatters.rupiah(price),
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      if (selectedDate != null && selectedTime != null)
                        Text(
                          '${GroomingBookingFormatters.dateKey(selectedDate!)} · $selectedTime WIB',
                          style: _metaStyle,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
              ] else
                const Spacer(),
              Expanded(
                flex: step == 1 ? 1 : 2,
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: submitting ? null : onContinue,
                    icon: submitting
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.arrow_forward),
                    label: Text(
                      step == 0 ? 'Lanjut pilih jadwal' : 'Tinjau booking',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.white,
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
