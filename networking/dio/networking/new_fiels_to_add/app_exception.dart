class AppException implements Exception {
  final String message;
  final String? prefix;
  final int? code;

  const AppException([
    this.message = 'An unknown error occurred.',
    this.prefix,
    this.code,
  ]);
}

class GeneralException extends AppException {
  const GeneralException([String message = "Something went wrong."])
      : super(message, "General: ");
}

class FetchDataException extends AppException {
  const FetchDataException([String message = "Unable to fetch data."])
      : super(message, "Fetch Error: ");
}

class BadRequestException extends AppException {
  const BadRequestException([String message = "Invalid request."])
      : super(message, "Bad Request: ");
}

class UnauthorisedException extends AppException {
  const UnauthorisedException([String message = "Unauthorized access."])
      : super(message, "Auth Error: ");
}

class InvalidInputException extends AppException {
  const InvalidInputException([String message = "Invalid input provided."])
      : super(message, "Input Error: ");
}

class RequestTimeoutException extends AppException {
  const RequestTimeoutException(
      [String message =
          'Oops! Something took too long to load. Please check your internet and try again.'])
      : super(message);
}

class NoInternetException extends AppException {
  const NoInternetException(
      [String message = "No Internet connection. Please check your network."])
      : super(message, "Network: ");
}

class LocalStorageException extends AppException {
  const LocalStorageException(
      [super.message = "Local storage error occurred."]);
}

class CustomStatusException extends AppException {
  const CustomStatusException(String message)
      : super(message, "Custom Status Error: ");
}

class FakeGPSException extends AppException {
  FakeGPSException([String? message]) : super(message ?? "Fake GPS detected.");
}
