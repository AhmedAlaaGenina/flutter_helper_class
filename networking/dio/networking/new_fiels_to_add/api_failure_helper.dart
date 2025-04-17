import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:hr_app/core/helpers/app_log.dart';
import 'package:hr_app/core/network/app_exception.dart';
import 'package:hr_app/core/network/failure.dart';

class ApiFailureHandler {
  ApiFailureHandler._();

  /// Entry point to handle and convert any thrown error to a [Failure].
  static Failure handle(dynamic error) {
    final AppException exception = _mapErrorToAppException(error);
    _logError(error, exception);
    return _mapAppExceptionToFailure(exception);
  }

  /// Maps all types of errors (Dio, Socket, Timeout, etc.) to an [AppException].
  static AppException _mapErrorToAppException(dynamic error) {
    switch (error.runtimeType) {
      case DioException:
        return _mapDioException(error as DioException);
      case SocketException:
        return const NoInternetException();
      case TimeoutException:
        return const RequestTimeoutException();
      case LocalStorageException:
        return LocalStorageException();
      case FormatException:
        return const GeneralException("Invalid data format received.");

      default:
        return const GeneralException("An unknown error occurred.");
    }
  }

  /// Handles Dio-specific errors with detailed inspection.
  static AppException _mapDioException(DioException error) {
    final int statusCode = error.response?.statusCode ?? 0;
    final dynamic data = error.response?.data;
    final String message = _extractMessage(data);

    switch (error.type) {
      case DioExceptionType.cancel:
        return const GeneralException("Request was cancelled.");
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const RequestTimeoutException();
      case DioExceptionType.badResponse:
        return _mapStatusCodeToException(statusCode, message);
      case DioExceptionType.badCertificate:
        return const GeneralException("Bad certificate received from server.");
      case DioExceptionType.connectionError:
        return const NoInternetException();
      case DioExceptionType.unknown:
        return GeneralException(error.message ?? "Unexpected Dio error.");
    }
  }

  /// Maps HTTP status codes to proper AppExceptions.
  static AppException _mapStatusCodeToException(int code, String message) {
    switch (code) {
      case 400:
        return BadRequestException(message);
      case 401:
      case 403:
        return const UnauthorisedException();
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

  /// Maps the final AppException to a domain-level Failure.
  static Failure _mapAppExceptionToFailure(AppException exception) {
    switch (exception.runtimeType) {
      case FetchDataException:
      case BadRequestException:
      case CustomStatusException:
        return ServerFailure(exception.message);
      case NoInternetException:
      case RequestTimeoutException:
        return NetworkFailure(exception.message);
      case UnauthorisedException:
        return ServerFailure(exception.message);
      case LocalStorageException:
        return LocalStorageFailure(exception.message);
      default:
        return UnknownFailure(exception.message);
    }
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
