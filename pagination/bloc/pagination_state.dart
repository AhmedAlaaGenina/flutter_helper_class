part of 'pagination_bloc.dart';

class PaginationState<T> extends Equatable {
  final List<T> items;
  final int? nextPageKey;
  final int? totalItems;
  final int? totalPages;
  final int currentPage;
  final bool isLoading;
  final bool isRefreshing;
  final bool isLoadingMore;
  final bool hasReachedEnd;
  final String? error;

  const PaginationState({
    this.items = const [],
    this.nextPageKey = 1,
    this.totalItems,
    this.totalPages,
    this.currentPage = 1,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isLoadingMore = false,
    this.hasReachedEnd = false,
    this.error,
  });

  PaginationState<T> copyWith({
    List<T>? items,
    int? nextPageKey,
    int? totalItems,
    int? totalPages,
    int? currentPage,
    bool? isLoading,
    bool? isRefreshing,
    bool? isLoadingMore,
    bool? hasReachedEnd,
    String? error,
  }) {
    return PaginationState<T>(
      items: items ?? this.items,
      nextPageKey: nextPageKey ?? this.nextPageKey,
      totalItems: totalItems ?? this.totalItems,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    items,
    nextPageKey,
    totalItems,
    totalPages,
    currentPage,
    isLoading,
    isRefreshing,
    isLoadingMore,
    hasReachedEnd,
    error,
  ];
}
