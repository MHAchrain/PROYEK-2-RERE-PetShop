import 'package:app_rere_petshop/constants/app_colors.dart';
import 'package:app_rere_petshop/models/category_model.dart';
import 'package:app_rere_petshop/pages/search/models/search_filter.dart';
import 'package:flutter/material.dart';

class SearchFilterSheet extends StatefulWidget {
  const SearchFilterSheet({
    super.key,
    required this.categories,
    required this.initialFilter,
  });

  final List<Category> categories;
  final SearchFilter initialFilter;

  @override
  State<SearchFilterSheet> createState() => _SearchFilterSheetState();
}

class _SearchFilterSheetState extends State<SearchFilterSheet> {
  late final TextEditingController _minPriceController;
  late final TextEditingController _maxPriceController;
  late int? _categoryId;
  late bool _inStockOnly;
  late SearchSortOrder _sortOrder;

  @override
  void initState() {
    super.initState();
    _minPriceController = TextEditingController(
      text: widget.initialFilter.minPrice?.toStringAsFixed(0) ?? '',
    );
    _maxPriceController = TextEditingController(
      text: widget.initialFilter.maxPrice?.toStringAsFixed(0) ?? '',
    );
    _categoryId = widget.initialFilter.categoryId;
    _inStockOnly = widget.initialFilter.inStockOnly;
    _sortOrder = widget.initialFilter.sortOrder;
  }

  @override
  void dispose() {
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  double? _parsePrice(String value) {
    final normalized = value.trim().replaceAll('.', '').replaceAll(',', '.');
    return normalized.isEmpty ? null : double.tryParse(normalized);
  }

  void _apply() {
    final minPrice = _parsePrice(_minPriceController.text);
    final maxPrice = _parsePrice(_maxPriceController.text);
    if (minPrice != null && maxPrice != null && minPrice > maxPrice) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Harga minimum harus lebih kecil dari maksimum.'),
        ),
      );
      return;
    }

    Navigator.pop(
      context,
      SearchFilter(
        categoryId: _categoryId,
        minPrice: minPrice,
        maxPrice: maxPrice,
        inStockOnly: _inStockOnly,
        sortOrder: _sortOrder,
      ),
    );
  }

  void _reset() {
    setState(() {
      _categoryId = null;
      _minPriceController.clear();
      _maxPriceController.clear();
      _inStockOnly = false;
      _sortOrder = SearchSortOrder.relevance;
    });
  }

  @override
  Widget build(BuildContext context) {
    final seenCategoryIds = <int>{};
    final categories = widget.categories.where((category) {
      return category.id > 0 && seenCategoryIds.add(category.id);
    }).toList();

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          MediaQuery.viewInsetsOf(context).bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.greyLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Filter Produk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  TextButton(onPressed: _reset, child: const Text('Reset')),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Kategori',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int?>(
                value: _categoryId,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('Semua kategori'),
                  ),
                  ...categories.map(
                    (category) => DropdownMenuItem<int?>(
                      value: category.id,
                      child: Text(category.name),
                    ),
                  ),
                ],
                onChanged: (value) => setState(() => _categoryId = value),
              ),
              const SizedBox(height: 18),
              const Text(
                'Rentang Harga',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(child: _priceField(_minPriceController, 'Minimum')),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text('—'),
                  ),
                  Expanded(child: _priceField(_maxPriceController, 'Maksimum')),
                ],
              ),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                title: const Text('Stok tersedia saja'),
                value: _inStockOnly,
                activeColor: AppColors.primary,
                onChanged: (value) => setState(() => _inStockOnly = value),
              ),
              const Text(
                'Urutkan Harga',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<SearchSortOrder>(
                value: _sortOrder,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                items: const [
                  DropdownMenuItem(
                    value: SearchSortOrder.relevance,
                    child: Text('Relevan'),
                  ),
                  DropdownMenuItem(
                    value: SearchSortOrder.priceLowToHigh,
                    child: Text('Harga terendah'),
                  ),
                  DropdownMenuItem(
                    value: SearchSortOrder.priceHighToLow,
                    child: Text('Harga tertinggi'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _sortOrder = value);
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _apply,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text('Terapkan Filter'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _priceField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        prefixText: 'Rp ',
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      ),
    );
  }
}
