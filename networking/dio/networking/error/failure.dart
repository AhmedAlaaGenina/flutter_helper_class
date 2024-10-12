import 'package:freezed_annotation/freezed_annotation.dart';

part 'failure.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.server({
    required String message,
    int? statusCode,
  }) = ServerFailure;

  const factory Failure.cache({
    required String message,
    int? statusCode,
  }) = CacheFailure;

  const factory Failure.unknown({
    required String message,
    int? statusCode,
  }) = UnknownFailure;
}
