import 'package:equatable/equatable.dart';

abstract class ApiFailure extends Equatable {
  final String message;
  const ApiFailure({required this.message});

  @override
  List<Object> get props => [message];
}

class ServerFailure extends ApiFailure {
  const ServerFailure({required super.message});
}

class DataBaseFailure extends ApiFailure {
  const DataBaseFailure({required super.message});
}
