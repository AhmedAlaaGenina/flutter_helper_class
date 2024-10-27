import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mobile_developer_test/core/helpers/networking/networking.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiServiceImpl implements ApiService {
  final Dio _dio;
  final int defaultMaxRetries;
  final Duration defaultRetryDelay;
  ApiServiceImpl(
    this._dio, {
    this.defaultMaxRetries = 3,
    this.defaultRetryDelay = const Duration(seconds: 1),
  }) {
    _dio.interceptors.addAll([
      PrettyDioLogger(),
      RetryInterceptor(
        dio: _dio,
        maxRetries: defaultMaxRetries,
        initialDelay: defaultRetryDelay,
      ),
    ]);
  }

//  getIt.registerLazySingleton<Dio>(
//     () => Dio(
//       BaseOptions(
//         baseUrl: ApiConstant.baseUrl,
//         connectTimeout: const Duration(seconds: 30),
//         receiveTimeout: const Duration(seconds: 30),
//         sendTimeout: const Duration(seconds: 30),
//         headers: {
//           'Accept': 'application/json',
//           'Content-Type': 'application/json',
//         },
//       ),
//     ),
//   );

  //? How to cancel request
  // CancelToken? _uploadCancelToken = CancelToken();
  // ! pass _uploadCancelToken to cancel in Call method
  // void cancelUpload() {
  //   _uploadCancelToken?.cancel('User cancelled the upload');
  // }

  // GET method
  @override
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
    RetryOptions? retryOptions,
  }) async {
    options = _mergeRetryOptions(options, retryOptions);
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
  @override
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    RetryOptions? retryOptions,
  }) async {
    options = _mergeRetryOptions(options, retryOptions);
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
  @override
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    RetryOptions? retryOptions,
  }) async {
    options = _mergeRetryOptions(options, retryOptions);
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
  @override
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    RetryOptions? retryOptions,
  }) async {
    options = _mergeRetryOptions(options, retryOptions);
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
  @override
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    RetryOptions? retryOptions,
  }) async {
    options = _mergeRetryOptions(options, retryOptions);
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
  @override
  Future<Response<T>> head<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    RetryOptions? retryOptions,
  }) async {
    options = _mergeRetryOptions(options, retryOptions);
    final response = await _dio.head<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
    return response;
  }

  // Example of file download
  // try {
  //   await apiService.download(
  //     'https://example.com/files/document.pdf',
  //     '/path/to/save/document.pdf',
  //     onReceiveProgress: (received, total) {
  //       if (total != -1) {
  //         final progress = (received / total * 100).toStringAsFixed(0);
  //         print('Download progress: $progress%');
  //       }
  //     },
  //   );
  //   print('File downloaded successfully');
  // } catch (e) {
  //   print('Error downloading file: $e');
  // }
  // Download file
  @override
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
    RetryOptions? retryOptions,
  }) async {
    options = _mergeRetryOptions(options, retryOptions);
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

  // Example of multipart request for file upload
  // try {
  //   final response = await apiService.multipartRequest<Map<String, dynamic>>(
  //     '/upload',
  //     'POST',
  //     files: {'file': '/path/to/local/file.pdf'},
  //     data: {'description': 'My uploaded file'},
  //     onSendProgress: (sent, total) {
  //       final progress = (sent / total * 100).toStringAsFixed(0);
  //       print('Upload progress: $progress%');
  //     },
  //   );
  //   print('File uploaded successfully: ${response.data}');
  // } catch (e) {
  //   print('Error uploading file: $e');
  // }
  // Multipart request helper
  @override
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
    RetryOptions? retryOptions,
  }) async {
    options = _mergeRetryOptions(options, retryOptions);

    final formData = FormData.fromMap({
      if (data != null) ...data,
      for (var entry in files.entries)
        entry.key: await MultipartFile.fromFile(entry.value),
    });

    final response = await _dio.request<T>(
      path,
      data: formData,
      queryParameters: queryParameters,
      options: options.copyWith(method: method),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }

  // Helper method to merge retry options
  Options _mergeRetryOptions(Options? options, RetryOptions? retryOptions) {
    final mergedOptions = options ?? Options();
    mergedOptions.extra ??= {};

    if (retryOptions != null) {
      mergedOptions.extra!['maxRetries'] = retryOptions.maxRetries;
      mergedOptions.extra!['retryDelay'] = retryOptions.retryDelay;
    } else if (!mergedOptions.extra!.containsKey('maxRetries')) {
      // Use default values if not specified
      mergedOptions.extra!['maxRetries'] = defaultMaxRetries;
      mergedOptions.extra!['retryDelay'] = defaultRetryDelay;
    }

    return mergedOptions;
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
  @override
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
}
