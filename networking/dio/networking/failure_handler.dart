import 'package:dio/dio.dart';
import 'package:mobile_developer_test/core/helpers/networking/error/error.dart';

// Api Exceptions
class FailureHandler implements Exception {
  late Failure failure;

  FailureHandler.handle(dynamic error) {
    if (error is DioException) {
      failure = _dioHandleError(error);
    } else if (error is CacheException) {
      failure = CacheFailure(message: error.message);
    } else {
      failure = UnknownFailure(message: error.message.toString());
    }
  }

  Failure _dioHandleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const ServerFailure(message: 'Connection timeout');
        case DioExceptionType.badResponse:
          return ServerFailure(
            message: error.response?.data.toString() ?? 'Unknown error',
            statusCode: error.response?.statusCode ?? 500,
          );
        case DioExceptionType.cancel:
          return const ServerFailure(message: 'Request was cancelled');
        default:
          return ServerFailure(message: error.message ?? 'Unknown error');
      }
    }
    return ServerFailure(message: error.massage.toString());
  }
}
