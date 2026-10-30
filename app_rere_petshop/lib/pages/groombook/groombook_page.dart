import 'package:flutter/material.dart';
import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/groom_book_bottom_bar.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/groom_book_details_step.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/groom_book_schedule_step.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/groom_book_step_indicator.dart';
import 'package:app_rere_petshop/pages/groombook/widgets/grooming_booking_formatters.dart';
import 'package:app_rere_petshop/pages/groombook/confirmbook_page.dart';
import 'package:app_rere_petshop/services/api_service.dart';
import 'package:app_rere_petshop/services/auth_service.dart';

class GroomBookPage extends StatefulWidget {
  const GroomBookPage({super.key});

  @override
  State<GroomBookPage> createState() => _GroomBookPageState();
}

class _GroomBookPageState extends State<GroomBookPage> {
  final _formKey = GlobalKey<FormState>();
  final _api = ApiService();
  final _auth = AuthService();
  final _petName = TextEditingController();
  final _petType = TextEditingController();
  final _petBreed = TextEditingController();
  final _petSize = TextEditingController();
  final _petNote = TextEditingController();

  static const _fallbackServices = [
    {
      'id': 1,
      'name': 'Grooming Basic',
      'description': 'Mandi dan perawatan dasar untuk hewan peliharaan Anda.',
      'price': 150000,
      'duration_minutes': 60,
    },
    {
      'id': 2,
      'name': 'Grooming Medium',
      'description':
          'Mandi, perawatan, dan pemotongan bulu untuk hewan peliharaan Anda.',
      'price': 250000,
      'duration_minutes': 60,
    },
    {
      'id': 3,
      'name': 'Grooming Premium',
      'description':
          'Perawatan lengkap termasuk mandi, pemotongan bulu, dan perawatan tambahan.',
      'price': 350000,
      'duration_minutes': 90,
    },
  ];

  List<Map<String, dynamic>> _services = [];
  List<Map<String, dynamic>> _slots = [];
  Map<String, dynamic>? _selectedService;
  DateTime? _selectedDate;
  String? _selectedTime;
  int _step = 0;
  bool _loadingServices = true;
  bool _loadingSlots = false;
  String? _slotsError;

  @override
  void initState() {
    super.initState();
    _ensureLogin();
    _loadServices();
  }

  @override
  void dispose() {
    _petName.dispose();
    _petType.dispose();
    _petBreed.dispose();
    _petSize.dispose();
    _petNote.dispose();
    super.dispose();
  }

  Future<void> _ensureLogin() async {
    if (await _auth.hasAuthToken() || !mounted) return;
    Navigator.pop(context);
  }

  Future<void> _loadServices() async {
    try {
      final services = await _api.getGroomingServices();
      if (!mounted) return;
      setState(() {
        _services = services.isEmpty
            ? List<Map<String, dynamic>>.from(_fallbackServices)
            : services;
        _loadingServices = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _services = List<Map<String, dynamic>>.from(_fallbackServices);
        _loadingServices = false;
      });
    }
  }

  Future<void> _selectDate(DateTime date) async {
    setState(() {
      _selectedDate = DateUtils.dateOnly(date);
      _selectedTime = null;
      _slots = [];
      _slotsError = null;
      _loadingSlots = true;
    });
    try {
      final slots = await _api.getGroomingSlots(
        GroomingBookingFormatters.dateKey(date),
      );
      if (!mounted) return;
      setState(() {
        _slots = slots;
        _loadingSlots = false;
        if (slots.isEmpty) _slotsError = 'Belum ada slot untuk tanggal ini.';
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadingSlots = false;
        _slotsError = 'Slot gagal dimuat. Coba pilih tanggal lain.';
      });
    }
  }

  Future<void> _pickOtherDate() async {
    final today = DateUtils.dateOnly(DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 180)),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: Theme.of(context).colorScheme.copyWith(
                primary: AppColors.primary,
              ),
        ),
        child: child!,
      ),
    );
    if (picked != null) await _selectDate(picked);
  }

  bool _isSlotAvailable(Map<String, dynamic> slot) {
    final booked = int.tryParse('${slot['booked'] ?? 0}') ?? 0;
    final capacity = int.tryParse('${slot['capacity'] ?? 0}') ?? 0;
    if (booked >= capacity || _selectedDate == null) return false;
    if (DateUtils.isSameDay(_selectedDate, DateTime.now())) {
      final parts = '${slot['time']}'.split(':');
      final hour = int.tryParse(parts.first) ?? 0;
      final minute = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
      final now = DateTime.now();
      final slotTime = DateTime(now.year, now.month, now.day, hour, minute);
      if (!slotTime.isAfter(DateTime.now())) return false;
    }
    return true;
  }

  void _continueToSchedule() {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedService == null) {
      _message('Pilih layanan grooming terlebih dahulu.');
      return;
    }
    setState(() => _step = 1);
  }

  Future<void> _goToConfirm() async {
    if (_selectedDate == null || _selectedTime == null) {
      _message('Pilih tanggal dan slot waktu terlebih dahulu.');
      return;
    }
    final edit = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmBookPage(
          petName: _petName.text.trim(),
          petType: _petType.text.trim(),
          petBreed: _petBreed.text.trim(),
          petSize: _petSize.text.trim(),
          petNote: _petNote.text.trim(),
          service: _selectedService!,
          date: _selectedDate!,
          time: _selectedTime!,
        ),
      ),
    );
    if (!mounted) return;
    if (edit == 'details') {
      setState(() => _step = 0);
    } else if (edit == 'schedule') {
      setState(() => _step = 1);
    }
  }

  void _message(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
            GroomBookStepIndicator(step: _step, totalSteps: 3),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: _step == 0 ? _detailsStep() : _scheduleStep(),
              ),
            ),
          ],
        ),
        bottomNavigationBar: GroomBookBottomBar(
          step: _step,
          price: GroomingBookingFormatters.number(_selectedService?['price']),
          selectedDate: _selectedDate,
          selectedTime: _selectedTime,
          submitting: false,
          onContinue: _step == 0 ? _continueToSchedule : _goToConfirm,
        ),
      );

  Widget _detailsStep() => GroomBookDetailsStep(
        formKey: _formKey,
        petName: _petName,
        petType: _petType,
        petBreed: _petBreed,
        petSize: _petSize,
        petNote: _petNote,
        services: _services,
        loadingServices: _loadingServices,
        selectedService: _selectedService,
        onSelectService: (service) => setState(() => _selectedService = service),
      );

  Widget _scheduleStep() => GroomBookScheduleStep(
        petName: _petName.text.trim(),
        petType: _petType.text.trim(),
        petBreed: _petBreed.text.trim(),
        service: _selectedService,
        selectedDate: _selectedDate,
        selectedTime: _selectedTime,
        slots: _slots,
        loadingSlots: _loadingSlots,
        slotsError: _slotsError,
        onSelectDate: _selectDate,
        onPickOtherDate: _pickOtherDate,
        onSelectTime: (time) => setState(() => _selectedTime = time),
        isSlotAvailable: _isSlotAvailable,
        onEditDetails: () => setState(() => _step = 0),
      );
}
