import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late Dio _dio;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://api.example.com', // Replace with your API base URL
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    )..interceptors.addAll([
        PrettyDioLogger(),
        RetryInterceptor(),
      ]);
  }

  //? How to cancel request
  // CancelToken? _uploadCancelToken = CancelToken();
  // ! pass _uploadCancelToken to cancel in Call method
  // void cancelUpload() {
  //   _uploadCancelToken?.cancel('User cancelled the upload');
  // }

  // GET method
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final response = await _dio.get<T>(
      path,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }

  // POST method
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final response = await _dio.post<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }

  // PUT method
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final response = await _dio.put<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }

  // DELETE method
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.delete<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    return response;
  }

  // PATCH method
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final response = await _dio.patch<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }

  // HEAD method
  Future<Response<T>> head<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.head<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    return response;
  }

  // Download file
  Future<Response> download(
    String urlPath,
    String savePath, {
    void Function(int, int)? onReceiveProgress,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    bool deleteOnError = true,
    String lengthHeader = Headers.contentLengthHeader,
    dynamic data,
    Options? options,
  }) async {
    final response = await _dio.download(
      urlPath,
      savePath,
      onReceiveProgress: onReceiveProgress,
      queryParameters: queryParameters,
      cancelToken: cancelToken,
      deleteOnError: deleteOnError,
      lengthHeader: lengthHeader,
      data: data,
      options: options,
    );
    return response;
  }

  // Multipart request helper
  Future<Response<T>> multipartRequest<T>(
    String path,
    String method, {
    required Map<String, dynamic> files,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    final formData = FormData.fromMap({
      if (data != null) ...data,
      for (var entry in files.entries)
        entry.key: await MultipartFile.fromFile(entry.value),
    });

    final response = await _dio.request<T>(
      path,
      data: formData,
      queryParameters: queryParameters,
      options: options?.copyWith(method: method) ?? Options(method: method),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }
  //? Here's how to use each approach:
  //! 1. Automatic Retry (via Interceptor)
  // This happens automatically for all requests:
  // try {
  //   final response = await apiService.get('/endpoint',
  //       options: Options(extra: {'retryCount': 0}),); //? For handle Number of retries
  // Success
  // } catch (e) {
  // All retries failed
  // }

  //! 2. Manual Retry
  //* final cancelToken = CancelToken();
  // try {
  //   final response = await apiService.retryableRequest<Map<String, dynamic>>(
  //     '/complex-endpoint',
  //     method: 'POST', //! Must Be in uppercase
  //     data: {'key': 'value'},
  //     maxRetries: 5, //! Max Retries
  //     retryDelay: Duration(seconds: 2),
  //     cancelToken: cancelToken,
  //     retryCondition: (error) {
  //       if (error.response?.statusCode == 429) { // Too Many Requests
  //         final retryAfter = error.response?.headers['retry-after']?.first;
  //         if (retryAfter != null) {
  //           final seconds = int.tryParse(retryAfter);
  //           if (seconds != null) {
  //             return true;
  //           }
  //         }
  //       }
  //       return error.type == DioExceptionType.connectionTimeout;
  //     },
  //     onRetry: (attemptNumber, exception) {
  //       if (attemptNumber == 3) {
  //         cancelToken.cancel('Cancelling after 3 retries');
  //       }
  //     },
  //   );

  //   print('Success: ${response.data}');
  // } catch (e) {
  //   print('Failed: $e');
  // }

  // Retry request for manual retry
  Future<Response<T>> retryableRequest<T>(
    String path, {
    String method = 'GET',
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    int maxRetries = 3,
    Duration? retryDelay,
    bool Function(DioException)? retryCondition,
    void Function(int, Exception)? onRetry,
  }) async {
    int attempts = 0;
    late Exception lastException;

    while (attempts < maxRetries) {
      try {
        final response = await _dio.request<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options?.copyWith(method: method) ?? Options(method: method),
          cancelToken: cancelToken,
        );
        return response;
      } on DioException catch (e) {
        lastException = e;
        attempts++;

        final shouldRetry =
            retryCondition?.call(e) ?? _defaultRetryCondition(e);

        if (!shouldRetry || attempts >= maxRetries) {
          rethrow;
        }

        onRetry?.call(attempts, e);

        if (retryDelay != null) {
          await Future.delayed(retryDelay);
        }
      }
    }

    throw lastException;
  }

  bool _defaultRetryCondition(DioException error) {
    return error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.error is SocketException ||
        (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500);
  }

  Dio get dio => _dio;
}

class RetryInterceptor extends Interceptor {
  final int maxRetries;
  final Duration initialDelay;
  final Duration maxDelay;
  final bool shouldRetryOnTimeout;

  RetryInterceptor({
    this.maxRetries = 3,
    this.initialDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 30),
    this.shouldRetryOnTimeout = true,
  });

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    final extraMap = err.requestOptions.extra;
    final retryCount = extraMap['retryCount'] ?? 0;

    if (shouldRetry(err) && retryCount < maxRetries) {
      final delay = _calculateDelay(retryCount);
      extraMap['retryCount'] = retryCount + 1;

      await Future.delayed(delay);

      try {
        final options = Options(
          method: err.requestOptions.method,
          headers: err.requestOptions.headers,
          extra: extraMap,
        );

        final dio = ApiService().dio;
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
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        (err.error is SocketException) ||
        (err.response?.statusCode != null &&
            err.response!.statusCode! >= 500) ||
        (shouldRetryOnTimeout &&
            err.type == DioExceptionType.connectionTimeout);
  }

  Duration _calculateDelay(int retryCount) {
    // Exponential backoff with jitter
    final exponentialDelay = initialDelay * (pow(2, retryCount) as int);
    final withJitter = exponentialDelay * (0.5 + Random().nextDouble() / 2);
    return Duration(
        milliseconds: min(withJitter.inMilliseconds, maxDelay.inMilliseconds));
  }
}
