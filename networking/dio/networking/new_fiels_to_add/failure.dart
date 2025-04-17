abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  const ServerFailure(String message) : super(message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(String message) : super(message);
}

class LocalStorageFailure extends Failure {
  LocalStorageFailure([super.message = "Local storage failure."]);
}

class UnknownFailure extends Failure {
  const UnknownFailure(String message) : super(message);
}
