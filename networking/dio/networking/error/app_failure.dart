sealed class AppFailure {
  final String message;
  final int? code;
  final Map<String, dynamic>? data;

  const AppFailure(this.message, this.code, [this.data]);

  @override
  String toString() =>
      '${runtimeType.toString()}: $message (Code: ${code ?? 'N/A'})';
}

class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message, [super.code, super.data]);
}

class ServerFailure extends AppFailure {
  const ServerFailure(super.message, [super.code, super.data]);
}

class LocalStorageFailure extends AppFailure {
  const LocalStorageFailure([
    super.message = "Local storage failure.",
    super.code,
    super.data,
  ]);
}

class UnknownFailure extends AppFailure {
  const UnknownFailure([
    super.message = "An unknown error occurred.",
    super.code,
    super.data,
  ]);
}
