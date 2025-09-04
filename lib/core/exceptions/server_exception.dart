class ServerException implements Exception {
  const ServerException({
    this.message = 'Terjadi Kesalahan Server',
    this.statusCode = 500,
  });

  final String message;
  final int statusCode;

  @override
  String toString() => 'ServerException: $message (Status code: $statusCode)';
}
