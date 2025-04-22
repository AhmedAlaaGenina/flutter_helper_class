import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:infinite_scroll_pagination_package/networking/dio/networking_freezed/networking_freezed.dart';

part 'app_exception.freezed.dart';

@freezed
abstract class AppException with _$AppException implements Exception {
  const factory AppException({
    required String message,
    String? prefix,
    int? code,
    Map<String, dynamic>? data,
  }) = _AppException;

  const factory AppException.noInternet({
    @Default("No Internet connection. Please check your network.")
    String message,
    @Default("Network") String prefix,
    int? code,
    Map<String, dynamic>? data,
  }) = NoInternetException;

  const factory AppException.requestTimeout({
    @Default("Oops! Something took too long to load.") String message,
    @Default("Timeout") String prefix,
    int? code,
    Map<String, dynamic>? data,
  }) = RequestTimeoutException;

  const factory AppException.localStorage({
    @Default("Local storage error occurred.") String message,
    @Default("Storage") String prefix,
    int? code,
    Map<String, dynamic>? data,
  }) = LocalStorageException;

  const factory AppException.badRequest({
    @Default("Invalid request.") String message,
    @Default("Bad Request") String prefix,
    int? code,
    Map<String, dynamic>? data,
  }) = BadRequestException;

  const factory AppException.unauthorized({
    @Default("Unauthorized access.") String message,
    @Default("Auth") String prefix,
    int? code,
    Map<String, dynamic>? data,
  }) = UnauthorizedException;

  const factory AppException.invalidInput({
    @Default("Invalid input provided.") String message,
    @Default("Input Error") String prefix,
    int? code,
    Map<String, dynamic>? data,
  }) = InvalidInputException;

  const factory AppException.fetchData({
    @Default("Unable to fetch data.") String message,
    @Default("Fetch Error") String prefix,
    int? code,
    Map<String, dynamic>? data,
  }) = FetchDataException;

  const factory AppException.custom({
    required String message,
    @Default("Custom Status") String prefix,
    int? code,
    Map<String, dynamic>? data,
  }) = CustomException;

  const factory AppException.unknown({
    @Default("An unknown error occurred.") String message,
    @Default("Unknown") String prefix,
    int? code,
    Map<String, dynamic>? data,
  }) = UnknownException;
}

extension AppExceptionToFailure on AppException {
  AppFailure toFailure() => switch (this) {
    NoInternetException _ || RequestTimeoutException _ => AppFailure.network(
      message: message,
      code: code,
      data: data,
    ),
    LocalStorageException _ => AppFailure.localStorage(
      message: message,
      code: code,
      data: data,
    ),
    BadRequestException _ ||
    UnauthorizedException _ ||
    InvalidInputException _ ||
    FetchDataException _ ||
    CustomException _ => AppFailure.server(
      message: message,
      code: code,
      data: data,
    ),
    _ => AppFailure.unknown(message: message, code: code, data: data),
  };
}
