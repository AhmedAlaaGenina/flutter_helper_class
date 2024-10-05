import 'dart:async';

import 'package:fashion/core/networking/networking.dart';

class ApiExceptionHandler {
  static Future<Result<T>> handleException<T>(
    Future<T> Function() call,
  ) async {
    try {
      final res = await call();
      return Result.success(res);
    } catch (e) {
      return Result.failure(ErrorHandler.handle(e));
    }
  }
}

class LocalExceptionHandler {
  static Future<Result<T>> handleException<T>(
    Future<T> Function() call,
  ) async {
    try {
    final res = await call();
    return Result.success(res);
    } catch (e) {
      return Result.failure(ErrorHandler.handle(e, isLocal: true));
    }
  }
}
