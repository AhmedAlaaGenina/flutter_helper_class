import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:infinite_scroll_pagination_package/app_log.dart';
import 'package:infinite_scroll_pagination_package/networking/dio/networking_freezed/networking_freezed.dart';

class ApiFailureHandler {
  ApiFailureHandler._();

  /// Entry point to handle and convert any thrown error to a [Failure].
  static AppFailure handle(dynamic error) {
    final AppException exception = _mapErrorToAppException(error);
    _logError(error, exception);
    return exception.toFailure();
  }

  /// Maps all types of errors (Dio, Socket, Timeout, etc.) to an [AppException].
  static AppException _mapErrorToAppException(dynamic error) {
    switch (error.runtimeType) {
      case DioException _:
        return _mapDioException(error as DioException);
      case SocketException _:
        return const NoInternetException();
      case TimeoutException _:
        return const RequestTimeoutException();
      case LocalStorageException _:
        return LocalStorageException();
      case FormatException _:
        return const InvalidInputException();

      default:
        return const UnknownException();
    }
  }

  /// Handles Dio-specific errors with detailed inspection.
  static AppException _mapDioException(DioException error) {
    final int statusCode = error.response?.statusCode ?? 0;
    final dynamic data = error.response?.data;
    final String message = _extractMessage(data);

    switch (error.type) {
      case DioExceptionType.cancel:
        return const CustomException(message: "Request was cancelled.");
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const RequestTimeoutException();
      case DioExceptionType.badResponse:
        return _mapStatusCodeToException(statusCode, message);
      case DioExceptionType.badCertificate:
        return const CustomException(
          message: "Bad certificate received from server.",
        );
      case DioExceptionType.connectionError:
        return const NoInternetException();
      case DioExceptionType.unknown:
        return UnknownException(
          message: error.message ?? "Unexpected Dio error.",
        );
    }
  }

  /// Maps HTTP status codes to proper AppExceptions.
  static AppException _mapStatusCodeToException(int code, String message) {
    switch (code) {
      case 400:
        return BadRequestException(message: message);
      case 401:
      case 403:
        return const UnauthorizedException();
      case 422:
        return InvalidInputException(message: message);
      default:
        return FetchDataException(message: "Unexpected server response: $code");
    }
  }

  /// Extracts human-readable message from a server response.
  static String _extractMessage(dynamic data) {
    try {
      if (data is Map<String, dynamic>) {
        if (data.containsKey('message')) return data['message'].toString();
        if (data.containsKey('error')) {
          final error = data['error'];
          if (error is String) return error;
          if (error is Map && error.containsKey('message')) {
            return error['message'].toString();
          }
        }
      }
    } catch (_) {}
    return "Something went wrong.";
  }

  /// Logs the original and mapped error types.
  static void _logError(dynamic original, AppException mapped) {
    AppLog.w("[ApiFailureHandler] Original error: $original");
    AppLog.e(
      "[ApiFailureHandler] Mapped to: ${mapped.runtimeType} — ${mapped.message}",
      mapped.runtimeType,
    );
  }
}
