import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/pages/order/order_detail_page.dart';
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
  bool _loading = true;
  String? _error;
  String _selectedStatus = 'semua';
  DateTimeRange? _dateRange;

  static const _statuses = <String, String>{
    'semua': 'Semua',
    'diproses': 'Diproses',
    'dikirim': 'Dikirim',
    'selesai': 'Selesai',
    'batal': 'Dibatalkan',
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
      final result = await _api.getOrders();
      if (mounted) setState(() => _orders = result);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<Map<String, dynamic>> get _visibleOrders {
    final query = _searchController.text.trim().toLowerCase();
    final results = _orders.where((order) {
      final details = order['details'] as List? ?? const [];
      final status = order['status_pesanan']?.toString() ?? 'baru';
      final statusMatches = _selectedStatus == 'semua' ||
          _effectiveStatus(status) == _selectedStatus;
      final searchMatches = query.isEmpty ||
          (order['kode_pesanan']?.toString().toLowerCase().contains(query) ?? false) ||
          order['id_pesanan']?.toString().toLowerCase().contains(query) == true ||
          details.whereType<Map>().any((detail) {
            final product = detail['produk'] as Map? ?? const {};
            return (product['nama_produk']?.toString().toLowerCase().contains(query) ?? false);
          });
      final date = DateTime.tryParse(order['tanggal_pesanan']?.toString() ?? '')?.toLocal();
      final dateMatches = _dateRange == null || (date != null &&
          !date.isBefore(DateTime(_dateRange!.start.year, _dateRange!.start.month, _dateRange!.start.day)) &&
          date.isBefore(DateTime(_dateRange!.end.year, _dateRange!.end.month, _dateRange!.end.day).add(const Duration(days: 1))));
      return statusMatches && searchMatches && dateMatches;
    }).toList();

    results.sort((a, b) {
      final dateA = DateTime.tryParse(a['tanggal_pesanan']?.toString() ?? '');
      final dateB = DateTime.tryParse(b['tanggal_pesanan']?.toString() ?? '');
      final dateOrder = (dateB ?? DateTime(0)).compareTo(dateA ?? DateTime(0));
      if (dateOrder != 0) return dateOrder;
      return (int.tryParse(b['id_pesanan']?.toString() ?? '') ?? 0)
          .compareTo(int.tryParse(a['id_pesanan']?.toString() ?? '') ?? 0);
    });
    return results;
  }

  String _effectiveStatus(String status) => status == 'baru' ? 'diproses' : status;

  Future<void> _chooseDateRange() async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(now.year + 1),
      initialDateRange: _dateRange,
      helpText: 'Pilih tanggal pesanan',
      cancelText: 'Batal',
      confirmText: 'Pilih',
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(colorScheme: Theme.of(context).colorScheme.copyWith(primary: AppColors.primary)),
        child: child!,
      ),
    );
    if (mounted && range != null) setState(() => _dateRange = range);
  }

  Future<void> _showStatusFilter() async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: AppColors.white,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 4, 20, 12),
            child: Align(alignment: Alignment.centerLeft,
                child: Text('Filter Status', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17))),
          ),
          for (final entry in _statuses.entries)
            ListTile(
              title: Text(entry.value),
              trailing: _selectedStatus == entry.key
                  ? const Icon(Icons.check_circle, color: AppColors.primary)
                  : null,
              onTap: () => Navigator.pop(context, entry.key),
            ),
          const SizedBox(height: 8),
        ]),
      ),
    );
    if (mounted && selected != null) setState(() => _selectedStatus = selected);
  }

  Future<void> _showFilters() async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.white,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Filter Pesanan', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
            const SizedBox(height: 18),
            const Text('Tanggal', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () async {
                Navigator.pop(context);
                await _chooseDateRange();
              },
              icon: const Icon(Icons.calendar_today_outlined, size: 17),
              label: Text(_dateRangeLabel),
            ),
            const SizedBox(height: 12),
            const Text('Status', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final entry in _statuses.entries)
                ChoiceChip(
                  label: Text(entry.value),
                  selected: _selectedStatus == entry.key,
                  selectedColor: AppColors.primary.withOpacity(0.12),
                  labelStyle: TextStyle(color: _selectedStatus == entry.key ? AppColors.primary : AppColors.textPrimary),
                  onSelected: (_) {
                    setState(() => _selectedStatus = entry.key);
                    Navigator.pop(context);
                  },
                ),
            ]),
            if (_dateRange != null || _selectedStatus != 'semua') ...[
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  setState(() { _dateRange = null; _selectedStatus = 'semua'; });
                  Navigator.pop(context);
                },
                child: const Text('Hapus semua filter'),
              ),
            ],
          ]),
        ),
      ),
    );
  }

  String get _dateRangeLabel {
    final range = _dateRange;
    if (range == null) return 'Pilih rentang tanggal';
    return '${_shortDate(range.start)} – ${_shortDate(range.end)}';
  }

  String _shortDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  @override
  Widget build(BuildContext context) {
    final orders = _visibleOrders;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [
          _searchBar(),
          _statusTabs(),
          _filterSummary(),
          Expanded(child: _buildList(orders)),
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
                hintText: 'Cari nomor pesanan atau produk...',
                hintStyle: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                prefixIcon: const Icon(Icons.search, size: 19),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(icon: const Icon(Icons.close, size: 17),
                        onPressed: () { _searchController.clear(); setState(() {}); })
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
            child: IconButton(onPressed: _showFilters, icon: const Icon(Icons.tune, size: 19),
                tooltip: 'Filter pesanan'),
          ),
        ]),
      );

  Widget _statusTabs() => SizedBox(
        height: 43,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          scrollDirection: Axis.horizontal,
          children: [
            for (final entry in _statuses.entries)
              Padding(
                padding: const EdgeInsets.only(right: 7),
                child: ChoiceChip(
                  label: Text(entry.value),
                  selected: _selectedStatus == entry.key,
                  onSelected: (_) => setState(() => _selectedStatus = entry.key),
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.greyBg,
                  labelStyle: TextStyle(
                    color: _selectedStatus == entry.key ? AppColors.white : AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  side: BorderSide.none,
                  showCheckmark: false,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                ),
              ),
          ],
        ),
      );

  Widget _filterSummary() {
    final orders = _visibleOrders;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 2, 16, 8),
      child: Row(children: [
        _filterButton(
          icon: Icons.calendar_today_outlined,
          label: _dateRange == null ? 'Tanggal' : _dateRangeLabel,
          onTap: _chooseDateRange,
        ),
        const SizedBox(width: 8),
        _filterButton(
          icon: Icons.flag_outlined,
          label: _statuses[_selectedStatus] ?? 'Status',
          onTap: _showStatusFilter,
        ),
        const Spacer(),
        Text('Total ${orders.length} pesanan', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
      ]),
    );
  }

  Widget _filterButton({required IconData icon, required String label, required VoidCallback onTap}) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 145),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(color: AppColors.greyBg, borderRadius: BorderRadius.circular(20)),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            Icon(icon, size: 14, color: AppColors.textSecondary),
            const SizedBox(width: 5),
            Flexible(child: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 10, color: AppColors.textSecondary))),
            const SizedBox(width: 3),
            const Icon(Icons.keyboard_arrow_down, size: 15, color: AppColors.textSecondary),
          ]),
        ),
      );

  Widget _buildList(List<Map<String, dynamic>> orders) {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) {
      return Center(child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Text(_error!, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: _load, child: const Text('Coba Lagi')),
        ]),
      ));
    }
    if (orders.isEmpty) {
      return RefreshIndicator(
        onRefresh: _load,
        child: ListView(children: const [
          SizedBox(height: 130),
          Icon(Icons.receipt_long_outlined, size: 50, color: AppColors.grey),
          SizedBox(height: 12),
          Center(child: Text('Pesanan tidak ditemukan', style: TextStyle(fontWeight: FontWeight.w600))),
          SizedBox(height: 4),
          Center(child: Text('Coba ubah kata kunci atau filter.', style: TextStyle(color: AppColors.textSecondary))),
        ]),
      );
    }
    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final orderId = int.tryParse(order['id_pesanan']?.toString() ?? '') ?? 0;
          void openDetails() {
            Navigator.push<void>(context, MaterialPageRoute(
              builder: (_) => OrderDetailPage(orderId: orderId),
            )).then((_) => _load());
          }

          return OrderHistoryCard(
            order: order,
            onDetails: openDetails,
            onTrack: openDetails,
          );
        },
      ),
    );
  }
}
