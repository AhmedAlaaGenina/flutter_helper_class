import 'package:dio/dio.dart';
import 'package:mobile_developer_test/core/helpers/networking/networking.dart';

/// Abstract class defining the interface for API services

abstract class ApiService {
  // GET method
  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
    RetryOptions? retryOptions,
  });

  // POST method
  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    RetryOptions? retryOptions,
  });

  // PUT method
  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    RetryOptions? retryOptions,
  });

  // DELETE method
  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    RetryOptions? retryOptions,
  });

  // PATCH method
  Future<Response<T>> patch<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
    RetryOptions? retryOptions,
  });

  // HEAD method
  Future<Response<T>> head<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    RetryOptions? retryOptions,
  });

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
    RetryOptions? retryOptions,
  });

  // Multipart request
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
  });

  // Retryable request
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
  });
}
