import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';

class RetryInterceptor extends Interceptor {
  final Dio dio;
  final int maxRetries;
  final Duration initialDelay;
  final Duration maxDelay;
  final bool shouldRetryOnTimeout;

  RetryInterceptor({
    required this.dio,
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 30),
    this.shouldRetryOnTimeout = true,
  });

  int get defaultMaxRetries => maxRetries;
  Duration get defaultInitialDelay => initialDelay;
  
  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final extraMap = err.requestOptions.extra;
    final retryCount = extraMap['retryCount'] ?? 0;
    final maxRetries = extraMap['maxRetries'] ?? this.maxRetries;
    final retryDelay = extraMap['retryDelay'] ?? initialDelay;
    if (shouldRetry(err) && retryCount < maxRetries) {
      final delay = _calculateDelay(retryCount, retryDelay);
      extraMap['retryCount'] = retryCount + 1;

      await Future.delayed(delay);

      try {
        final options = Options(
          method: err.requestOptions.method,
          headers: err.requestOptions.headers,
          extra: extraMap,
        );

        final response = await dio.request(
          err.requestOptions.path,
          data: err.requestOptions.data,
          queryParameters: err.requestOptions.queryParameters,
          options: options,
        );

        return handler.resolve(response);
      } catch (e) {
        return super.onError(err, handler);
      }
    }

    return super.onError(err, handler);
  }

  bool shouldRetry(DioException err) {
    // err.type == DioExceptionType.connectionTimeout ||
    return err.type == DioExceptionType.receiveTimeout ||
        (err.error is SocketException) ||
        (err.response?.statusCode != null &&
            err.response!.statusCode! >= 500) ||
        (shouldRetryOnTimeout &&
            err.type == DioExceptionType.connectionTimeout);
  }

  Duration _calculateDelay(int retryCount, Duration baseDelay) {
    // Exponential backoff with jitter
    final exponentialDelay = baseDelay * (pow(2, retryCount) as int);
    final withJitter = exponentialDelay * (0.5 + Random().nextDouble() / 2);
    return Duration(
      milliseconds: min(withJitter.inMilliseconds, maxDelay.inMilliseconds),
    );
  }
}
