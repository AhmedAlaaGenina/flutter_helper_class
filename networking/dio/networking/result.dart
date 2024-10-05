import 'package:freezed_annotation/freezed_annotation.dart';

part 'result.freezed.dart';

@Freezed()
abstract class Result<T> with _$Result<T> {
  const factory Result.success(T data) = Success<T>;
  const factory Result.error(Exception exception) = Error<T>;
}
