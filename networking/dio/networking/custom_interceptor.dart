import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:idara_esign/app.dart';
import 'package:idara_esign/di/injection_container.dart' as di;
import 'package:idara_esign/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:idara_esign/features/auth/presentation/bloc/auth_event.dart';
import 'package:idara_esign/generated/l10n.dart';

import '../constants/api_constants.dart';
import '../constants/storage_keys.dart';
import '../security/secure_storage.dart';

class CustomInterceptor extends Interceptor {
  final SecureStorage _secureStorage;

  static DateTime? _last401Time;
  static const Duration _debounceWindow = Duration(seconds: 5);

  CustomInterceptor({required SecureStorage secureStorage})
    : _secureStorage = secureStorage;

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await _secureStorage.read(key: StorageKeys.authToken);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (e) {
      debugPrint('Failed to attach auth token: $e');
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final transformedError = _transformError(err);

    // Handle 401 Unauthorized with debounced logout
    if (_isUnauthorizedResponse(err) && _shouldHandle401(err.requestOptions)) {
      _handleUnauthorized();
    }

    handler.next(transformedError);
  }

  DioException _transformError(DioException err) {
    final message = switch (err.type) {
      DioExceptionType.connectionTimeout => S.current.connectionTimeout,
      DioExceptionType.sendTimeout => S.current.requestTimeout,
      DioExceptionType.receiveTimeout => S.current.serverTooLongToRespond,
      DioExceptionType.cancel => S.current.requestCancelled,
      DioExceptionType.unknown => S.current.networkErrorCheckConnection,
      DioExceptionType.badResponse => _getResponseErrorMessage(err),
      _ => S.current.unexpectedError,
    };

    return err.copyWith(message: message);
  }

  String _getResponseErrorMessage(DioException err) {
    final statusCode = err.response?.statusCode;

    return switch (statusCode) {
      400 => S.current.badRequestCheckInput,
      401 => S.current.unauthorizedPleaseLogin,
      403 => S.current.accessForbidden,
      404 => S.current.resourceNotFound,
      500 => S.current.serverErrorTryLater,
      503 => S.current.serviceUnavailableTryLater,
      _ => _extractBackendMessage(err) ?? S.current.genericErrorTryAgain,
    };
  }

  String? _extractBackendMessage(DioException err) {
    final data = err.response?.data;
    if (data is! Map<String, dynamic>) return null;

    final message = data['message'];
    return (message is String && message.trim().isNotEmpty)
        ? message.trim()
        : null;
  }

  bool _isUnauthorizedResponse(DioException err) {
    return err.type == DioExceptionType.badResponse &&
        err.response?.statusCode == 401;
  }

  bool _shouldHandle401(RequestOptions options) {
    return !_isLoginRequest(options) && !_isLogoutOrRevokeRequest(options);
  }

  bool _isLoginRequest(RequestOptions options) {
    return options.path.contains(ApiEndpoints.login);
  }

  bool _isLogoutOrRevokeRequest(RequestOptions options) {
    final path = options.path;
    return path.contains(ApiEndpoints.revokeAllTokens) ||
        path.contains('logout') ||
        path.contains('revoke');
  }

  void _handleUnauthorized() {
    if (!_shouldTrigger401Handler()) return;

    _last401Time = DateTime.now();
    _showSessionExpiredSnackBar();
    _triggerLogout();
  }

  bool _shouldTrigger401Handler() {
    if (_last401Time == null) return true;

    final timeSinceLastTrigger = DateTime.now().difference(_last401Time!);
    if (timeSinceLastTrigger < _debounceWindow) {
      debugPrint('🕒 401 already handled recently - skipping duplicate');
      return false;
    }

    return true;
  }

  void _showSessionExpiredSnackBar() {
    try {
      final messenger = rootScaffoldMessengerKey.currentState;
      messenger?.removeCurrentSnackBar();
      messenger?.showSnackBar(
        SnackBar(
          content: Text(S.current.sessionExpiredPleaseLogin),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      debugPrint('Failed to show session expired snackbar: $e');
    }
  }

  void _triggerLogout() {
    try {
      di.getIt<AuthBloc>().add(const LogoutEvent());
    } catch (e) {
      debugPrint('Failed to trigger logout: $e');
    }
  }
}
