class ServerException implements Exception {
  final String message;
  final int? statusCode;
  const ServerException([this.message = 'Error del servidor', this.statusCode]);

  @override
  String toString() => 'ServerException: $message';
}

class NetworkException implements Exception {
  final String message;
  final int? statusCode;

  const NetworkException([this.message = 'Error de red', this.statusCode]);

  @override
  String toString() => 'NetworkException: $message';
}

class TokenExpiredException implements Exception {
  final String message;
  final int? statusCode;

  const TokenExpiredException([
    this.message = 'Sesión expirada',
    this.statusCode,
  ]);

  @override
  String toString() => 'TokenExpiredException: $message';
}

class NotFoundException implements Exception {
  final String message;
  final int? statusCode;

  const NotFoundException([this.message = 'No encontrado', this.statusCode]);

  @override
  String toString() => 'NotFoundException: $message';
}

class CacheException implements Exception {
  final String message;
  final int? statusCode;

  const CacheException([this.message = 'Error de cache', this.statusCode]);

  @override
  String toString() => 'NotFoundException: $message';
}

class AuthenticationException implements Exception {
  final String message;
  final int? statusCode;

  const AuthenticationException([
    this.message = 'Error de autenticación',
    this.statusCode,
  ]);

  @override
  String toString() => 'AuthenticationException: $message';
}
