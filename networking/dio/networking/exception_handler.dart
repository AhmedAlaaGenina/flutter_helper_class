import 'package:dio/dio.dart';

// Api Exceptions
class ExceptionHandler implements Exception {
  late Exception exception;

  ExceptionHandler.handle(dynamic error, {bool isLocal = false}) {
    if (error is DioException) {
      exception = _apiHandleError(error);
    } else if (isLocal) {
      exception = LocalStorageException(
          "Failed to load data from local storage - $error");
    } else {
      exception = UnknownException(error.toString());
    }
  }

  Exception _apiHandleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ApiTimeoutException('Connection timeout');
        case DioExceptionType.badResponse:
          return BadResponseException(
            error.response?.statusCode ?? 500,
            error.response?.data.toString() ?? 'Unknown error',
          );
        case DioExceptionType.cancel:
          return RequestCancelledException();
        default:
          return NetworkException(error.message ?? 'Unknown error');
      }
    }
    return UnknownException(error.toString());
  }
}

// Custom Exceptions
class LocalStorageException implements Exception {
  final String message;
  LocalStorageException(this.message);

  @override
  String toString() => 'LocalStorageException: $message';
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);

  @override
  String toString() => 'NetworkException: $message';
}

class BadResponseException implements Exception {
  final int statusCode;
  final String message;
  BadResponseException(this.statusCode, this.message);

  @override
  String toString() => 'BadResponseException: Status $statusCode - $message';
}

class ApiTimeoutException implements Exception {
  final String message;
  ApiTimeoutException(this.message);

  @override
  String toString() => 'ApiTimeoutException: $message';
}

class RequestCancelledException implements Exception {
  @override
  String toString() => 'RequestCancelledException: Request was cancelled';
}

class UnknownException implements Exception {
  final String message;
  UnknownException(this.message);

  @override
  String toString() => 'UnknownException: $message';
}
