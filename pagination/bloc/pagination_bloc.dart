import 'dart:async';
import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination_package/app_log.dart';
import 'package:infinite_scroll_pagination_package/features/pagination/models/pagination_response.dart';

part 'pagination_event.dart';
part 'pagination_state.dart';

class PaginationBloc<T> extends Bloc<PaginationEvent, PaginationState<T>> {
  final Future<PaginationResponse<T>> Function(int pageKey, int pageSize)
  fetchPage;
  final int pageSize;
  final bool enableCache;

  // Cache structure: Map<pageNumber, List<items>>
  final Map<int, List<T>> _cache = HashMap<int, List<T>>();
  // Track in-flight requests to prevent duplicates
  final Set<int> _loadingPages = <int>{};

  // Request throttling
  DateTime? _lastRequestTime;
  static const _minRequestInterval = Duration(milliseconds: 300);

  // Data loading debounce
  Timer? _loadDebounce;

  PaginationBloc({
    required this.fetchPage,
    this.pageSize = 20,
    this.enableCache = true,
  }) : super(PaginationState<T>()) {
    on<LoadPageEvent<T>>(_onLoadPage);
    on<RefreshEvent<T>>(_onRefresh);
    on<ClearCacheEvent<T>>(_onClearCache);
    on<PrefetchEvent<T>>(_onPrefetch);
    on<SetLoadingMoreEvent<T>>(_onSetLoadingMore);
  }

  Future<void> _onSetLoadingMore(
    SetLoadingMoreEvent<T> event,
    Emitter<PaginationState<T>> emit,
  ) async {
    if (!state.isLoadingMore &&
        !state.hasReachedEnd &&
        state.nextPageKey != null &&
        !_loadingPages.contains(state.nextPageKey)) {
      emit(state.copyWith(isLoadingMore: true));

      // Cancel any previous debounce timer
      _loadDebounce?.cancel();

      // Use debounce timer instead of fixed delay
      _loadDebounce = Timer(const Duration(milliseconds: 150), () {
        // Only trigger the load if conditions are still valid
        if (state.isLoadingMore &&
            state.nextPageKey != null &&
            !_loadingPages.contains(state.nextPageKey)) {
          add(LoadPageEvent<T>(state.nextPageKey!));
        }
      });
    }
  }

  Future<void> _onLoadPage(
    LoadPageEvent<T> event,
    Emitter<PaginationState<T>> emit,
  ) async {
    // CRITICAL: Prevent duplicate loading of the same page
    if (_loadingPages.contains(event.pageKey)) {
      return;
    }

    // Avoid loading if conditions aren't met
    if (state.isLoading || state.hasReachedEnd) {
      return;
    }

    // NOTE: We don't need to set isLoadingMore here as it's already set
    // We only need to set isLoading for the first page
    if (event.pageKey == 1) {
      emit(state.copyWith(isLoading: true, error: null));
    }

    // Mark this page as being loaded
    _loadingPages.add(event.pageKey);

    // Check cache first
    if (enableCache && _cache.containsKey(event.pageKey)) {
      final cachedItems = _cache[event.pageKey]!;
      final isLastPage = cachedItems.length < pageSize;

      await Future.delayed(const Duration(milliseconds: 50));
      emit(
        state.copyWith(
          items:
              event.pageKey == 1
                  ? cachedItems
                  : [...state.items, ...cachedItems],
          nextPageKey: isLastPage ? null : event.pageKey + 1,
          currentPage: event.pageKey,
          hasReachedEnd: isLastPage,
          isLoading: false,
          isLoadingMore: false,
          error: null,
        ),
      );
      // Important: Remove from loading pages set
      _loadingPages.remove(event.pageKey);

      // Prefetch next page if it's not in cache and not being loaded
      if (!isLastPage &&
          !_cache.containsKey(event.pageKey + 1) &&
          !_loadingPages.contains(event.pageKey + 1)) {
        add(PrefetchEvent<T>(event.pageKey + 1));
      }

      return;
    }

    // Apply throttling - but loading state is already shown
    if (_lastRequestTime != null) {
      final timeSinceLastRequest = DateTime.now().difference(_lastRequestTime!);
      if (timeSinceLastRequest < _minRequestInterval) {
        await Future.delayed(_minRequestInterval - timeSinceLastRequest);
      }
    }
    _lastRequestTime = DateTime.now();

    try {
      final response = await fetchPage(event.pageKey, pageSize);
      final items = response.items;
      final isLastPage = items.length < pageSize;

      // Cache current page
      if (enableCache) {
        _cache[event.pageKey] = List<T>.from(items);
      }

      emit(
        state.copyWith(
          items: event.pageKey == 1 ? items : [...state.items, ...items],
          nextPageKey: isLastPage ? null : event.pageKey + 1,
          currentPage: response.currentPage ?? event.pageKey,
          totalItems: response.totalItems,
          totalPages: response.totalPage,
          isLoading: false,
          isLoadingMore: false,
          hasReachedEnd: isLastPage,
          error: null,
        ),
      );

      // Prefetch next page
      // Important: Remove from loading pages set
      _loadingPages.remove(event.pageKey);

      // Prefetch next page
      if (!isLastPage &&
          enableCache &&
          !_loadingPages.contains(event.pageKey + 1)) {
        add(PrefetchEvent<T>(event.pageKey + 1));
      }
    } catch (error) {
      AppLog.e('Error loading page ${event.pageKey}: $error');
      emit(
        state.copyWith(
          isLoading: false,
          isLoadingMore: false,
          error: error.toString(),
        ),
      );
    }
  }

  Future<void> _onRefresh(
    RefreshEvent<T> event,
    Emitter<PaginationState<T>> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true, error: null));
    // Clear loading tracking on refresh
    _loadingPages.clear();
    try {
      final response = await fetchPage(1, pageSize);
      final items = response.items;
      final isLastPage = items.length < pageSize;

      // Update cache
      if (enableCache) {
        _cache.clear();
        _cache[1] = List<T>.from(items);
      }

      emit(
        PaginationState<T>(
          items: items,
          nextPageKey: isLastPage ? null : 2,
          hasReachedEnd: isLastPage,
          totalItems: response.totalItems,
          totalPages: response.totalPage,
          currentPage: response.currentPage ?? 1,
          isRefreshing: false,
        ),
      );
      // Prefetch next page
      if (!isLastPage && enableCache) {
        add(PrefetchEvent<T>(2));
      }
    } catch (error) {
      AppLog.e('Error refreshing: $error');
      emit(state.copyWith(isRefreshing: false, error: error.toString()));
    }
  }

  Future<void> _onClearCache(
    ClearCacheEvent<T> event,
    Emitter<PaginationState<T>> emit,
  ) async {
    _cache.clear();
  }

  Future<void> _onPrefetch(
    PrefetchEvent<T> event,
    Emitter<PaginationState<T>> emit,
  ) async {
    if (!enableCache ||
        _cache.containsKey(event.pageKey) ||
        _loadingPages.contains(event.pageKey)) {
      return;
    }

    // Mark as loading to prevent duplicates
    _loadingPages.add(event.pageKey);
    try {
      final response = await fetchPage(event.pageKey, pageSize);

      // Store in cache
      _cache[event.pageKey] = List<T>.from(response.items);
    } catch (error) {
      AppLog.e('Error prefetching page ${event.pageKey}: $error');
    } finally {
      // Always remove from loading set
      _loadingPages.remove(event.pageKey);
    }
  }
}
