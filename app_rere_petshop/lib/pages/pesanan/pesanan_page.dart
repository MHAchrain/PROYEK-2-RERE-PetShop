import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/groombook/booking_detail_page.dart';
import 'package:app_rere_petshop/pages/order/order_detail_page.dart';
import 'package:app_rere_petshop/pages/pesanan/widgets/grooming_history_card.dart';
import 'package:app_rere_petshop/pages/pesanan/widgets/order_history_card.dart';
import 'package:app_rere_petshop/services/api_service.dart';
import 'package:flutter/material.dart';

class PesananPage extends StatefulWidget {
  const PesananPage({super.key});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  final _api = ApiService();
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _orders = [];
  List<Map<String, dynamic>> _bookings = [];
  bool _loading = true;
  String? _error;
  String _selectedType = 'semua';
  DateTimeRange? _dateRange;

  static const _types = <String, String>{
    'semua': 'Semua',
    'pesanan': 'Pesanan',
    'booking': 'Booking Grooming',
  };

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    if (mounted) setState(() { _loading = true; _error = null; });
    try {
      final results = await Future.wait([
        _api.getOrders(),
        _api.getGroomingBookings(),
      ]);
      if (mounted) {
        setState(() {
          _orders = results[0];
          _bookings = results[1];
        });
      }
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _chooseDateRange() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1),
      initialDateRange: _dateRange,
      helpText: 'Pilih rentang tanggal riwayat',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppColors.primary)),
        child: child!,
      ),
    );
    if (mounted && range != null) setState(() => _dateRange = range);
  }

  List<_HistoryEntry> get _visibleEntries {
    final query = _searchController.text.trim().toLowerCase();
    final entries = <_HistoryEntry>[];
    if (_selectedType != 'booking') {
      entries.addAll(_orders.map((order) => _HistoryEntry(order, false)));
    }
    if (_selectedType != 'pesanan') {
      entries.addAll(_bookings.map((booking) => _HistoryEntry(booking, true)));
    }
    final results = entries.where((entry) {
      final data = entry.data;
      final textMatches = query.isEmpty || (entry.isBooking
          ? ['kodeBooking', 'serviceName', 'petName', 'petType']
              .any((key) => '${data[key] ?? ''}'.toLowerCase().contains(query))
          : _orderMatches(data, query));
      final rawDate = entry.isBooking
          ? data['date']?.toString()
          : data['tanggal_pesanan']?.toString();
      final date = DateTime.tryParse(rawDate ?? '')?.toLocal();
      final dateMatches = _dateRange == null || (date != null &&
          !date.isBefore(DateTime(_dateRange!.start.year, _dateRange!.start.month, _dateRange!.start.day)) &&
          date.isBefore(DateTime(_dateRange!.end.year, _dateRange!.end.month, _dateRange!.end.day).add(const Duration(days: 1))));
      return textMatches && dateMatches;
    }).toList();
    results.sort((a, b) => (_entryDate(b) ?? DateTime(0)).compareTo(_entryDate(a) ?? DateTime(0)));
    return results;
  }

  bool _orderMatches(Map<String, dynamic> order, String query) {
    if ((order['kode_pesanan']?.toString().toLowerCase().contains(query) ?? false) ||
        (order['id_pesanan']?.toString().toLowerCase().contains(query) ?? false)) {
      return true;
    }
    final details = order['details'] as List? ?? const [];
    return details.whereType<Map>().any((detail) {
      final product = detail['produk'] as Map? ?? const {};
      return (product['nama_produk']?.toString().toLowerCase().contains(query) ?? false);
    });
  }

  DateTime? _entryDate(_HistoryEntry entry) => DateTime.tryParse(
        (entry.isBooking
                    ? (entry.data['createdAt'] ?? entry.data['date'])
                    : entry.data['tanggal_pesanan'])
                ?.toString() ??
            '',
      );

  @override
  Widget build(BuildContext context) {
    final entries = _visibleEntries;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          _searchBar(),
          _typeTabs(entries.length),
          Expanded(child: _buildList(entries)),
        ]),
      ),
    );
  }

  Widget _searchBar() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: 'Cari pesanan, booking, atau layanan...',
                hintStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.search, size: 19),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.close, size: 17), onPressed: () { _searchController.clear(); setState(() {}); })
                    : null,
                filled: true,
                fillColor: AppColors.greyBg,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: AppColors.greyBg,
            shape: const CircleBorder(),
            child: IconButton(
              onPressed: _chooseDateRange,
              icon: const Icon(Icons.tune, size: 19),
              tooltip: 'Filter riwayat',
            ),
          ),
        ]),
      );

  Widget _typeTabs(int count) => SizedBox(
        height: 49,
        child: Row(children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              children: [
                for (final entry in _types.entries)
                  Padding(
                    padding: const EdgeInsets.only(right: 7),
                    child: ChoiceChip(
                      label: Text(entry.value),
                      selected: _selectedType == entry.key,
                      onSelected: (_) => setState(() => _selectedType = entry.key),
                      selectedColor: AppColors.primary,
                      backgroundColor: AppColors.greyBg,
                      labelStyle: TextStyle(color: _selectedType == entry.key ? AppColors.white : AppColors.textPrimary, fontSize: 11, fontWeight: FontWeight.w600),
                      side: BorderSide.none,
                      showCheckmark: false,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 16),
            child: Text('Total $count riwayat', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ),
        ]),
      );

  Widget _buildList(List<_HistoryEntry> entries) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(_error!, textAlign: TextAlign.center), const SizedBox(height: 12), ElevatedButton(onPressed: _load, child: const Text('Coba Lagi')),
      ])));
    }
    if (entries.isEmpty) {
      return RefreshIndicator(onRefresh: _load, child: ListView(children: const [
        SizedBox(height: 130), Icon(Icons.receipt_long_outlined, size: 50, color: AppColors.grey), SizedBox(height: 12),
        Center(child: Text('Riwayat tidak ditemukan', style: TextStyle(fontWeight: FontWeight.w600))),
        SizedBox(height: 4), Center(child: Text('Coba ubah kata kunci atau filter.', style: TextStyle(color: AppColors.textSecondary))),
      ]));
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        itemCount: entries.length,
        itemBuilder: (context, index) {
          final entry = entries[index];
          if (entry.isBooking) {
            final booking = entry.data;
            final service = <String, dynamic>{
              'id': booking['serviceId'],
              'name': booking['serviceName'] ?? 'Grooming',
              'price': booking['price'],
            };
            return GroomingHistoryCard(
              booking: booking,
              onDetails: () => Navigator.push<void>(context, MaterialPageRoute(
                builder: (_) => GroomingBookingDetailPage(booking: booking, service: service),
              )).then((_) => _load()),
            );
          }
          final order = entry.data;
          final orderId = int.tryParse(order['id_pesanan']?.toString() ?? '') ?? 0;
          void openDetails() => Navigator.push<void>(context, MaterialPageRoute(
            builder: (_) => OrderDetailPage(orderId: orderId),
          )).then((_) => _load());
          return OrderHistoryCard(order: order, onDetails: openDetails, onTrack: openDetails);
        },
      ),
    );
  }
}

class _HistoryEntry {
  const _HistoryEntry(this.data, this.isBooking);
  final Map<String, dynamic> data;
  final bool isBooking;
}
