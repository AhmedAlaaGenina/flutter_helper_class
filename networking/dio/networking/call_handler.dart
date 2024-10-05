import 'dart:async';

import 'package:mobile_developer_test/core/helpers/networking/networking.dart';

abstract class CallHandler {
  static Future<Result<T>> call<T>(
    Future<T> Function() call, {
    required bool isLocal,
  }) async {
    try {
      final res = await call();
      return Result.success(res);
    } catch (e) {
      return Result.error(ExceptionHandler.handle(e, isLocal: isLocal));
    }
  }
}

class ApiCallHandler extends CallHandler {
  static Future<Result<T>> call<T>(Future<T> Function() call) {
    return CallHandler.call(call, isLocal: false);
  }
}

class LocalCallHandler extends CallHandler {
  static Future<Result<T>> call<T>(Future<T> Function() call) {
    return CallHandler.call(call, isLocal: true);
  }
}
