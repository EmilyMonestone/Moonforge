/// Pagination parameters for repository queries.
class PaginationParams {
  final int page;
  final int pageSize;

  const PaginationParams({this.page = 1, this.pageSize = 20});

  int get offset => (page - 1) * pageSize;

  int get limit => pageSize;
}

/// Generic container for paginated data.
class PaginatedResult<T> {
  final List<T> items;
  final int totalCount;
  final int page;
  final int pageSize;

  const PaginatedResult({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.pageSize,
  });

  int get totalPages => (totalCount / pageSize).ceil();

  bool get hasNextPage => page < totalPages;

  bool get hasPreviousPage => page > 1;
}
