class ServerException implements Exception {
  final int? statusCode;
  final String message;
  ServerException({this.statusCode, required this.message});
}

class CacheException implements Exception {
  final int? statusCode;
  final String message;
  CacheException({this.statusCode, required this.message});
}

