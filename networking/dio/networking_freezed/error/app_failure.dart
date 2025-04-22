import 'package:freezed_annotation/freezed_annotation.dart';

part 'app_failure.freezed.dart';

@freezed
sealed class AppFailure with _$AppFailure {
  const factory AppFailure({
    required String message,
    int? code,
    Map<String, dynamic>? data,
  }) = _AppFailure;

  const factory AppFailure.network({
    required String message,
    int? code,
    Map<String, dynamic>? data,
  }) = NetworkFailure;

  const factory AppFailure.server({
    required String message,
    int? code,
    Map<String, dynamic>? data,
  }) = ServerFailure;

  const factory AppFailure.localStorage({
    @Default("Local storage failure.") String message,
    int? code,
    Map<String, dynamic>? data,
  }) = LocalStorageFailure;

  const factory AppFailure.unknown({
    @Default("An unknown error occurred.") String message,
    int? code,
    Map<String, dynamic>? data,
  }) = UnknownFailure;
}
