import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/booking_detail_page.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/confirmbook_bottom_bar.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/confirmbook_header.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/confirmbook_pet_section.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/confirmbook_price_section.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/confirmbook_schedule_section.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/confirmbook_service_section.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/groom_book_step_indicator.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_formatters.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_snap_page.dart';
import 'package:app_rere_petshop/services/api_service.dart';

class ConfirmBookPage extends StatefulWidget {
  const ConfirmBookPage({
    super.key,
    required this.petName,
    required this.petType,
    required this.petBreed,
    required this.petSize,
    required this.petNote,
    required this.service,
    required this.date,
    required this.time,
  });

  final String petName;
  final String petType;
  final String petBreed;
  final String petSize;
  final String petNote;
  final Map<String, dynamic> service;
  final DateTime date;
  final String time;

  @override
  State<ConfirmBookPage> createState() => _ConfirmBookPageState();
}

class _ConfirmBookPageState extends State<ConfirmBookPage> {
  final _api = ApiService();
  bool _submitting = false;

  int get _price =>
      GroomingBookingFormatters.number(widget.service['price']);

  int get _duration => int.tryParse(
        '${widget.service['duration_minutes'] ?? widget.service['durationMinutes'] ?? 0}',
      ) ?? 0;

  Future<void> _confirmBooking() async {
    setState(() => _submitting = true);
    try {
      final result = await _api.createGroomingBooking({
        'serviceId': widget.service['id'],
        'petName': widget.petName,
        'petType': widget.petType,
        'petBreed': widget.petBreed,
        'petSize': widget.petSize,
        'petNote': widget.petNote,
        'date': GroomingBookingFormatters.dateKey(widget.date),
        'time': widget.time,
      });
      if (!mounted) return;
      setState(() => _submitting = false);

      var bookingStatus = 'menunggu_pembayaran';
      final token = result['snap_token']?.toString();
      if (token != null && token.isNotEmpty) {
        final paymentStatus = await Navigator.push<String>(
          context,
          MaterialPageRoute(builder: (_) => GroomingSnapPage(token: token)),
        );
        if (!mounted) return;
        if (paymentStatus != null) {
          if (['settlement', 'capture', 'success'].contains(paymentStatus)) {
            bookingStatus = 'terjadwal';
          } else if (['deny', 'cancel', 'expire'].contains(paymentStatus)) {
            bookingStatus = 'gagal';
          }
          try {
            await _api.syncGroomingPayment(
              int.parse('${result['id']}'),
              paymentStatus,
            );
          } catch (_) {
            // Detail page reloads the canonical status from the backend.
          }
        }
      }
      if (!mounted) return;
      final booking = <String, dynamic>{
        ...result,
        'petName': widget.petName,
        'petType': widget.petType,
        'petBreed': widget.petBreed,
        'petSize': widget.petSize,
        'petNote': widget.petNote,
        'serviceName': widget.service['name'],
        'date': GroomingBookingFormatters.dateKey(widget.date),
        'time': widget.time,
        'price': result['price'] ?? widget.service['price'],
        'status': bookingStatus,
      };
      final navigator = Navigator.of(context);
      final detailRoute = MaterialPageRoute<void>(
        builder: (_) => GroomingBookingDetailPage(
          booking: booking,
          service: widget.service,
        ),
      );
      navigator.pop(); // konfirmasi
      navigator.pop(); // form booking
      await navigator.push(detailRoute);
    } catch (error) {
      if (!mounted) return;
      setState(() => _submitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 1,
          title: const Text(
            'Grooming',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Column(
          children: [
            const GroomBookStepIndicator(step: 2, totalSteps: 3),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ConfirmBookHeader(),
                    const SizedBox(height: 18),
                    ConfirmBookPetSection(
                      name: widget.petName,
                      type: widget.petType,
                      breed: widget.petBreed,
                      size: widget.petSize,
                      note: widget.petNote,
                      onEdit: () => Navigator.pop(context, 'details'),
                    ),
                    const SizedBox(height: 18),
                    ConfirmBookServiceSection(
                      service: widget.service,
                      onEdit: () => Navigator.pop(context, 'details'),
                    ),
                    const SizedBox(height: 18),
                    ConfirmBookScheduleSection(
                      date: widget.date,
                      time: widget.time,
                      durationMinutes: _duration,
                      onEdit: () => Navigator.pop(context, 'schedule'),
                    ),
                    const SizedBox(height: 18),
                    ConfirmBookPriceSection(price: _price),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: ConfirmBookBottomBar(
          price: _price,
          submitting: _submitting,
          onConfirm: _confirmBooking,
        ),
      );
}
