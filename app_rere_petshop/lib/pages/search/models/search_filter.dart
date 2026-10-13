enum SearchSortOrder { relevance, priceLowToHigh, priceHighToLow }

class SearchFilter {
  const SearchFilter({
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.inStockOnly = false,
    this.sortOrder = SearchSortOrder.relevance,
  });

  final int? categoryId;
  final double? minPrice;
  final double? maxPrice;
  final bool inStockOnly;
  final SearchSortOrder sortOrder;

  int get activeCount {
    var count = 0;
    if (categoryId != null) count++;
    if (minPrice != null || maxPrice != null) count++;
    if (inStockOnly) count++;
    if (sortOrder != SearchSortOrder.relevance) count++;
    return count;
  }
}
