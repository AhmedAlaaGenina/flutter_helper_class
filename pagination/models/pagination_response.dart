class PaginationResponse<T> {
  final List<T> items;
  final int? totalItems;
  final int? numberItemPerPage;
  final int? currentPage;
  final int? totalPage;
  PaginationResponse({
    required this.items,
    this.totalItems,
    this.numberItemPerPage,
    this.currentPage,
    this.totalPage,
  });
}
