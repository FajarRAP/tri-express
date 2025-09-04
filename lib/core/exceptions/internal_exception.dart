class InternalException implements Exception {
  const InternalException({
    this.message = 'Terjadi Kesalahan Internal',
    this.statusCode = 500,
  });

  final String message;
  final int statusCode;

  @override
  String toString() => 'InternalException: $message (Status code: $statusCode)';
}
