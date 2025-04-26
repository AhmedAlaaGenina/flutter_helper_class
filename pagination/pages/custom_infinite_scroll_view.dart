import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination_package/features/pagination/bloc/pagination_bloc.dart';
import 'package:infinite_scroll_pagination_package/features/pagination/models/pagination_response.dart';
import 'package:infinite_scroll_pagination_package/features/pagination/widgets/widgets.dart';

class CustomInfiniteScrollView<T> extends StatefulWidget {
  final Future<PaginationResponse<T>> Function(int pageKey, int pageSize)
  fetchPage;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final Widget Function(BuildContext)? firstPageProgressIndicator;
  final Widget Function(BuildContext)? newPageProgressIndicator;
  final Widget Function(BuildContext)? noItemsFound;
  final Widget Function(BuildContext)? noMoreItems;
  final Widget Function(BuildContext, String?)? firstPageErrorIndicator;
  final Widget Function(BuildContext, String?, VoidCallback)?
  newPageErrorIndicator;

  /// The minimum scrollable distance threshold before loading more
  final double scrollThreshold;

  /// The page size for each request
  final int pageSize;

  /// Enable list items caching
  final bool enableCaching;

  /// Enable item animations
  final bool animateItems;

  /// Layout type: list or grid
  final PaginationLayoutType layoutType;

  /// Grid delegate in case of grid layout
  final SliverGridDelegate? gridDelegate;

  /// Show header with pagination info
  final bool showHeader;

  /// Separator builder for list layout
  final Widget Function(BuildContext, int)? separatorBuilder;
  final bool enableItemAnimations;

  const CustomInfiniteScrollView({
    super.key,
    required this.fetchPage,
    required this.itemBuilder,
    this.firstPageProgressIndicator,
    this.newPageProgressIndicator,
    this.noItemsFound,
    this.noMoreItems,
    this.firstPageErrorIndicator,
    this.newPageErrorIndicator,
    this.scrollThreshold = 200,
    this.pageSize = 20,
    this.enableCaching = true,
    this.animateItems = true,
    this.layoutType = PaginationLayoutType.list,
    this.gridDelegate,
    this.showHeader = true,
    this.separatorBuilder,
    this.enableItemAnimations = true,
  }) : assert(
         layoutType != PaginationLayoutType.grid || gridDelegate != null,
         'gridDelegate is required for grid layout',
       );

  @override
  State<CustomInfiniteScrollView<T>> createState() =>
      _CustomInfiniteScrollViewState<T>();
}

class _CustomInfiniteScrollViewState<T>
    extends State<CustomInfiniteScrollView<T>>
    with AutomaticKeepAliveClientMixin {
  late PaginationBloc<T> _paginationBloc;
  late ScrollController _scrollController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _paginationBloc = PaginationBloc<T>(
      fetchPage: widget.fetchPage,
      pageSize: widget.pageSize,
      enableCache: widget.enableCaching,
    );
    _scrollController = ScrollController();

    _setupScrollListener();

    // Load the first page
    _paginationBloc.add(LoadPageEvent<T>(1));
  }

  // Update the scroll listener to be more efficient
  void _setupScrollListener() {
    _scrollController.addListener(() {
      // Only check if we should load more when we're near the bottom
      if (_isNearBottom()) {
        if (_shouldLoadNextPage()) {
          _paginationBloc.add(SetLoadingMoreEvent<T>());
        }
      }
    });
  }

  // Separate method to check if we're near bottom
  bool _isNearBottom() {
    if (!_scrollController.hasClients) return false;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final threshold = widget.scrollThreshold;

    return currentScroll >= maxScroll - threshold;
  }

  // Check if we should load the next page
  bool _shouldLoadNextPage() {
    final state = _paginationBloc.state;

    final canLoadMore =
        !state.isLoadingMore &&
        !state.isLoading &&
        !state.hasReachedEnd &&
        state.nextPageKey != null;

    return canLoadMore;
  }

  @override
  void dispose() {
    _paginationBloc.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return BlocProvider(
      create: (_) => _paginationBloc,
      child: BlocConsumer<PaginationBloc<T>, PaginationState<T>>(
        listenWhen:
            (previous, current) =>
                previous.isLoading != current.isLoading ||
                previous.error != current.error,
        listener: (context, state) {
          // Show snackbar for network errors while refreshing
          if (!state.isLoading && state.error != null && state.isRefreshing) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.error}'),
                action: SnackBarAction(
                  label: 'Retry',
                  onPressed: () => _paginationBloc.add(LoadPageEvent<T>(1)),
                ),
              ),
            );
          }
        },
        buildWhen: (previous, current) {
          // Only rebuild for meaningful state changes
          return previous.items != current.items ||
              previous.isLoading != current.isLoading ||
              previous.error != current.error ||
              previous.isLoadingMore != current.isLoadingMore ||
              previous.hasReachedEnd != current.hasReachedEnd ||
              previous.totalItems != current.totalItems;
        },
        builder: (context, state) {
          return Column(
            children: [
              // Header: Display pagination metadata
              if (widget.showHeader &&
                  state.totalItems != null &&
                  state.totalItems! > 0 &&
                  state.items.isNotEmpty)
                _buildHeader(state),

              // The main content
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _paginationBloc.add(RefreshEvent<T>());
                    await _paginationBloc.stream.firstWhere(
                      (state) => !state.isRefreshing,
                    );
                  },
                  child: _buildMainContent(state),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(PaginationState<T> state) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2.0,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Page: ${state.currentPage}/${state.totalPages ?? "?"}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).primaryColor,
            ),
          ),
          Text(
            'Items: ${state.items.length}/${state.totalItems}',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(PaginationState<T> state) {
    // Show first page loading indicator
    if (state.items.isEmpty && state.isLoading && !state.isRefreshing) {
      return widget.firstPageProgressIndicator?.call(context) ??
          SkeletonLoading(
            itemCount: widget.pageSize,
            layoutType: widget.layoutType,
          );
    }

    // Show first page error indicator
    if (state.items.isEmpty && state.error != null && !state.isRefreshing) {
      return widget.firstPageErrorIndicator?.call(context, state.error) ??
          PaginationErrorWidget(
            message: state.error,
            onRetry: () => _paginationBloc.add(LoadPageEvent<T>(1)),
          );
    }

    // Show empty indicator when no items and not loading
    if (state.items.isEmpty && !state.isLoading) {
      return widget.noItemsFound?.call(context) ??
          const EmptyContentWidget(
            message: 'No items found',
            icon: Icons.inbox_outlined,
          );
    }

    // Render list or grid based on layout type
    return widget.layoutType == PaginationLayoutType.grid
        ? _buildGridView(state)
        : _buildListView(state);
  }

  Widget _buildListView(PaginationState<T> state) {
    final itemCount =
        state.items.length +
        (state.isLoadingMore || state.hasReachedEnd || state.error != null
            ? 1
            : 0);

    if (widget.separatorBuilder != null) {
      return ListView.separated(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: itemCount,
        separatorBuilder: widget.separatorBuilder!,
        itemBuilder: (context, index) => _buildListItem(context, index, state),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => _buildListItem(context, index, state),
    );
  }

  Widget _buildGridView(PaginationState<T> state) {
    final itemCount =
        state.items.length +
        (state.isLoadingMore || state.hasReachedEnd || state.error != null
            ? 1
            : 0);

    return GridView.builder(
      controller: _scrollController,
      gridDelegate: widget.gridDelegate!,
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) => _buildListItem(context, index, state),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    int index,
    PaginationState<T> state,
  ) {
    // Regular item
    if (index < state.items.length) {
      if (widget.animateItems) {
        return AnimatedItemBuilderWidget(
          index: index,
          enableAnimation: widget.enableItemAnimations,
          child: widget.itemBuilder(context, state.items[index], index),
        );
      }

      return widget.itemBuilder(context, state.items[index], index);
    }

    // Footer
    return _buildFooter(state);
  }

  Widget _buildFooter(PaginationState<T> state) {
    if (state.isLoadingMore) {
      return widget.newPageProgressIndicator?.call(context) ??
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(child: CircularProgressIndicator()),
          );
    }

    if (state.error != null && state.items.isNotEmpty) {
      return widget.newPageErrorIndicator?.call(
            context,
            state.error,
            () => _paginationBloc.add(LoadPageEvent<T>(state.nextPageKey!)),
          ) ??
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PaginationErrorWidget(
              message: state.error,
              onRetry:
                  () =>
                      _paginationBloc.add(LoadPageEvent<T>(state.nextPageKey!)),
            ),
          );
    }

    if (state.hasReachedEnd) {
      return widget.noMoreItems?.call(context) ??
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: Center(
              child: Text(
                'You\'ve reached the end',
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              ),
            ),
          );
    }

    return const SizedBox.shrink();
  }
}

enum PaginationLayoutType { list, grid }
