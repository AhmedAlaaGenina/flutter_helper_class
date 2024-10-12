import 'dart:async';

import 'package:mobile_developer_test/core/helpers/networking/networking.dart';

 class CallerDataHandler {
  static Future<Result<T>> call<T>(Future<T> Function() call) async {
    try {
      final res = await call();
      return Result.success(res);
    } catch (e) {
      return Result.failure(FailureHandler.handle(e));
    }
  }
}


