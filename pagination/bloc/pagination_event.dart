part of 'pagination_bloc.dart';

abstract class PaginationEvent extends Equatable {
  const PaginationEvent();

  @override
  List<Object?> get props => [];
}

class LoadPageEvent<T> extends PaginationEvent {
  final int pageKey;

  const LoadPageEvent(this.pageKey);

  @override
  List<Object?> get props => [pageKey];
}

class RefreshEvent<T> extends PaginationEvent {
  const RefreshEvent();

  @override
  List<Object?> get props => [];
}

class ClearCacheEvent<T> extends PaginationEvent {
  const ClearCacheEvent();

  @override
  List<Object?> get props => [];
}

class PrefetchEvent<T> extends PaginationEvent {
  final int pageKey;

  const PrefetchEvent(this.pageKey);

  @override
  List<Object?> get props => [pageKey];
}

class SetLoadingMoreEvent<T> extends PaginationEvent {
  const SetLoadingMoreEvent();

  @override
  List<Object?> get props => [];
}
