import 'package:infinite_scroll_pagination_package/networking/dio/networking_freezed/networking_freezed.dart';

class ApiCallHandler {
  static Future<Result<T>> handle<T>(
    Future<T> Function() apiCall, {
    String? tag,
  }) async {
    try {
      final result = await apiCall();
      // Check for statusCode == -100 in the response
      if (result is Map<String, dynamic> && result['statusCode'] == -100) {
        final message =
            result['message'] ?? "Something went wrong. Please try again.";
        throw CustomException(message: message);
      }
      return Result.success(result);
    } catch (error) {
      final failure = ApiFailureHandler.handle(error);
      return Result.failure(failure);
    }
  }
}
