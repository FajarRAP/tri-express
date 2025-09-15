class InternalException implements Exception {
  const InternalException({
    String? message,
    this.statusCode = 500,
  }) : message = message ?? 'Internal error occurred';

  final String message;
  final int statusCode;

  @override
  String toString() => 'InternalException: $message (Status code: $statusCode)';
}
