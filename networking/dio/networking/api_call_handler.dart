import 'package:dartz/dartz.dart';
import 'package:infinite_scroll_pagination_package/networking/networking.dart';

typedef Result<T> = Either<AppFailure, T>;

class ApiCallHandler {
  static Future<Result<T>> handle<T>(
    Future<T> Function() apiCall, {
    String? tag,
  }) async {
    try {
      final result = await apiCall();
      // Check for statusCode == -100 in the response {Use for custom error handling}
      // if (result is Map<String, dynamic> && result['statusCode'] == -100) {
      //   final message =
      //       result['message'] ?? "Something went wrong. Please try again.";
      //   throw CustomException(message);
      // }
      return Right(result);
    } catch (error) {
      final failure = ApiFailureHandler.handle(error);
      return Left(failure);
    }
  }
}
