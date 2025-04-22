import 'package:logger/logger.dart';

class AppLog {
  AppLog._();

  static final Logger _logger = Logger();

  static void d(String message) {
    _logger.d(message);
  }

  static void i(String message) {
    _logger.i(message);
  }

  static void w(String message) {
    _logger.w(message);
  }

  static void e(String message, [dynamic error]) {
    _logger.e(message, error: error, stackTrace: StackTrace.current);
  }

  static void t(String message) {
    _logger.t(message);
  }

  static void f(String message) {
    _logger.f(message);
  }
}
