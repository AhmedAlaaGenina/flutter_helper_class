import 'package:equatable/equatable.dart';

abstract class AsyncResult<T> extends Equatable {
  const AsyncResult();

  const factory AsyncResult.initial() = AsyncResultInitial<T>;
  const factory AsyncResult.loading() = AsyncResultLoading<T>;
  const factory AsyncResult.success(T data) = AsyncResultSuccess<T>;
  const factory AsyncResult.failure(String error) = AsyncResultFailure<T>;

  T? get data => this is AsyncResultSuccess<T>
      ? (this as AsyncResultSuccess<T>).data
      : null;
  String? get error => this is AsyncResultFailure<T>
      ? (this as AsyncResultFailure<T>).error
      : null;

  bool get isInitial => this is AsyncResultInitial<T>;
  bool get isLoading => this is AsyncResultLoading<T>;
  bool get isSuccess => this is AsyncResultSuccess<T>;
  bool get isFailure => this is AsyncResultFailure<T>;

  @override
  List<Object?> get props => [];
}

class AsyncResultInitial<T> extends AsyncResult<T> {
  const AsyncResultInitial();
}

class AsyncResultLoading<T> extends AsyncResult<T> {
  const AsyncResultLoading();
}

class AsyncResultSuccess<T> extends AsyncResult<T> {
  final T data;
  const AsyncResultSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class AsyncResultFailure<T> extends AsyncResult<T> {
  final String error;
  const AsyncResultFailure(this.error);

  @override
  List<Object?> get props => [error];
}
