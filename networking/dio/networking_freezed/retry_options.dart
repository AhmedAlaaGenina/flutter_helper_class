import 'package:freezed_annotation/freezed_annotation.dart';

part 'retry_options.freezed.dart';

@freezed
sealed class RetryOptions with _$RetryOptions {
  const factory RetryOptions({
    required int maxRetries,
    required Duration retryDelay,
  }) = _RetryOptions;
}
