import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/booking_cost_section.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/booking_detail_bottom_bar.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/booking_pet_section.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/booking_result_header.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/booking_schedule_section.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/booking_service_section.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/booking_status_card.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_formatters.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_snap_page.dart';
import 'package:app_rere_petshop/services/api_service.dart';

class GroomingBookingDetailPage extends StatefulWidget {
  const GroomingBookingDetailPage({
    super.key,
    required this.booking,
    required this.service,
  });

  final Map<String, dynamic> booking;
  final Map<String, dynamic> service;

  @override
  State<GroomingBookingDetailPage> createState() =>
      _GroomingBookingDetailPageState();
}

class _GroomingBookingDetailPageState extends State<GroomingBookingDetailPage> {
  final _api = ApiService();
  late Map<String, dynamic> _booking;
  bool _loadingPayment = false;

  @override
  void initState() {
    super.initState();
    _booking = Map<String, dynamic>.from(widget.booking);
    _refreshBooking();
  }

  int get _bookingId =>
      int.tryParse('${_booking['id'] ?? _booking['bookingId'] ?? ''}') ?? 0;

  int get _price => GroomingBookingFormatters.number(
        _booking['price'] ?? widget.service['price'],
      );

  String get _status => '${_booking['status'] ?? 'menunggu_pembayaran'}';

  Future<void> _refreshBooking() async {
    if (_bookingId <= 0) return;
    try {
      final booking = await _api.getGroomingBooking(_bookingId);
      if (!mounted || booking.isEmpty) return;
      setState(() => _booking = {..._booking, ...booking});
    } catch (_) {
      // Keep the booking response already returned by the create endpoint.
    }
  }

  Future<void> _payAgain() async {
    if (_bookingId <= 0) return;
    setState(() => _loadingPayment = true);
    try {
      final token = await _api.getGroomingPaymentToken(_bookingId);
      if (!mounted) return;
      final status = await Navigator.push<String>(
        context,
        MaterialPageRoute(builder: (_) => GroomingSnapPage(token: token)),
      );
      if (status != null) {
        await _api.syncGroomingPayment(_bookingId, status);
      }
      await _refreshBooking();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.toString())),
      );
    } finally {
      if (mounted) setState(() => _loadingPayment = false);
    }
  }

  DateTime get _date {
    final value = '${_booking['date'] ?? ''}';
    return DateTime.tryParse(value) ?? DateTime.now();
  }

  String get _bookingCode {
    final supplied = _booking['kodeBooking']?.toString();
    if (supplied != null && supplied.isNotEmpty) return supplied;
    return 'GR-${_bookingId.toString().padLeft(4, '0')}';
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          foregroundColor: AppColors.textPrimary,
          elevation: 1,
          title: const Text('Grooming', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        body: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: _refreshBooking,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
            children: [
              BookingResultHeader(
                status: _status,
                bookingCode: _bookingCode,
                createdAt: _booking['createdAt']?.toString(),
              ),
              const SizedBox(height: 20),
              BookingStatusCard(status: _status),
              const SizedBox(height: 20),
              BookingPetSection(
                name: '${_booking['petName'] ?? ''}',
                type: '${_booking['petType'] ?? ''}',
                breed: '${_booking['petBreed'] ?? ''}',
                size: '${_booking['petSize'] ?? ''}',
                note: '${_booking['petNote'] ?? ''}',
              ),
              const SizedBox(height: 20),
              BookingServiceSection(service: widget.service),
              const SizedBox(height: 20),
              BookingScheduleSection(
                date: _date,
                time: '${_booking['time'] ?? ''}',
              ),
              const SizedBox(height: 20),
              BookingCostSection(price: _price),
            ],
          ),
        ),
        bottomNavigationBar: BookingDetailBottomBar(
          status: _status,
          loading: _loadingPayment,
          onPay: _payAgain,
          onBack: () => Navigator.pop(context),
        ),
      );
}
