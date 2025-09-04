class CacheException implements Exception {
  const CacheException({
    String? message,
    this.statusCode = 500,
  }) : message = message ?? 'Cache error occurred';

  final String message;
  final int statusCode;

  @override
  String toString() => 'CacheException: $message (Status code: $statusCode)';
}
