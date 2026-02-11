import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:idara_esign/core/networking/networking.dart';
import 'package:idara_esign/core/services/logger_service.dart';

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
    switch (error) {
      case DioException():
        return _mapDioException(error);
      case SocketException() when !kIsWeb:
        return const NoInternetException();
      case TimeoutException():
        return const RequestTimeoutException();
      case CacheException():
        return const CacheException();
      case FormatException():
        return const CustomException("Invalid data format received.");
      default:
        return const UnknownException("An unknown error occurred.");
    }
  }

  /// Handles Dio-specific errors with detailed inspection.
  static AppException _mapDioException(DioException error) {
    final int statusCode = error.response?.statusCode ?? 0;
    final dynamic data = error.response?.data;
    final String message = _extractMessage(data);
    switch (error.type) {
      case DioExceptionType.cancel:
        return const CustomException("Request was cancelled.");
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const RequestTimeoutException();
      case DioExceptionType.badResponse:
        return _mapStatusCodeToException(statusCode, message);
      case DioExceptionType.badCertificate:
        return const CustomException("Bad certificate received from server.");
      case DioExceptionType.connectionError:
        return const NoInternetException();
      case DioExceptionType.unknown:
        return UnknownException(error.message ?? "Unexpected Dio error.");
    }
  }

  /// Maps HTTP status codes to proper AppExceptions.
  static AppException _mapStatusCodeToException(int code, String message) {
    switch (code) {
      case 400:
        return BadRequestException(message);
      case 401:
      case 403:
        return UnauthorizedException(message);
      case 422:
        return InvalidInputException(message);
      default:
        return FetchDataException("Unexpected server response: $code");
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
