import 'package:dartz/dartz.dart';
import 'package:idara_esign/core/networking/networking.dart';

typedef Result<T> = Either<AppFailure, T>;

class ApiCallHandler {
  static Future<Result<T>> handle<T>(
    Future<T> Function() apiCall, {
    String? tag,
  }) async {
    try {
      final result = await apiCall();
      return Right(result);
    } catch (error) {
      final failure = ApiFailureHandler.handle(error);
      return Left(failure);
    }
  }
}
