class ServerException implements Exception {
  const ServerException({
    String? message,
    this.statusCode = 500,
  }) : message = message ?? 'Server error occurred';

  final String message;
  final int statusCode;

  @override
  String toString() => 'ServerException: $message (Status code: $statusCode)';
}
